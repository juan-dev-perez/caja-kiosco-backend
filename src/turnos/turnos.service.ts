import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CerrarTurnoDto, CreateTurnoDto, UpdateTurnoDto } from './dto';
import { MovimientosService } from '../movimientos/movimientos.service';
import { TurnoEstado } from '../../generated/prisma/enums';

@Injectable()
export class TurnosService {
  constructor(
    private readonly prismaService: PrismaService,
    private readonly movimientosService: MovimientosService,
  ) {}

  private async findTurnoOrThrow(id: number) {
    const turno = await this.prismaService.turno.findUnique({
      where: { id },
    });

    if (!turno) {
      throw new NotFoundException(`Turno con id ${id} no encontrado`);
    }

    return turno;
  }

  async create(createTurnoDto: CreateTurnoDto) {
    return this.prismaService.$transaction(async (tx) => {
      const turno = await tx.turno.create({
        data: {
          fecha: new Date(createTurnoDto.fecha),
          usuario: createTurnoDto.usuario,
          cajaInicial: createTurnoDto.cajaInicial,
          observaciones: createTurnoDto.observaciones,
        },
      });

      const sobresActuales = await tx.sobreActual.findMany();

      if (sobresActuales.length > 0) {
        await tx.sobreTurno.createMany({
          data: sobresActuales.map((sobre) => ({
            turnoId: turno.id,
            tipoSobre: sobre.tipoSobre,
            saldoInicial: sobre.montoActual,
          })),
        });
      }

      return turno;
    });
  }

  async findAll() {
    return this.prismaService.turno.findMany();
  }

  async findOne(id: number) {
    return this.findTurnoOrThrow(id);
  }

  async update(id: number, updateTurnoDto: UpdateTurnoDto) {
    await this.findTurnoOrThrow(id);

    const { fecha, ...data } = updateTurnoDto;

    return this.prismaService.turno.update({
      where: { id },
      data: {
        ...data,
        ...(fecha !== undefined ? { fecha: new Date(fecha) } : {}),
      },
    });
  }

  async cerrarTurno(id: number, cerrarTurnoDto: CerrarTurnoDto) {
    const turno = await this.findTurnoOrThrow(id);

    if (turno.estado !== TurnoEstado.ABIERTO) {
      throw new BadRequestException(
        'Este turno ya se encuentra cerrado, solo se pueden cerrar turnos abiertos',
      );
    }

    return this.prismaService.$transaction(async (tx) => {
    const totalTransferenciasCierre =
      await this.movimientosService.findTransfersByTurnoId(id);

    const sobresTurno = await tx.sobreTurno.findMany({
      where: { turnoId: id },
    });

    const totalSobres = sobresTurno.reduce((acc, sobre) => {
      return acc + Number(sobre.saldoInicial);
    }, 0);

    await Promise.all(
      sobresTurno.map((sobre) =>
        tx.sobreTurno.update({
          where: { id: sobre.id },
          data: {
            saldoFinal: sobre.saldoInicial,
          },
        }),
      ),
    );

    await Promise.all(
      sobresTurno.map((sobre) =>
        tx.sobreActual.update({
          where: { tipoSobre: sobre.tipoSobre },
          data: {
            montoActual: sobre.saldoInicial,
          },
        }),
      ),
    );

    return tx.turno.update({
      where: { id },
      data: {
        cajaFinal: cerrarTurnoDto.cajaFinal,
        retiroEfectivo: cerrarTurnoDto.retiroEfectivo,
        totalTransferenciasCierre,
        totalSobres,
        estado: TurnoEstado.CERRADO,
      },
    });
  });

    // const totalTransferenciasCierre =
    //   await this.movimientosService.findTransfersByTurnoId(id);

    // return this.prismaService.turno.update({
    //   where: { id },
    //   data: {
    //     cajaFinal: cerrarTurnoDto.cajaFinal,
    //     retiroEfectivo: cerrarTurnoDto.retiroEfectivo,
    //     totalTransferenciasCierre,
    //     // totalSobres: cerrarTurnoDto.totalSobres,
    //     estado: TurnoEstado.CERRADO,
    //     observaciones: cerrarTurnoDto.observaciones,
    //   },
    // });
  }

  async remove(id: number) {
    await this.findTurnoOrThrow(id);

    return this.prismaService.turno.update({
      where: { id },
      data: {
        estado: TurnoEstado.ANULADO,
      },
    });
  }
}

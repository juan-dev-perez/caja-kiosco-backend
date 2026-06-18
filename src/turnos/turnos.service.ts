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
    return this.prismaService.turno.create({
      data: {
        fecha: new Date(createTurnoDto.fecha),
        usuario: createTurnoDto.usuario,
        cajaInicial: createTurnoDto.cajaInicial,
        observaciones: createTurnoDto.observaciones,
      },
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
      throw new BadRequestException('Este turno ya se encuentra cerrado, solo se pueden cerrar turnos abiertos');
    }

    const totalTransferenciasCierre =
      await this.movimientosService.findTransfersByTurnoId(id);

    return this.prismaService.turno.update({
      where: { id },
      data: {
        cajaFinal: cerrarTurnoDto.cajaFinal,
        retiroEfectivo: cerrarTurnoDto.retiroEfectivo,
        totalTransferenciasCierre,
        totalSobres: cerrarTurnoDto.totalSobres,
        estado: TurnoEstado.CERRADO,
        observaciones: cerrarTurnoDto.observaciones,
      },
    });
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

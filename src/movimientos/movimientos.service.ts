import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  MovimientoCategoria,
  MovimientoTipo,
} from '../../generated/prisma/enums';
import { CreateMovimientoDto, UpdateMovimientoDto } from './dto';

type FindAllMovimientosFilters = {
  turnoId?: number;
  tipo?: MovimientoTipo;
  categoria?: MovimientoCategoria;
};

@Injectable()
export class MovimientosService {
  constructor(private readonly prismaService: PrismaService) {}

  private async findMovimientoOrThrow(id: number) {
    const movimiento = await this.prismaService.movimiento.findUnique({
      where: { id },
    });

    if (!movimiento) {
      throw new NotFoundException(`Movimiento con id ${id} no encontrado`);
    }

    return movimiento;
  }

  async create(createMovimientoDto: CreateMovimientoDto) {
    return this.prismaService.movimiento.create({
      data: {
        turnoId: createMovimientoDto.turnoId,
        tipo: createMovimientoDto.tipo,
        categoria: createMovimientoDto.categoria,
        medioPago: createMovimientoDto.medioPago,
        monto: createMovimientoDto.monto,
        descripcion: createMovimientoDto.descripcion,
      },
    });
  }

  async findAll(filters: FindAllMovimientosFilters = {}) {
    const { turnoId, tipo, categoria } = filters;

    return this.prismaService.movimiento.findMany({
      where: {
        ...(turnoId !== undefined ? { turnoId } : {}),
        ...(tipo !== undefined ? { tipo } : {}),
        ...(categoria !== undefined ? { categoria } : {}),
      },
    });
  }

  async findTransfersByTurnoId(turnoId: number) {
    const result = await this.prismaService.movimiento.aggregate({
      where: {
        turnoId,
        tipo: 'INGRESO',
        categoria: 'TRANSFERENCIA',
      },
      _sum: {
        monto: true,
      },
    });

    return result._sum.monto?.toNumber() ?? 0;
  }

  async findOne(id: number) {
    return this.findMovimientoOrThrow(id);
  }

  async update(id: number, updateMovimientoDto: UpdateMovimientoDto) {
    await this.findMovimientoOrThrow(id);

    return this.prismaService.movimiento.update({
      where: { id },
      data: updateMovimientoDto,
    });
  }

  async remove(id: number) {
    await this.findMovimientoOrThrow(id);

    return this.prismaService.movimiento.delete({
      where: { id },
    });
  }
}

import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateTurnoDto } from './dto/create-turno.dto';
import { UpdateTurnoDto } from './dto/update-turno.dto';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class TurnosService {
  constructor(private readonly prismaService: PrismaService) {}

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

  async remove(id: number) {
    await this.findTurnoOrThrow(id);

    return this.prismaService.turno.update({
      where: { id },
      data: {
        estado: 'ANULADO',
      },
    });
  }
}

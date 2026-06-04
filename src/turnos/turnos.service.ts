import { Injectable } from '@nestjs/common';
import { CreateTurnoDto } from './dto/create-turno.dto';
import { UpdateTurnoDto } from './dto/update-turno.dto';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class TurnosService {

  constructor(
    private readonly prismaService: PrismaService 
  ) {}

  create(createTurnoDto: CreateTurnoDto) {
    return 'This action adds a new turno';
  }

  async findAll() {
    return await this.prismaService.turno.findMany();
  }

  async findOne(id: number) {
    return await this.prismaService.turno.findUnique({
      where: { id },
    });
  }

  update(id: number, updateTurnoDto: UpdateTurnoDto) {
    return `This action updates a #${id} turno`;
  }

  remove(id: number) {
    return `This action removes a #${id} turno`;
  }
}

import { Module } from '@nestjs/common';
import { TurnosService } from './turnos.service';
import { TurnosController } from './turnos.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { MovimientosModule } from '../movimientos/movimientos.module';

@Module({
  imports: [PrismaModule, MovimientosModule],
  controllers: [TurnosController],
  providers: [TurnosService],
})
export class TurnosModule {}

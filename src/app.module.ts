import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './prisma/prisma.module';
import { TurnosModule } from './turnos/turnos.module';
import { MovimientosModule } from './movimientos/movimientos.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    PrismaModule,
    TurnosModule,
    MovimientosModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}

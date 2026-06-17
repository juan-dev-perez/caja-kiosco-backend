import { Type } from 'class-transformer';
import { IsEnum, IsNotEmpty, IsNumber, IsOptional, IsString, MaxLength, Min } from 'class-validator';
import { MedioPago, MovimientoCategoria, MovimientoTipo } from '../../../generated/prisma/enums';

export class CreateMovimientoDto {
  @Type(() => Number)
  @IsNumber()
  @Min(1)
  turnoId!: number;

  @IsEnum(MovimientoTipo)
  @IsNotEmpty()
  tipo!: MovimientoTipo;

  @IsEnum(MovimientoCategoria)
  @IsNotEmpty()
  categoria!: MovimientoCategoria;

  @IsEnum(MedioPago)
  @IsNotEmpty()
  medioPago!: MedioPago;

  @Type(() => Number)
  @IsNumber()
  @Min(0)
  monto!: number;

  @IsString()
  @IsOptional()
  @MaxLength(500)
  descripcion?: string;
}

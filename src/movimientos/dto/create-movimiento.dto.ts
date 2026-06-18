import { Type } from 'class-transformer';
import { IsEnum, IsNotEmpty, IsNumber, IsOptional, IsString, MaxLength, Min } from 'class-validator';
import { MedioPago, MovimientoCategoria } from '../../../generated/prisma/enums';

export class CreateMovimientoDto {
  @Type(() => Number)
  @IsNumber()
  @Min(1)
  turnoId!: number;

  @IsEnum(MovimientoCategoria)
  @IsNotEmpty()
  categoria!: MovimientoCategoria;

  @Type(() => Number)
  @IsNumber()
  @Min(0)
  monto!: number;

  @IsString()
  @IsOptional()
  @MaxLength(500)
  descripcion?: string;
}

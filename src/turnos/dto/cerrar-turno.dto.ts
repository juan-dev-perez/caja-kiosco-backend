import { Type } from "class-transformer";
import { IsNotEmpty, IsNumber, IsOptional, IsString, MaxLength, Min } from "class-validator";

export class CerrarTurnoDto {
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  @IsNotEmpty()
  cajaFinal!: number;

  @Type(() => Number)
  @IsNumber()
  @Min(0)
  @IsNotEmpty()
  retiroEfectivo!: number;

  @IsString()
  @IsOptional()
  @MaxLength(500)
  observaciones?: string;
}

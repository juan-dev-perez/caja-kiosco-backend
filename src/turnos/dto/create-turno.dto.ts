import { Type } from "class-transformer";
import { IsDateString, IsNotEmpty, IsNumber, IsOptional, IsString, MaxLength, Min } from "class-validator";

export class CreateTurnoDto {
  @IsDateString()
  @IsNotEmpty()
  fecha!: string;

  @IsString()
  @IsNotEmpty()
  @MaxLength(50)
  usuario!: string;

  @Type(() => Number)
  @IsNumber()
  @Min(0)
  cajaInicial!: number;

  @IsString()
  @IsOptional()
  @MaxLength(500)
  observaciones?: string;
}

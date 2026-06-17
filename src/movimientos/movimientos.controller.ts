import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  ParseIntPipe,
  Query,
  ParseEnumPipe,
} from '@nestjs/common';
import { MovimientosService } from './movimientos.service';
import { CreateMovimientoDto } from './dto/create-movimiento.dto';
import { UpdateMovimientoDto } from './dto/update-movimiento.dto';
import {
  MovimientoCategoria,
  MovimientoTipo,
} from '../../generated/prisma/enums';

@Controller('movimientos')
export class MovimientosController {
  constructor(private readonly movimientosService: MovimientosService) {}

  @Post()
  create(@Body() createMovimientoDto: CreateMovimientoDto) {
    return this.movimientosService.create(createMovimientoDto);
  }

  @Get()
  findAll(
    @Query('turnoId', new ParseIntPipe({ optional: true })) turnoId?: number,
    @Query('tipo', new ParseEnumPipe(MovimientoTipo, { optional: true }))
    tipo?: MovimientoTipo,
    @Query(
      'categoria',
      new ParseEnumPipe(MovimientoCategoria, { optional: true }),
    )
    categoria?: MovimientoCategoria,
  ) {
    return this.movimientosService.findAll({ turnoId, tipo, categoria });
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.movimientosService.findOne(id);
  }

  @Patch(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateMovimientoDto: UpdateMovimientoDto,
  ) {
    return this.movimientosService.update(id, updateMovimientoDto);
  }

  @Delete(':id')
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.movimientosService.remove(id);
  }
}

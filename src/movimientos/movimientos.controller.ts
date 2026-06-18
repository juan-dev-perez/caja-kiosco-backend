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
import { MovimientoCategoria } from '../../generated/prisma/enums';
import { CreateMovimientoDto, UpdateMovimientoDto } from './dto';

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
    @Query(
      'categoria',
      new ParseEnumPipe(MovimientoCategoria, { optional: true }),
    )
    categoria?: MovimientoCategoria,
  ) {
    return this.movimientosService.findAll({ turnoId, categoria });
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.movimientosService.findOne(id);
  }

  @Get(':turnoId/total-transferencias')
  findTransfersByTurnoId(@Param('turnoId', ParseIntPipe) turnoId: number) {
    return this.movimientosService.findTransfersByTurnoId(turnoId);
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

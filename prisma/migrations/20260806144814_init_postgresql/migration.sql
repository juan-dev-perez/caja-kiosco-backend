-- CreateEnum
CREATE TYPE "TurnoEstado" AS ENUM ('ABIERTO', 'CERRADO', 'ANULADO');

-- CreateEnum
CREATE TYPE "MovimientoCategoria" AS ENUM ('RECARGAS', 'CIGARRILLOS', 'JUGUETES', 'TRANSFERENCIAS', 'GASTOS');

-- CreateEnum
CREATE TYPE "TipoSobre" AS ENUM ('RECARGAS', 'CIGARRILLOS', 'JUGUETES');

-- CreateEnum
CREATE TYPE "PrestamoEnvaseEstado" AS ENUM ('PENDIENTE', 'DEVUELTO', 'CANCELADO');

-- CreateEnum
CREATE TYPE "MovimientoCigarrilloTipo" AS ENUM ('VENTA', 'REPOSICION');

-- CreateEnum
CREATE TYPE "MedioPago" AS ENUM ('EFECTIVO', 'TRANSFERENCIA');

-- CreateEnum
CREATE TYPE "CategoriaStock" AS ENUM ('CIGARRILLOS', 'JUGUETES', 'OTRO');

-- CreateEnum
CREATE TYPE "TipoCigarrillo" AS ENUM ('MARLBORO_CRAFTED', 'RED_POINT', 'RED_POINT_SIX');

-- CreateTable
CREATE TABLE "Turno" (
    "id" SERIAL NOT NULL,
    "fecha" TIMESTAMP(3) NOT NULL,
    "usuario" TEXT NOT NULL,
    "cajaInicial" DECIMAL(65,30) NOT NULL,
    "cajaFinal" DECIMAL(65,30),
    "retiroEfectivo" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "totalTransferenciasCierre" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "totalSobres" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "estado" "TurnoEstado" NOT NULL DEFAULT 'ABIERTO',
    "observaciones" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Turno_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Movimiento" (
    "id" SERIAL NOT NULL,
    "turnoId" INTEGER NOT NULL,
    "categoria" "MovimientoCategoria" NOT NULL,
    "monto" DECIMAL(65,30) NOT NULL,
    "descripcion" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Movimiento_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SobreTurno" (
    "id" SERIAL NOT NULL,
    "turnoId" INTEGER NOT NULL,
    "tipoSobre" "TipoSobre" NOT NULL,
    "saldoInicial" DECIMAL(65,30) NOT NULL,
    "saldoFinal" DECIMAL(65,30),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SobreTurno_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SobreActual" (
    "id" SERIAL NOT NULL,
    "tipoSobre" "TipoSobre" NOT NULL,
    "montoActual" DECIMAL(65,30) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SobreActual_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SobreHistorial" (
    "id" SERIAL NOT NULL,
    "turnoId" INTEGER NOT NULL,
    "tipoSobre" "TipoSobre" NOT NULL,
    "montoAnterior" DECIMAL(65,30) NOT NULL,
    "montoNuevo" DECIMAL(65,30) NOT NULL,
    "diferencia" DECIMAL(65,30) NOT NULL,
    "observaciones" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SobreHistorial_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StockItem" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "categoria" "CategoriaStock" NOT NULL DEFAULT 'CIGARRILLOS',
    "cantidadActual" INTEGER NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "StockItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StockItemTurno" (
    "id" SERIAL NOT NULL,
    "turnoId" INTEGER NOT NULL,
    "stockItemId" INTEGER NOT NULL,
    "cantidadInicial" INTEGER NOT NULL,
    "cantidadFinal" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "StockItemTurno_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StockHistorial" (
    "id" SERIAL NOT NULL,
    "turnoId" INTEGER NOT NULL,
    "stockItemId" INTEGER NOT NULL,
    "cantidadAnterior" INTEGER NOT NULL,
    "cantidadNueva" INTEGER NOT NULL,
    "diferencia" INTEGER NOT NULL,
    "observaciones" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "StockHistorial_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PrestamoEnvase" (
    "id" SERIAL NOT NULL,
    "nombrePersona" TEXT NOT NULL,
    "observaciones" TEXT,
    "cantidadEnvases" INTEGER NOT NULL DEFAULT 1,
    "montoPrestamo" DECIMAL(65,30),
    "estado" "PrestamoEnvaseEstado" NOT NULL DEFAULT 'PENDIENTE',
    "turnoCreacionId" INTEGER,
    "turnoCierreId" INTEGER,
    "fechaCierre" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PrestamoEnvase_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MovimientoCigarrillo" (
    "id" SERIAL NOT NULL,
    "turnoId" INTEGER NOT NULL,
    "tipoMovimiento" "MovimientoCigarrilloTipo" NOT NULL,
    "tipoCigarrillo" "TipoCigarrillo" NOT NULL,
    "medioPago" "MedioPago" NOT NULL,
    "cantidad" INTEGER NOT NULL DEFAULT 1,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MovimientoCigarrillo_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Turno_fecha_idx" ON "Turno"("fecha");

-- CreateIndex
CREATE INDEX "Turno_estado_fecha_idx" ON "Turno"("estado", "fecha");

-- CreateIndex
CREATE INDEX "Movimiento_turnoId_idx" ON "Movimiento"("turnoId");

-- CreateIndex
CREATE INDEX "Movimiento_categoria_idx" ON "Movimiento"("categoria");

-- CreateIndex
CREATE INDEX "Movimiento_createdAt_idx" ON "Movimiento"("createdAt");

-- CreateIndex
CREATE INDEX "Movimiento_updatedAt_idx" ON "Movimiento"("updatedAt");

-- CreateIndex
CREATE INDEX "SobreTurno_turnoId_idx" ON "SobreTurno"("turnoId");

-- CreateIndex
CREATE UNIQUE INDEX "SobreTurno_turnoId_tipoSobre_key" ON "SobreTurno"("turnoId", "tipoSobre");

-- CreateIndex
CREATE UNIQUE INDEX "SobreActual_tipoSobre_key" ON "SobreActual"("tipoSobre");

-- CreateIndex
CREATE INDEX "SobreHistorial_turnoId_idx" ON "SobreHistorial"("turnoId");

-- CreateIndex
CREATE INDEX "SobreHistorial_tipoSobre_idx" ON "SobreHistorial"("tipoSobre");

-- CreateIndex
CREATE INDEX "SobreHistorial_createdAt_idx" ON "SobreHistorial"("createdAt");

-- CreateIndex
CREATE INDEX "SobreHistorial_updatedAt_idx" ON "SobreHistorial"("updatedAt");

-- CreateIndex
CREATE UNIQUE INDEX "StockItem_nombre_key" ON "StockItem"("nombre");

-- CreateIndex
CREATE INDEX "StockItemTurno_turnoId_idx" ON "StockItemTurno"("turnoId");

-- CreateIndex
CREATE INDEX "StockItemTurno_stockItemId_idx" ON "StockItemTurno"("stockItemId");

-- CreateIndex
CREATE UNIQUE INDEX "StockItemTurno_turnoId_stockItemId_key" ON "StockItemTurno"("turnoId", "stockItemId");

-- CreateIndex
CREATE INDEX "StockHistorial_turnoId_idx" ON "StockHistorial"("turnoId");

-- CreateIndex
CREATE INDEX "StockHistorial_stockItemId_idx" ON "StockHistorial"("stockItemId");

-- CreateIndex
CREATE INDEX "StockHistorial_createdAt_idx" ON "StockHistorial"("createdAt");

-- CreateIndex
CREATE INDEX "StockHistorial_updatedAt_idx" ON "StockHistorial"("updatedAt");

-- CreateIndex
CREATE INDEX "PrestamoEnvase_estado_idx" ON "PrestamoEnvase"("estado");

-- CreateIndex
CREATE INDEX "PrestamoEnvase_turnoCreacionId_idx" ON "PrestamoEnvase"("turnoCreacionId");

-- CreateIndex
CREATE INDEX "PrestamoEnvase_turnoCierreId_idx" ON "PrestamoEnvase"("turnoCierreId");

-- CreateIndex
CREATE INDEX "PrestamoEnvase_fechaCierre_idx" ON "PrestamoEnvase"("fechaCierre");

-- CreateIndex
CREATE INDEX "PrestamoEnvase_createdAt_idx" ON "PrestamoEnvase"("createdAt");

-- CreateIndex
CREATE INDEX "PrestamoEnvase_updatedAt_idx" ON "PrestamoEnvase"("updatedAt");

-- CreateIndex
CREATE INDEX "MovimientoCigarrillo_turnoId_idx" ON "MovimientoCigarrillo"("turnoId");

-- CreateIndex
CREATE INDEX "MovimientoCigarrillo_tipoCigarrillo_idx" ON "MovimientoCigarrillo"("tipoCigarrillo");

-- CreateIndex
CREATE INDEX "MovimientoCigarrillo_tipoMovimiento_idx" ON "MovimientoCigarrillo"("tipoMovimiento");

-- CreateIndex
CREATE INDEX "MovimientoCigarrillo_medioPago_idx" ON "MovimientoCigarrillo"("medioPago");

-- CreateIndex
CREATE INDEX "MovimientoCigarrillo_createdAt_idx" ON "MovimientoCigarrillo"("createdAt");

-- CreateIndex
CREATE INDEX "MovimientoCigarrillo_updatedAt_idx" ON "MovimientoCigarrillo"("updatedAt");

-- AddForeignKey
ALTER TABLE "Movimiento" ADD CONSTRAINT "Movimiento_turnoId_fkey" FOREIGN KEY ("turnoId") REFERENCES "Turno"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SobreTurno" ADD CONSTRAINT "SobreTurno_turnoId_fkey" FOREIGN KEY ("turnoId") REFERENCES "Turno"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SobreHistorial" ADD CONSTRAINT "SobreHistorial_turnoId_fkey" FOREIGN KEY ("turnoId") REFERENCES "Turno"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StockItemTurno" ADD CONSTRAINT "StockItemTurno_turnoId_fkey" FOREIGN KEY ("turnoId") REFERENCES "Turno"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StockItemTurno" ADD CONSTRAINT "StockItemTurno_stockItemId_fkey" FOREIGN KEY ("stockItemId") REFERENCES "StockItem"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StockHistorial" ADD CONSTRAINT "StockHistorial_turnoId_fkey" FOREIGN KEY ("turnoId") REFERENCES "Turno"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StockHistorial" ADD CONSTRAINT "StockHistorial_stockItemId_fkey" FOREIGN KEY ("stockItemId") REFERENCES "StockItem"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PrestamoEnvase" ADD CONSTRAINT "PrestamoEnvase_turnoCreacionId_fkey" FOREIGN KEY ("turnoCreacionId") REFERENCES "Turno"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PrestamoEnvase" ADD CONSTRAINT "PrestamoEnvase_turnoCierreId_fkey" FOREIGN KEY ("turnoCierreId") REFERENCES "Turno"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovimientoCigarrillo" ADD CONSTRAINT "MovimientoCigarrillo_turnoId_fkey" FOREIGN KEY ("turnoId") REFERENCES "Turno"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

/*
  Warnings:

  - Added the required column `cajaInicial` to the `Turno` table without a default value. This is not possible if the table is not empty.
  - Added the required column `fecha` to the `Turno` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `Turno` table without a default value. This is not possible if the table is not empty.
  - Added the required column `usuario` to the `Turno` table without a default value. This is not possible if the table is not empty.

*/
-- CreateTable
CREATE TABLE "Movimiento" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "turnoId" INTEGER NOT NULL,
    "tipo" TEXT NOT NULL,
    "categoria" TEXT NOT NULL,
    "monto" DECIMAL NOT NULL,
    "descripcion" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Movimiento_turnoId_fkey" FOREIGN KEY ("turnoId") REFERENCES "Turno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "SobreTurno" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "turnoId" INTEGER NOT NULL,
    "tipoSobre" TEXT NOT NULL,
    "saldoInicial" DECIMAL NOT NULL,
    "saldoFinal" DECIMAL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "SobreTurno_turnoId_fkey" FOREIGN KEY ("turnoId") REFERENCES "Turno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "SobreActual" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "tipoSobre" TEXT NOT NULL,
    "montoActual" DECIMAL NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "SobreHistorial" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "turnoId" INTEGER NOT NULL,
    "tipoSobre" TEXT NOT NULL,
    "montoAnterior" DECIMAL NOT NULL,
    "montoNuevo" DECIMAL NOT NULL,
    "diferencia" DECIMAL NOT NULL,
    "observaciones" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "SobreHistorial_turnoId_fkey" FOREIGN KEY ("turnoId") REFERENCES "Turno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "StockItem" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nombre" TEXT NOT NULL,
    "categoria" TEXT NOT NULL DEFAULT 'CIGARRILLOS',
    "cantidadActual" INTEGER NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "StockItemTurno" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "turnoId" INTEGER NOT NULL,
    "stockItemId" INTEGER NOT NULL,
    "cantidadInicial" INTEGER NOT NULL,
    "cantidadFinal" INTEGER,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "StockItemTurno_turnoId_fkey" FOREIGN KEY ("turnoId") REFERENCES "Turno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "StockItemTurno_stockItemId_fkey" FOREIGN KEY ("stockItemId") REFERENCES "StockItem" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "StockHistorial" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "turnoId" INTEGER NOT NULL,
    "stockItemId" INTEGER NOT NULL,
    "cantidadAnterior" INTEGER NOT NULL,
    "cantidadNueva" INTEGER NOT NULL,
    "diferencia" INTEGER NOT NULL,
    "observaciones" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "StockHistorial_turnoId_fkey" FOREIGN KEY ("turnoId") REFERENCES "Turno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "StockHistorial_stockItemId_fkey" FOREIGN KEY ("stockItemId") REFERENCES "StockItem" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "PrestamoEnvase" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nombrePersona" TEXT NOT NULL,
    "observaciones" TEXT,
    "cantidadEnvases" INTEGER NOT NULL DEFAULT 1,
    "montoPrestamo" DECIMAL,
    "estado" TEXT NOT NULL DEFAULT 'PENDIENTE',
    "turnoCreacionId" INTEGER,
    "turnoCierreId" INTEGER,
    "fechaCierre" DATETIME,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "PrestamoEnvase_turnoCreacionId_fkey" FOREIGN KEY ("turnoCreacionId") REFERENCES "Turno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "PrestamoEnvase_turnoCierreId_fkey" FOREIGN KEY ("turnoCierreId") REFERENCES "Turno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "MovimientoCigarrillo" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "turnoId" INTEGER NOT NULL,
    "tipoMovimiento" TEXT NOT NULL,
    "tipoCigarrillo" TEXT NOT NULL,
    "medioPago" TEXT NOT NULL,
    "cantidad" INTEGER NOT NULL DEFAULT 1,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "MovimientoCigarrillo_turnoId_fkey" FOREIGN KEY ("turnoId") REFERENCES "Turno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Turno" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "fecha" DATETIME NOT NULL,
    "usuario" TEXT NOT NULL,
    "cajaInicial" DECIMAL NOT NULL,
    "cajaFinal" DECIMAL,
    "retiroEfectivo" DECIMAL NOT NULL DEFAULT 0,
    "totalSobres" DECIMAL NOT NULL DEFAULT 0,
    "estado" TEXT NOT NULL DEFAULT 'ABIERTO',
    "observaciones" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);
INSERT INTO "new_Turno" ("id") SELECT "id" FROM "Turno";
DROP TABLE "Turno";
ALTER TABLE "new_Turno" RENAME TO "Turno";
CREATE INDEX "Turno_fecha_idx" ON "Turno"("fecha");
CREATE INDEX "Turno_estado_fecha_idx" ON "Turno"("estado", "fecha");
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;

-- CreateIndex
CREATE INDEX "Movimiento_turnoId_idx" ON "Movimiento"("turnoId");

-- CreateIndex
CREATE INDEX "Movimiento_tipo_idx" ON "Movimiento"("tipo");

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

/*
  Warnings:

  - Added the required column `medioPago` to the `Movimiento` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Movimiento" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "turnoId" INTEGER NOT NULL,
    "tipo" TEXT NOT NULL,
    "categoria" TEXT NOT NULL,
    "medioPago" TEXT NOT NULL,
    "monto" DECIMAL NOT NULL,
    "descripcion" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Movimiento_turnoId_fkey" FOREIGN KEY ("turnoId") REFERENCES "Turno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Movimiento" ("categoria", "createdAt", "descripcion", "id", "monto", "tipo", "turnoId", "updatedAt") SELECT "categoria", "createdAt", "descripcion", "id", "monto", "tipo", "turnoId", "updatedAt" FROM "Movimiento";
DROP TABLE "Movimiento";
ALTER TABLE "new_Movimiento" RENAME TO "Movimiento";
CREATE INDEX "Movimiento_turnoId_idx" ON "Movimiento"("turnoId");
CREATE INDEX "Movimiento_tipo_idx" ON "Movimiento"("tipo");
CREATE INDEX "Movimiento_categoria_idx" ON "Movimiento"("categoria");
CREATE INDEX "Movimiento_createdAt_idx" ON "Movimiento"("createdAt");
CREATE INDEX "Movimiento_updatedAt_idx" ON "Movimiento"("updatedAt");
CREATE TABLE "new_Turno" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "fecha" DATETIME NOT NULL,
    "usuario" TEXT NOT NULL,
    "cajaInicial" DECIMAL NOT NULL,
    "cajaFinal" DECIMAL,
    "retiroEfectivo" DECIMAL NOT NULL DEFAULT 0,
    "totalTransferenciasCierre" DECIMAL NOT NULL DEFAULT 0,
    "totalSobres" DECIMAL NOT NULL DEFAULT 0,
    "estado" TEXT NOT NULL DEFAULT 'ABIERTO',
    "observaciones" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);
INSERT INTO "new_Turno" ("cajaFinal", "cajaInicial", "createdAt", "estado", "fecha", "id", "observaciones", "retiroEfectivo", "totalSobres", "updatedAt", "usuario") SELECT "cajaFinal", "cajaInicial", "createdAt", "estado", "fecha", "id", "observaciones", "retiroEfectivo", "totalSobres", "updatedAt", "usuario" FROM "Turno";
DROP TABLE "Turno";
ALTER TABLE "new_Turno" RENAME TO "Turno";
CREATE INDEX "Turno_fecha_idx" ON "Turno"("fecha");
CREATE INDEX "Turno_estado_fecha_idx" ON "Turno"("estado", "fecha");
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;

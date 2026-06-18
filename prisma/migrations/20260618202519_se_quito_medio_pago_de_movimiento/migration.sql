/*
  Warnings:

  - You are about to drop the column `medioPago` on the `Movimiento` table. All the data in the column will be lost.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Movimiento" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "turnoId" INTEGER NOT NULL,
    "categoria" TEXT NOT NULL,
    "monto" DECIMAL NOT NULL,
    "descripcion" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Movimiento_turnoId_fkey" FOREIGN KEY ("turnoId") REFERENCES "Turno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Movimiento" ("categoria", "createdAt", "descripcion", "id", "monto", "turnoId", "updatedAt") SELECT "categoria", "createdAt", "descripcion", "id", "monto", "turnoId", "updatedAt" FROM "Movimiento";
DROP TABLE "Movimiento";
ALTER TABLE "new_Movimiento" RENAME TO "Movimiento";
CREATE INDEX "Movimiento_turnoId_idx" ON "Movimiento"("turnoId");
CREATE INDEX "Movimiento_categoria_idx" ON "Movimiento"("categoria");
CREATE INDEX "Movimiento_createdAt_idx" ON "Movimiento"("createdAt");
CREATE INDEX "Movimiento_updatedAt_idx" ON "Movimiento"("updatedAt");
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;

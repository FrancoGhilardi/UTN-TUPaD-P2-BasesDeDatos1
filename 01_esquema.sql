-- =========================================================================
-- Etapa 1: Modelo Lógico y Físico (Esquema y Constraints)
-- =========================================================================

-- -------------------------------------------------------------------------
-- Creación del esquema / base de datos
-- -------------------------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `TPIntegradorProgramación2yBaseDeDatos1`
    DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

USE `TPIntegradorProgramación2yBaseDeDatos1`;

-- -------------------------------------------------------------------------
-- Eliminación preventiva de tablas (idempotencia)
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS `Empleado`;
DROP TABLE IF EXISTS `Legajo`;

-- -------------------------------------------------------------------------
-- Tabla: Legajo
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Legajo` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `eliminado` BOOLEAN NOT NULL DEFAULT 0,
    `nroLegajo` VARCHAR(20) NOT NULL,
    `categoria` VARCHAR(30) DEFAULT NULL,
    `estado` ENUM('ACTIVO', 'INACTIVO') NOT NULL,
    `fechaAlta` DATE NOT NULL,
    `observaciones` VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE (`nroLegajo`),
    CHECK (`eliminado` IN (0, 1))
    ) ENGINE = InnoDB;

-- -------------------------------------------------------------------------
-- Tabla: Empleado
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Empleado` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `eliminado` BOOLEAN NOT NULL DEFAULT 0,
    `nombre` VARCHAR(80) NOT NULL,
    `apellido` VARCHAR(80) NOT NULL,
    `dni` VARCHAR(15) NOT NULL,
    `email` VARCHAR(120) DEFAULT NULL,
    `fechaIngreso` DATE NOT NULL,
    `area` VARCHAR(50) DEFAULT NULL,
    `legajo` BIGINT NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE (`dni`),
    UNIQUE (`legajo`),
    CONSTRAINT `fk_Empleado_Legajo`
    FOREIGN KEY (`legajo`)
    REFERENCES `Legajo` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    CHECK (`eliminado` IN (0, 1))
    ) ENGINE = InnoDB;

-- -------------------------------------------------------------------------
-- Comentarios finales
-- -------------------------------------------------------------------------
-- ✓ Cada empleado tiene un legajo asociado (relación 1 a 1).
-- ✓ No se permiten empleados sin legajo.
-- ✓ Se aplica baja lógica mediante el campo "eliminado".
-- ✓ El script es idempotente y cumple las reglas de dominio establecidas.

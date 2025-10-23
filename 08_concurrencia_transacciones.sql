-- Simulación de deadlock
-- Sesión A
START TRANSACTION;
UPDATE Empleado SET area = 'RRHH' WHERE id = 1;

-- Sesión B (en paralelo)
START TRANSACTION;
UPDATE Empleado SET area = 'IT' WHERE id = 2;

-- Cruce de bloqueos
-- Sesión A
UPDATE Empleado SET area = 'RRHH' WHERE id = 2;

-- Sesión B
UPDATE Empleado SET area = 'IT' WHERE id = 1;

-- Procedimiento con retry ante deadlock
DELIMITER $$
CREATE PROCEDURE transaccion_segura()
BEGIN
  DECLARE intento INT DEFAULT 0;
  DECLARE exito BOOLEAN DEFAULT FALSE;

  WHILE intento < 3 AND NOT exito DO
    BEGIN
      DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
      BEGIN
        SET intento = intento + 1;
        DO SLEEP(1); -- backoff
      END;

      START TRANSACTION;
      UPDATE Empleado SET area = 'Auditoría' WHERE id = 1;
      COMMIT;
      SET exito = TRUE;
    END;
  END WHILE;
END $$
DELIMITER ;

-- Comparación de niveles de aislamiento
-- Preparación
CREATE TABLE IF NOT EXISTS AislamientoTest (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50),
  eliminado BOOLEAN DEFAULT 0
);

INSERT INTO AislamientoTest (nombre) VALUES ('Juan'), ('Ana'), ('Luis');

-- Sesión 1 - READ COMMITTED
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT * FROM AislamientoTest WHERE eliminado = 0;

-- Sesión 2 (en paralelo)
UPDATE AislamientoTest SET eliminado = 1 WHERE nombre = 'Ana';
COMMIT;

-- Sesión 1 vuelve a consultar
SELECT * FROM AislamientoTest WHERE eliminado = 0;

-- Sesión 1 - REPEATABLE READ
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT * FROM AislamientoTest WHERE eliminado = 0;

-- Sesión 2 (mismo UPDATE)
UPDATE AislamientoTest SET eliminado = 1 WHERE nombre = 'Ana';
COMMIT;

-- Sesión 1 vuelve a consultar
SELECT * FROM AislamientoTest WHERE eliminado = 0;
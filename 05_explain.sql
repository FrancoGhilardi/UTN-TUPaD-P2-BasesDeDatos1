USE `TPIntegradorProgramación2yBaseDeDatos1`;

-- Creacion de indices:

-- Índice en la columna 'area' de Empleado
CREATE INDEX idx_empleado_area ON Empleado(area);

-- Índice en la columna 'fechaIngreso' de Empleado
CREATE INDEX idx_empleado_fechaIngreso ON Empleado(fechaIngreso);

-- Índice en la columna 'categoria' de Legajo
CREATE INDEX idx_legajo_categoria ON Legajo(categoria);

-- Índice en la columna 'estado' de Legajo
CREATE INDEX idx_legajo_estado ON Legajo(estado);

-- Mostrar índices
SHOW INDEX FROM Empleado;
SHOW INDEX FROM Legajo;

-- MEDICIÓN 1: Búsqueda por área (IGUALDAD)

-- Activar medición de tiempos
SET profiling = 1;

-- CON ÍNDICE

-- Ejecutar 3 veces
SELECT COUNT(*) FROM Empleado WHERE area = 'IT' AND eliminado = 0;

-- Ver tiempos CON índice
SHOW PROFILES;

-- Explain CON índice
EXPLAIN SELECT * FROM Empleado WHERE area = 'IT' AND eliminado = 0;

-- SIN ÍNDICE
-- Eliminar índice temporalmente
DROP INDEX idx_empleado_area ON Empleado;

-- Ejecutar 3 veces
SELECT COUNT(*) FROM Empleado WHERE area = 'IT' AND eliminado = 0;

-- Ver tiempos SIN índice
SHOW PROFILES;

-- Explain SIN índice
EXPLAIN SELECT * FROM Empleado WHERE area = 'IT' AND eliminado = 0;

-- Recrear el índice
CREATE INDEX idx_empleado_area ON Empleado(area);

-- Desactivar profiling
SET profiling = 0;
-- ------------------------------------------ --

-- MEDICIÓN 2: Búsqueda por rango de fechas

SET profiling = 1;

-- CON ÍNDICE

-- Ejecutar 3 veces
SELECT COUNT(*) 
FROM Empleado 
WHERE fechaIngreso BETWEEN '2020-01-01' AND '2023-12-31' 
  AND eliminado = 0;

-- Ver tiempos CON índice
SHOW PROFILES;

-- Explain CON índice
EXPLAIN 
SELECT * 
FROM Empleado 
WHERE fechaIngreso BETWEEN '2020-01-01' AND '2023-12-31' 
  AND eliminado = 0;

-- SIN ÍNDICE
DROP INDEX idx_empleado_fechaIngreso ON Empleado;

-- Ejecutar 3 veces
SELECT COUNT(*) 
FROM Empleado 
WHERE fechaIngreso BETWEEN '2020-01-01' AND '2023-12-31' 
  AND eliminado = 0;

-- Ver tiempos SIN índice
SHOW PROFILES;

-- Explain SIN índice
EXPLAIN 
SELECT * 
FROM Empleado 
WHERE fechaIngreso BETWEEN '2020-01-01' AND '2023-12-31' 
  AND eliminado = 0;

-- Recrear el índice
CREATE INDEX idx_empleado_fechaIngreso ON Empleado(fechaIngreso);

SET profiling = 0;
-- ------------------------------------------ --

-- MEDICIÓN 3: JOIN con filtro por categoría

SET profiling = 1;

-- CON ÍNDICE

-- Ejecutar 3 veces
SELECT COUNT(*) 
FROM Empleado e
INNER JOIN Legajo l ON e.legajo = l.id
WHERE l.categoria = 'SR' 
  AND e.eliminado = 0 
  AND l.eliminado = 0;

-- Ver tiempos CON índice
SHOW PROFILES;

-- Explain CON índice
EXPLAIN 
SELECT e.nombre, e.apellido, l.nroLegajo 
FROM Empleado e
INNER JOIN Legajo l ON e.legajo = l.id
WHERE l.categoria = 'SR' 
  AND e.eliminado = 0 
  AND l.eliminado = 0;

-- SIN ÍNDICE
DROP INDEX idx_legajo_categoria ON Legajo;

-- Ejecutar 3 veces
SELECT COUNT(*) 
FROM Empleado e
INNER JOIN Legajo l ON e.legajo = l.id
WHERE l.categoria = 'SR' 
  AND e.eliminado = 0 
  AND l.eliminado = 0;

-- Ver tiempos SIN índice
SHOW PROFILES;

-- Explain SIN índice
EXPLAIN 
SELECT e.nombre, e.apellido, l.nroLegajo 
FROM Empleado e
INNER JOIN Legajo l ON e.legajo = l.id
WHERE l.categoria = 'SR' 
  AND e.eliminado = 0 
  AND l.eliminado = 0;

-- Recrear el índice
CREATE INDEX idx_legajo_categoria ON Legajo(categoria);

SET profiling = 0;

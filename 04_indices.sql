USE `TPIntegradorProgramación2yBaseDeDatos1`;

-- ------------------------------------------------
-- Conteo de filas por tabla (Legajo vs Empleado)
-- ------------------------------------------------
SELECT 'Legajo' AS tabla, COUNT(*) AS filas FROM Legajo
UNION ALL
SELECT 'Empleado', COUNT(*) FROM Empleado;

-- ------------------------------------------------
-- Empleados sin legajo asociado (FK huérfana)
-- ------------------------------------------------
SELECT COUNT(*) AS empleados_sin_legajo
FROM Empleado e
LEFT JOIN Legajo l ON l.id = e.legajo
WHERE l.id IS NULL;

-- ------------------------------------------------
-- Legajos con más de un empleado (potencial duplicidad)
-- Devuelve UNA fila por legajo duplicado con su cantidad (>1)
-- ------------------------------------------------
SELECT COUNT(*) AS empleados_con_legajo_duplicado
FROM Empleado
GROUP BY legajo
HAVING COUNT(*) > 1;

-- ------------------------------------------------
-- Reglas temporales:
-- - ingresos_futuros: fechaIngreso > hoy (anomalía)
-- - ingresos_antes_del_alta: fechaIngreso < fechaAlta del legajo (anomalía)
-- ------------------------------------------------
SELECT
  SUM(e.fechaIngreso > CURDATE()) AS ingresos_futuros,
  SUM(e.fechaIngreso < l.fechaAlta) AS ingresos_antes_del_alta
FROM Empleado e
JOIN Legajo l ON l.id = e.legajo;

-- ------------------------------------------------
-- Distribución por estado del legajo (ACTIVO/INACTIVO)
-- ------------------------------------------------
SELECT estado, COUNT(*) FROM Legajo GROUP BY estado;

-- ------------------------------------------------
-- Distribución por categoría del legajo (JR/SSR/SR/LEAD/TRAINEE)
-- ------------------------------------------------
SELECT categoria, COUNT(*) FROM Legajo GROUP BY categoria;

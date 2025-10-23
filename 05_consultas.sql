USE `TPIntegradorProgramación2yBaseDeDatos1`;

-- CONSULTA 1: JOIN entre Empleado y Legajo

SELECT 
    e.id AS empleado_id,
    e.nombre,
    e.apellido,
    e.dni,
    e.email,
    e.area,
    e.fechaIngreso,
    TIMESTAMPDIFF(YEAR, e.fechaIngreso, CURDATE()) AS años_antiguedad,
    l.nroLegajo,
    l.categoria,
    l.estado AS estado_legajo,
    l.fechaAlta AS fecha_alta_legajo
FROM Empleado e
INNER JOIN Legajo l ON e.legajo = l.id
WHERE e.eliminado = 0 
  AND l.eliminado = 0
ORDER BY e.id;

-- CONSULTA 2: JOIN por área

SELECT 
    e.area,
    COUNT(DISTINCT e.id) AS total_empleados,
    COUNT(CASE WHEN l.estado = 'ACTIVO' THEN 1 END) AS legajos_activos,
    COUNT(CASE WHEN l.estado = 'INACTIVO' THEN 1 END) AS legajos_inactivos,
    ROUND(AVG(TIMESTAMPDIFF(YEAR, e.fechaIngreso, CURDATE())), 1) AS promedio_años_antiguedad
FROM Empleado e
INNER JOIN Legajo l ON e.legajo = l.id
WHERE e.eliminado = 0
GROUP BY e.area
ORDER BY total_empleados DESC;

-- CONSULTA 3: GROUP BY con HAVING (area con mas de 10000 empleados)

SELECT 
    e.area,
    COUNT(*) AS cantidad_empleados,
    COUNT(CASE WHEN l.estado = 'ACTIVO' THEN 1 END) AS empleados_activos,
    COUNT(CASE WHEN l.estado = 'INACTIVO' THEN 1 END) AS empleados_inactivos,
    ROUND(AVG(TIMESTAMPDIFF(YEAR, e.fechaIngreso, CURDATE())), 1) AS promedio_años_antiguedad,
    COUNT(CASE WHEN TIMESTAMPDIFF(YEAR, e.fechaIngreso, CURDATE()) >= 5 THEN 1 END) AS veteranos,
    COUNT(CASE WHEN TIMESTAMPDIFF(YEAR, e.fechaIngreso, CURDATE()) < 2 THEN 1 END) AS nuevos
FROM Empleado e
INNER JOIN Legajo l ON e.legajo = l.id
WHERE e.eliminado = 0
GROUP BY e.area
HAVING cantidad_empleados >= 10000
ORDER BY cantidad_empleados DESC;

-- CONSULTA 4: Subconsulta de categoria SR

SELECT 
    e.id,
    e.nombre,
    e.apellido,
    e.dni,
    e.email,
    e.area,
    e.fechaIngreso,
    TIMESTAMPDIFF(YEAR, e.fechaIngreso, CURDATE()) AS años_antiguedad,
    l.nroLegajo,
    l.categoria,
    (SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, fechaIngreso, CURDATE())), 1)
     FROM Empleado
     WHERE eliminado = 0) AS antiguedad_promedio_empresa
FROM Empleado e
INNER JOIN Legajo l ON e.legajo = l.id
WHERE e.eliminado = 0
  AND l.categoria = 'SR'
  AND TIMESTAMPDIFF(YEAR, e.fechaIngreso, CURDATE()) > (
      SELECT AVG(TIMESTAMPDIFF(YEAR, fechaIngreso, CURDATE()))
      FROM Empleado
      WHERE eliminado = 0
  )
ORDER BY años_antiguedad DESC;
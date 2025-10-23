USE `TPIntegradorProgramación2yBaseDeDatos1`;

-- VISTA:

CREATE OR REPLACE VIEW vw_empleados_activos_resumen AS
SELECT 
    e.id AS empleado_id,
    e.nombre,
    e.apellido,
    e.dni,
    e.email,
    e.area,
    e.fechaIngreso,
    TIMESTAMPDIFF(YEAR, e.fechaIngreso, CURDATE()) AS años_en_empresa,
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, e.fechaIngreso, CURDATE()) >= 5 THEN 'Veterano'
        WHEN TIMESTAMPDIFF(YEAR, e.fechaIngreso, CURDATE()) >= 2 THEN 'Experimentado'
        ELSE 'Nuevo'
    END AS nivel_antiguedad,
    l.nroLegajo,
    l.categoria,
    l.estado AS estado_legajo,
    l.fechaAlta,
    CASE 
        WHEN l.estado = 'ACTIVO' THEN 'Legajo Vigente'
        WHEN l.estado = 'INACTIVO' THEN 'Legajo Suspendido'
        ELSE 'Estado Desconocido'
    END AS descripcion_estado
FROM Empleado e
INNER JOIN Legajo l ON e.legajo = l.id
WHERE e.eliminado = 0 AND l.eliminado = 0;

-- Ejemplos de uso de la vista:

-- Empleados activos
SELECT * FROM vw_empleados_activos_resumen;

-- Empleados del area IT
SELECT * FROM vw_empleados_activos_resumen WHERE area = 'IT';

-- Empleados veteranos (5 años o mas)
SELECT * FROM vw_empleados_activos_resumen WHERE nivel_antiguedad = 'Veterano';

-- Empleados con legajo inactivo
SELECT * FROM vw_empleados_activos_resumen WHERE estado_legajo = 'INACTIVO';
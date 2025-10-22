USE `TPIntegradorProgramación2yBaseDeDatos1`;

-- Permite CTEs profundas (necesario para @N grande)
SET SESSION cte_max_recursion_depth = 100000;

-- Cantidad de legajos a generar
SET @N := 100000;

-- Parámetros de fecha
SET @START_DATE := DATE('2015-01-01');
SET @SPAN_LEGAJO_DAYS := DATEDIFF(CURDATE(), @START_DATE); 


-- Transacción (se insertan ambas tablas, o ninguna)
START TRANSACTION;

-- ============================================
-- Inserción masiva en Legajo
-- Genera @N filas con categorías/estados y fechaAlta aleatoria
-- ============================================
INSERT INTO Legajo (eliminado, nroLegajo, categoria, estado, fechaAlta, observaciones)
-- CTE recursiva: secuencia 1..@N
WITH RECURSIVE seq(n) AS (
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM seq WHERE n < @N
)
-- Selección de datos
SELECT
  0 AS eliminado,                                               
  CONCAT('LEG-', LPAD(n, 6, '0')) AS nroLegajo,                  
  ELT(1 + (n % 5), 'JR', 'SSR', 'SR', 'LEAD', 'TRAINEE') AS categoria, 
  ELT(1 + (n % 2), 'ACTIVO', 'INACTIVO') AS estado,              
  DATE_ADD(@START_DATE, INTERVAL FLOOR(RAND() * (@SPAN_LEGAJO_DAYS + 1)) DAY) AS fechaAlta,
  NULL AS observaciones                                          
FROM seq;

-- ============================================
-- Inserción masiva en Empleado
-- Crea un empleado por cada Legajo SIN empleado asociado
-- Nombres/apellidos/área y fechas aleatorias; email único
-- ============================================
INSERT INTO Empleado (eliminado, nombre, apellido, dni, email, fechaIngreso, area, legajo)
SELECT
  0 AS eliminado,                                                
  t.nombre,                                                     
  t.apellido,                                                   
  CONCAT('D', LPAD(t.legajo_id, 9, '0')) AS dni,                 
  LOWER(CONCAT(LEFT(t.nombre, 1), '.', t.apellido_email, t.legajo_id, '@empresa.test')) AS email, 
   DATE_ADD(
    t.fechaAlta,
    INTERVAL FLOOR(RAND() * (GREATEST(DATEDIFF(CURDATE(), t.fechaAlta), 0) + 1)) DAY
  ) AS fechaIngreso,
  t.area,                                                        
  t.legajo_id AS legajo                                          
FROM (
  -- Subconsulta: arma el pool de datos por cada legajo sin empleado
  SELECT
    L.id AS legajo_id,                                           
    L.fechaAlta,                                                 
    ELT(1 + FLOOR(RAND() * 10),
        'Juan','María','Lucía','Pedro','Sofía','Diego','Valentina','Leandro','Carla','Nicolás') AS nombre,
    ELT(1 + FLOOR(RAND() * 10),
        'Gómez','Rodríguez','Fernández','López','Martínez','Pérez','Sánchez','Romero','Torres','Álvarez') AS apellido,
    ELT(1 + FLOOR(RAND() * 10),
        'gomez','rodriguez','fernandez','lopez','martinez','perez','sanchez','romero','torres','alvarez') AS apellido_email, 
    ELT(1 + FLOOR(RAND() * 6),
        'IT','RRHH','Finanzas','Comercial','Operaciones','Legales') AS area
  FROM Legajo L
  LEFT JOIN Empleado E ON E.legajo = L.id
  WHERE E.legajo IS NULL                                       
) AS t;

-- Confirma todos los cambios
COMMIT;

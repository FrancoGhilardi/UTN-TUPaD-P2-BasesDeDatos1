-- Crear usuario con privilegios mínimos
CREATE USER 'empleado'@'localhost' IDENTIFIED BY 'ABC123';
GRANT SELECT, INSERT ON TPIntegradorProgramacion2yBaseDeDatos1.Empleado TO 'empleado'@'localhost';
GRANT SELECT ON TPIntegradorProgramacion2yBaseDeDatos1.Legajo TO 'empleado'@'localhost';
FLUSH PRIVILEGES;

-- Vistas que ocultan información sensible
CREATE VIEW vista_empleado_publico AS
SELECT nombre, apellido, fechaIngreso, area
FROM Empleado
WHERE eliminado = 0;

CREATE VIEW vista_legajos_activos AS
SELECT nroLegajo, categoria, fechaAlta
FROM Legajo
WHERE estado = 'ACTIVO' AND eliminado = 0;

-- Prueba de integridad: DNI duplicado
INSERT INTO Empleado (id, eliminado, nombre, apellido, dni, email, fechaIngreso, area, legajo)
VALUES (103, 0, 'Juan', 'Pérez', '12345678', 'juan@utn.com', '2023-01-01', 'RRHH', 1);

-- Intento de duplicar DNI
INSERT INTO Empleado (id, eliminado, nombre, apellido, dni, email, fechaIngreso, area, legajo)
VALUES (104, 0, 'Ana', 'Gómez', '12345678', 'ana@utn.com', '2023-02-01', 'Ventas', 2);

-- Prueba de integridad: legajo inexistente
INSERT INTO Empleado (id, eliminado, nombre, apellido, dni, email, fechaIngreso, area, legajo)
VALUES (105, 0, 'Carlos', 'López', '87654321', 'carlos@utn.com', '2023-03-01', 'IT', 9999);
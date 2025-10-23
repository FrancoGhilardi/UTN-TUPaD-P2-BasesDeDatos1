# Trabajo Práctico Integrador Base de Datos 1

**Alumnos - Grupo 8:** HERNAN JAVIER CASALDERREY (Comisión 13) · FRANCO JOEL GHILARDI ARMIJO (Comisión 14) · LAUTARO LANER (Comisión 3) · ZAMPIERI PAMELA (Comisión 18)  
**Tecnicatura Universitaria en Programación — Universidad Tecnológica Nacional**  
**Docente Titular:** Oscar Londero  
**Docentes Tutores:** Diego Lobos (Comisión 13), Martín Garcia (Comisión 14), David Rocco (Comisión 3), Guillermo Londero (Comisión 18)

---

## Descripción general

Proyecto integrador orientado a **diseño físico**, **generación masiva de datos**, **optimización con índices**, **consultas analíticas**, **vistas para reporting**, **seguridad** y **concurrencia** sobre MySQL/InnoDB. Enfoque minimalista, reproducible e idempotente.

---

## Estructura de archivos

- **01_esquema.sql** — _Esquema y modelo físico (Etapa 1)_.  
  Crea el schema `TPIntegradorProgramación2yBaseDeDatos1`, tablas **Legajo** y **Empleado** con PK/UK, **FK 1:1** (Empleado→Legajo), **checks** y baja lógica (`eliminado`). Collation `utf8mb4`.

- **02_catalogos.sql** — _Catálogos iniciales_.  
  Placeholder de catálogos para esta versión; **no requiere carga inicial**.

- **03_carga_masiva.sql** — _Generación de datos a gran escala (Etapa 2)_.  
  Inserta **100.000 legajos** con **CTE recursiva** y reglas determinísticas (categoría/estado) + **fechas aleatorias controladas**; luego crea **Empleado** asociado para cada **Legajo** sin empleado. Todo en **transacción**.

- **04_indices.sql** — _Índices y lineamientos de optimización_.  
  Índices propuestos en **Empleado(area, fechaIngreso)** y **Legajo(categoria, estado)** para acelerar filtros por igualdad y rango. Incluye consulta de índices (`SHOW INDEX`).

- **05_consultas.sql** — _Consultas analíticas y validaciones_.  
  Conjunto de consultas: **JOIN** Empleado↔Legajo, agregaciones por **área**, **HAVING** (≥ 10.000 empleados), **subconsultas**; además métricas de validación (conteos, **anomalías temporales** y distribuciones).

- **05_explain.sql** — _Medición y planes de ejecución_.  
  Pruebas **con/sin índices** usando `SET profiling` y `EXPLAIN`: igualdad por **area**, **rango por fechaIngreso**, y **JOIN** filtrando por `categoria`.

- **06_vistas.sql** — _Vista para reporting_.  
  `vw_empleados_activos_resumen` enriquece con `años_en_empresa`, **nivel de antigüedad** (Nuevo/Experimentado/Veterano) y descripción de estado del legajo. Incluye **ejemplos de uso**.

- **07_seguridad.sql** — _Seguridad y resguardo de datos_.  
  Usuario `empleado` con **privilegios mínimos** (GRANT restringido), **vistas públicas** que ocultan datos sensibles, y **pruebas de integridad** (unicidad de DNI, FK).

- **08_concurrencia_transacciones.sql** — _Concurrencia y aislamiento_.  
  **Simulación de deadlock** + procedimiento con **retry y backoff** (`transaccion_segura`), y comparación entre **READ COMMITTED** y **REPEATABLE READ** con tabla de prueba.

---

## Notas

- Todos los scripts son **idempotentes** en la medida de lo posible y pensados para **reproducibilidad**.
- Motor objetivo: **MySQL/InnoDB** (se aprovechan FK, transacciones y niveles de aislamiento).

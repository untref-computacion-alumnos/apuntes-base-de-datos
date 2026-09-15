-- Trabajo Práctico 1 - Ejercicio 3
-- Resolución en SQL ANSI de las consignas descriptas en practica-1.md
--
-- Nota: "pendiente de entrega" se interpreta como un pedido cuya
-- fecha_de_entrega todavía no llegó (fecha_de_entrega > CURRENT_DATE), ya
-- que el esquema no tiene una columna de fecha de pedido ni un flag de
-- estado. Este criterio se usa de forma consistente en las consignas 6, 8
-- y 12.

-- =============================================================================
-- Esquema
-- =============================================================================

CREATE TABLE departamentos (
    codigo_de_departamento VARCHAR(10) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    PRIMARY KEY (codigo_de_departamento)
);

CREATE TABLE empleados (
    codigo_de_empleado INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(150) NOT NULL,
    codigo_de_departamento VARCHAR(10) NOT NULL,
    sueldo DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (codigo_de_empleado),
    FOREIGN KEY (codigo_de_departamento) REFERENCES departamentos(
        codigo_de_departamento
    )
);

CREATE TABLE articulos (
    codigo_de_articulo INTEGER NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    stock INTEGER NOT NULL,
    tipo VARCHAR(10) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    punto_de_reorden INTEGER NOT NULL,
    PRIMARY KEY (codigo_de_articulo)
);

CREATE TABLE pedidos (
    numero_de_pedido INTEGER NOT NULL,
    cliente VARCHAR(100) NOT NULL,
    codigo_de_empleado INTEGER NOT NULL,
    fecha_de_entrega DATE NOT NULL,
    PRIMARY KEY (numero_de_pedido),
    FOREIGN KEY (codigo_de_empleado) REFERENCES empleados(codigo_de_empleado)
);

CREATE TABLE detalles (
    numero_de_pedido INTEGER NOT NULL,
    codigo_de_articulo INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    PRIMARY KEY (numero_de_pedido, codigo_de_articulo),
    FOREIGN KEY (numero_de_pedido) REFERENCES pedidos(numero_de_pedido),
    FOREIGN KEY (codigo_de_articulo) REFERENCES articulos(codigo_de_articulo)
);

-- =============================================================================
-- Consignas
-- =============================================================================

-- 1. Listar todos los datos de los artículos que se encuentren a menos de un
--    10 % de su punto de reorden.
SELECT
    art.codigo_de_articulo,
    art.descripcion,
    art.stock,
    art.tipo,
    art.precio,
    art.punto_de_reorden
FROM articulos AS art
WHERE art.stock < (art.punto_de_reorden * 0.1);

-- 2. Recuperar el total de sueldos y el promedio de sueldos para cada
--    departamento.
SELECT
    dep.codigo_de_departamento,
    dep.descripcion,
    SUM(emp.sueldo) AS total_sueldos,
    AVG(emp.sueldo) AS promedio_sueldos
FROM departamentos AS dep
INNER JOIN empleados AS emp
    ON dep.codigo_de_departamento = emp.codigo_de_departamento
GROUP BY dep.codigo_de_departamento, dep.descripcion;

-- 3. Listar los artículos que nunca fueron comprados por el cliente "Pepe".
SELECT
    art.codigo_de_articulo,
    art.descripcion
FROM articulos AS art
WHERE NOT EXISTS (
    SELECT 1
    FROM detalles AS det
    INNER JOIN pedidos AS ped
        ON det.numero_de_pedido = ped.numero_de_pedido
    WHERE
        det.codigo_de_articulo = art.codigo_de_articulo
        AND ped.cliente = 'Pepe'
);

-- 4. Recuperar la cantidad de pedidos para cada empleado del departamento A.
SELECT
    emp.codigo_de_empleado,
    emp.nombre,
    COUNT(ped.numero_de_pedido) AS cantidad_de_pedidos
FROM empleados AS emp
LEFT JOIN pedidos AS ped
    ON emp.codigo_de_empleado = ped.codigo_de_empleado
WHERE emp.codigo_de_departamento = 'A'
GROUP BY emp.codigo_de_empleado, emp.nombre;

-- 5. Listar el nombre y el departamento del empleado de menor sueldo.
SELECT
    emp.nombre,
    dep.descripcion AS departamento
FROM empleados AS emp
INNER JOIN departamentos AS dep
    ON emp.codigo_de_departamento = dep.codigo_de_departamento
WHERE emp.sueldo = (
    SELECT MIN(emp_min.sueldo)
    FROM empleados AS emp_min
);

-- 6. Recuperar los datos de los empleados que tienen más de 3 pedidos
--    pendientes de entrega.
SELECT
    emp.codigo_de_empleado,
    emp.nombre,
    emp.direccion,
    emp.codigo_de_departamento,
    emp.sueldo
FROM empleados AS emp
WHERE (
    SELECT COUNT(*)
    FROM pedidos AS ped
    WHERE
        ped.codigo_de_empleado = emp.codigo_de_empleado
        AND ped.fecha_de_entrega > CURRENT_DATE
) > 3;

-- 7. Recuperar la descripción de los departamentos para los cuales el
--    promedio de sueldo de sus empleados es superior a $3000.
SELECT dep.descripcion
FROM departamentos AS dep
INNER JOIN empleados AS emp
    ON dep.codigo_de_departamento = emp.codigo_de_departamento
GROUP BY dep.codigo_de_departamento, dep.descripcion
HAVING AVG(emp.sueldo) > 3000;

-- 8. Recuperar los artículos para los cuales la cantidad pendiente de
--    entrega supera al stock.
SELECT
    art.codigo_de_articulo,
    art.descripcion
FROM articulos AS art
INNER JOIN detalles AS det
    ON art.codigo_de_articulo = det.codigo_de_articulo
INNER JOIN pedidos AS ped
    ON det.numero_de_pedido = ped.numero_de_pedido
WHERE ped.fecha_de_entrega > CURRENT_DATE
GROUP BY art.codigo_de_articulo, art.descripcion, art.stock
HAVING SUM(det.cantidad) > art.stock;

-- 9. Contar cuántos departamentos distintos hay en la tabla de empleados.
SELECT COUNT(DISTINCT codigo_de_departamento) AS cantidad_de_departamentos
FROM empleados;

-- 10. Listar los artículos cuyo precio esté entre 20 y 50.
SELECT
    art.codigo_de_articulo,
    art.descripcion,
    art.precio
FROM articulos AS art
WHERE art.precio BETWEEN 20 AND 50;

-- 11. Listar todos los pedidos que contengan artículos del tipo A o B.
SELECT DISTINCT ped.numero_de_pedido
FROM pedidos AS ped
INNER JOIN detalles AS det
    ON ped.numero_de_pedido = det.numero_de_pedido
INNER JOIN articulos AS art
    ON det.codigo_de_articulo = art.codigo_de_articulo
WHERE art.tipo IN ('A', 'B');

-- 12. Recuperar el código y la descripción de los artículos que no tienen
--     entregas pendientes.
SELECT
    art.codigo_de_articulo,
    art.descripcion
FROM articulos AS art
WHERE NOT EXISTS (
    SELECT 1
    FROM detalles AS det
    INNER JOIN pedidos AS ped
        ON det.numero_de_pedido = ped.numero_de_pedido
    WHERE
        det.codigo_de_articulo = art.codigo_de_articulo
        AND ped.fecha_de_entrega > CURRENT_DATE
);

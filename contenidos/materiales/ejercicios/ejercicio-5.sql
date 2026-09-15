-- Trabajo Práctico 1 - Ejercicio 5
-- Resolución en SQL ANSI de las consignas descriptas en practica-1.md

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
    FOREIGN KEY (codigo_de_departamento) REFERENCES departamentos (
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

CREATE TABLE clientes (
    id_de_cliente INTEGER NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(30),
    PRIMARY KEY (id_de_cliente)
);

CREATE TABLE pedidos (
    numero_de_pedido INTEGER NOT NULL,
    id_de_cliente INTEGER NOT NULL,
    codigo_de_empleado INTEGER NOT NULL,
    fecha_de_entrega DATE NOT NULL,
    PRIMARY KEY (numero_de_pedido),
    FOREIGN KEY (id_de_cliente) REFERENCES clientes (id_de_cliente),
    FOREIGN KEY (codigo_de_empleado) REFERENCES empleados (codigo_de_empleado)
);

CREATE TABLE detalles (
    numero_de_pedido INTEGER NOT NULL,
    codigo_de_articulo INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    PRIMARY KEY (numero_de_pedido, codigo_de_articulo),
    FOREIGN KEY (numero_de_pedido) REFERENCES pedidos (numero_de_pedido),
    FOREIGN KEY (codigo_de_articulo) REFERENCES articulos (codigo_de_articulo)
);

-- =============================================================================
-- Consignas
-- =============================================================================

-- 1. Listar el total de unidades de cada artículo que hay que entregar la
--    próxima semana.
SELECT
    art.codigo_de_articulo,
    art.descripcion,
    SUM(det.cantidad) AS total_unidades
FROM articulos AS art
INNER JOIN detalles AS det
    ON art.codigo_de_articulo = det.codigo_de_articulo
INNER JOIN pedidos AS ped
    ON det.numero_de_pedido = ped.numero_de_pedido
WHERE
    ped.fecha_de_entrega BETWEEN CURRENT_DATE AND (
        CURRENT_DATE + INTERVAL '7' DAY
    )
GROUP BY art.codigo_de_articulo, art.descripcion;

-- 2. Recuperar los diferentes artículos que no tienen pedidos.

-- 2.a. Usando NOT EXISTS
SELECT
    art.codigo_de_articulo,
    art.descripcion
FROM articulos AS art
WHERE NOT EXISTS (
    SELECT 1
    FROM detalles AS det
    WHERE det.codigo_de_articulo = art.codigo_de_articulo
);

-- 2.b. Sin usar NOT EXISTS (LEFT JOIN + IS NULL)
SELECT
    art.codigo_de_articulo,
    art.descripcion
FROM articulos AS art
LEFT JOIN detalles AS det
    ON art.codigo_de_articulo = det.codigo_de_articulo
WHERE det.codigo_de_articulo IS NULL;

-- 3. Recuperar todos los pedidos de los clientes cuyo nombre empiece con M.
SELECT
    ped.numero_de_pedido,
    ped.id_de_cliente,
    ped.codigo_de_empleado,
    ped.fecha_de_entrega
FROM pedidos AS ped
INNER JOIN clientes AS cli
    ON ped.id_de_cliente = cli.id_de_cliente
WHERE cli.nombre LIKE 'M%';

-- 4. Recuperar todos los pedidos de los clientes cuyo nombre contenga una T
--    en mayúscula o minúscula.
SELECT
    ped.numero_de_pedido,
    ped.id_de_cliente,
    ped.codigo_de_empleado,
    ped.fecha_de_entrega
FROM pedidos AS ped
INNER JOIN clientes AS cli
    ON ped.id_de_cliente = cli.id_de_cliente
WHERE UPPER(cli.nombre) LIKE '%T%';

-- 5. Buscar los clientes que no adquirieron el artículo "lápiz".

-- 5.a. Usando NOT EXISTS
SELECT
    cli.id_de_cliente,
    cli.apellido,
    cli.nombre
FROM clientes AS cli
WHERE NOT EXISTS (
    SELECT 1
    FROM pedidos AS ped
    INNER JOIN detalles AS det
        ON ped.numero_de_pedido = det.numero_de_pedido
    INNER JOIN articulos AS art
        ON det.codigo_de_articulo = art.codigo_de_articulo
    WHERE
        ped.id_de_cliente = cli.id_de_cliente
        AND art.descripcion = 'lápiz'
);

-- 5.b. Sin usar NOT EXISTS (NOT IN)
SELECT
    cli.id_de_cliente,
    cli.apellido,
    cli.nombre
FROM clientes AS cli
WHERE cli.id_de_cliente NOT IN (
    SELECT ped.id_de_cliente
    FROM pedidos AS ped
    INNER JOIN detalles AS det
        ON ped.numero_de_pedido = det.numero_de_pedido
    INNER JOIN articulos AS art
        ON det.codigo_de_articulo = art.codigo_de_articulo
    WHERE
        art.descripcion = 'lápiz'
        AND ped.id_de_cliente IS NOT NULL
);

-- 6. Ver la lista de los clientes solo si el artículo "lápiz" está
--    disponible (stock > punto_de_reorden).
SELECT
    cli.id_de_cliente,
    cli.apellido,
    cli.nombre,
    cli.telefono
FROM clientes AS cli
WHERE EXISTS (
    SELECT 1
    FROM articulos AS art
    WHERE
        art.descripcion = 'lápiz'
        AND art.stock > art.punto_de_reorden
);

-- 7. Buscar el o los artículos de precio más alto y sus compradores.
SELECT DISTINCT
    art.codigo_de_articulo,
    art.descripcion,
    art.precio,
    cli.apellido,
    cli.nombre
FROM articulos AS art
INNER JOIN detalles AS det
    ON art.codigo_de_articulo = det.codigo_de_articulo
INNER JOIN pedidos AS ped
    ON det.numero_de_pedido = ped.numero_de_pedido
INNER JOIN clientes AS cli
    ON ped.id_de_cliente = cli.id_de_cliente
WHERE art.precio = (
    SELECT MAX(art_max.precio)
    FROM articulos AS art_max
);

-- 8. Listar la descripción de los departamentos y la cantidad de empleados,
--    aunque no tengan ningún empleado.
SELECT
    dep.descripcion,
    COUNT(emp.codigo_de_empleado) AS cantidad_de_empleados
FROM departamentos AS dep
LEFT JOIN empleados AS emp
    ON dep.codigo_de_departamento = emp.codigo_de_departamento
GROUP BY dep.codigo_de_departamento, dep.descripcion;

-- 9. Listar los apellidos, nombres y teléfonos de los clientes, y la
--    cantidad de pedidos del último mes, aunque no hayan comprado nada en
--    ese mes.
SELECT
    cli.apellido,
    cli.nombre,
    cli.telefono,
    COUNT(ped.numero_de_pedido) AS cantidad_de_pedidos
FROM clientes AS cli
LEFT JOIN pedidos AS ped
    ON
        cli.id_de_cliente = ped.id_de_cliente
        AND ped.fecha_de_entrega >= CURRENT_DATE - INTERVAL '1' MONTH
GROUP BY cli.id_de_cliente, cli.apellido, cli.nombre, cli.telefono;

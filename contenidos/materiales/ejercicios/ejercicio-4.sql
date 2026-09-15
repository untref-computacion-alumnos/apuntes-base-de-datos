-- Trabajo Práctico 1 - Ejercicio 4
-- Resolución en SQL ANSI de las consignas descriptas en practica-1.md

-- =============================================================================
-- Esquema
-- =============================================================================

CREATE TABLE vendedores (
    numero_de_vendedor INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    localidad VARCHAR(100) NOT NULL,
    porcentaje DECIMAL(5, 2) NOT NULL,
    PRIMARY KEY (numero_de_vendedor)
);

CREATE TABLE clientes (
    numero_de_cliente INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    localidad VARCHAR(100) NOT NULL,
    limite_de_credito DECIMAL(10, 2) NOT NULL,
    numero_de_vendedor INTEGER NOT NULL,
    PRIMARY KEY (numero_de_cliente),
    FOREIGN KEY (numero_de_vendedor) REFERENCES vendedores (numero_de_vendedor)
);

CREATE TABLE pedidos (
    numero_de_pedido INTEGER NOT NULL,
    numero_de_cliente INTEGER NOT NULL,
    fecha DATE NOT NULL,
    PRIMARY KEY (numero_de_pedido),
    FOREIGN KEY (numero_de_cliente) REFERENCES clientes (numero_de_cliente)
);

CREATE TABLE lineas_de_pedidos (
    numero_de_pedido INTEGER NOT NULL,
    articulo VARCHAR(50) NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (numero_de_pedido, articulo),
    FOREIGN KEY (numero_de_pedido) REFERENCES pedidos (numero_de_pedido)
);

-- =============================================================================
-- Consignas
-- =============================================================================

-- 1. Listar nombre y localidad de los clientes que piden en promedio más de
--    100 artículos.
SELECT
    cli.nombre,
    cli.localidad
FROM clientes AS cli
INNER JOIN pedidos AS ped
    ON cli.numero_de_cliente = ped.numero_de_cliente
INNER JOIN lineas_de_pedidos AS lin
    ON ped.numero_de_pedido = lin.numero_de_pedido
GROUP BY cli.numero_de_cliente, cli.nombre, cli.localidad
HAVING AVG(lin.cantidad) > 100;

-- 2. Listar el o los nombres de los vendedores que venden artículos a
--    clientes de la localidad de Rosario cuyo precio unitario es mayor a
--    $10.
SELECT DISTINCT ven.nombre
FROM vendedores AS ven
INNER JOIN clientes AS cli
    ON ven.numero_de_vendedor = cli.numero_de_vendedor
INNER JOIN pedidos AS ped
    ON cli.numero_de_cliente = ped.numero_de_cliente
INNER JOIN lineas_de_pedidos AS lin
    ON ped.numero_de_pedido = lin.numero_de_pedido
WHERE
    cli.localidad = 'Rosario'
    AND lin.precio_unitario > 10;

-- 3. Listar el nombre y la localidad de los vendedores que tienen algún
--    cliente con su límite de crédito mayor al promedio de los límites de
--    crédito.
SELECT DISTINCT
    ven.nombre,
    ven.localidad
FROM vendedores AS ven
INNER JOIN clientes AS cli
    ON ven.numero_de_vendedor = cli.numero_de_vendedor
WHERE cli.limite_de_credito > (
    SELECT AVG(cli_avg.limite_de_credito)
    FROM clientes AS cli_avg
);

-- 4. Listar nombre y localidad de los clientes, junto con los artículos y la
--    cantidad pedida, de aquellos clientes atendidos por el vendedor número
--    5 el día 03/03/1991.
SELECT
    cli.nombre,
    cli.localidad,
    lin.articulo,
    lin.cantidad
FROM clientes AS cli
INNER JOIN pedidos AS ped
    ON cli.numero_de_cliente = ped.numero_de_cliente
INNER JOIN lineas_de_pedidos AS lin
    ON ped.numero_de_pedido = lin.numero_de_pedido
WHERE
    cli.numero_de_vendedor = 5
    AND ped.fecha = DATE '1991-03-03';

-- 5. Listar los nombres de los vendedores que tengan un porcentaje mayor al
--    7 % y que hayan vendido a más de un cliente de Rosario antes del
--    31/12/1991.
SELECT ven.nombre
FROM vendedores AS ven
WHERE
    ven.porcentaje > 7
    AND (
        SELECT COUNT(DISTINCT cli.numero_de_cliente)
        FROM clientes AS cli
        INNER JOIN pedidos AS ped
            ON cli.numero_de_cliente = ped.numero_de_cliente
        WHERE
            cli.numero_de_vendedor = ven.numero_de_vendedor
            AND cli.localidad = 'Rosario'
            AND ped.fecha < DATE '1991-12-31'
    ) > 1;

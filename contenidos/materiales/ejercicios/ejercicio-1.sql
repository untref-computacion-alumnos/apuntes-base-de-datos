-- Trabajo Práctico 1 - Ejercicio 1
-- Resolución en SQL ANSI de las consignas descriptas en practica-1.md

-- =============================================================================
-- Esquema
-- =============================================================================

CREATE TABLE clientes (
    numero_de_cliente INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    PRIMARY KEY (numero_de_cliente)
);

CREATE TABLE productos (
    codigo INTEGER NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    color VARCHAR(50) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (codigo)
);

CREATE TABLE pedidos (
    numero_de_pedido INTEGER NOT NULL,
    numero_de_cliente INTEGER NOT NULL,
    fecha DATE NOT NULL,
    PRIMARY KEY (numero_de_pedido),
    FOREIGN KEY (numero_de_cliente) REFERENCES clientes(numero_de_cliente)
);

CREATE TABLE lineas (
    numero_de_pedido INTEGER NOT NULL,
    codigo INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    PRIMARY KEY (numero_de_pedido, codigo),
    FOREIGN KEY (numero_de_pedido) REFERENCES pedidos(numero_de_pedido),
    FOREIGN KEY (codigo) REFERENCES productos(codigo)
);

-- =============================================================================
-- Consignas
-- =============================================================================

-- 1. Listar la descripción de los productos que fueron pedidos por algún
--    cliente de Rosario.
SELECT DISTINCT pro.descripcion
FROM productos AS pro
INNER JOIN lineas AS lin
    ON pro.codigo = lin.codigo
INNER JOIN pedidos AS ped
    ON lin.numero_de_pedido = ped.numero_de_pedido
INNER JOIN clientes AS cli
    ON ped.numero_de_cliente = cli.numero_de_cliente
WHERE cli.ciudad = 'Rosario';

-- 2. Listar los nombres de los clientes y, para cada cliente, el monto total
--    facturado (precio x cantidad) a partir del 10 de mayo de 1996, siempre
--    que este monto supere los $1000.
SELECT
    cli.nombre,
    SUM(pro.precio * lin.cantidad) AS monto_total_facturado
FROM clientes AS cli
INNER JOIN pedidos AS ped
    ON cli.numero_de_cliente = ped.numero_de_cliente
INNER JOIN lineas AS lin
    ON ped.numero_de_pedido = lin.numero_de_pedido
INNER JOIN productos AS pro
    ON lin.codigo = pro.codigo
WHERE ped.fecha >= DATE '1996-05-10'
GROUP BY cli.numero_de_cliente, cli.nombre
HAVING SUM(pro.precio * lin.cantidad) > 1000;

-- 3. Listar el nombre de los clientes que no compraron nada hoy.
SELECT cli.nombre
FROM clientes AS cli
WHERE NOT EXISTS (
    SELECT 1
    FROM pedidos AS ped
    WHERE
        ped.numero_de_cliente = cli.numero_de_cliente
        AND ped.fecha = CURRENT_DATE
);

-- 4. Mostrar la descripción de los productos que se pidieron en la última
--    semana.
SELECT DISTINCT pro.descripcion
FROM productos AS pro
INNER JOIN lineas AS lin
    ON pro.codigo = lin.codigo
INNER JOIN pedidos AS ped
    ON lin.numero_de_pedido = ped.numero_de_pedido
WHERE ped.fecha >= CURRENT_DATE - INTERVAL '7' DAY;

-- 5. Calcular la cantidad de colores distintos en los que el cliente de
--    nombre "Pepe" pidió el producto de código 5.
SELECT COUNT(DISTINCT pro.color) AS cantidad_de_colores
FROM clientes AS cli
INNER JOIN pedidos AS ped
    ON cli.numero_de_cliente = ped.numero_de_cliente
INNER JOIN lineas AS lin
    ON ped.numero_de_pedido = lin.numero_de_pedido
INNER JOIN productos AS pro
    ON lin.codigo = pro.codigo
WHERE
    cli.nombre = 'Pepe'
    AND pro.codigo = 5;

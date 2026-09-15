SELECT
    c.id_de_cliente,
    c.apellido,
    c.nombre
FROM clientes AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM pedidos AS p
    INNER JOIN detalles AS d
        ON p.numero_de_pedido = d.numero_de_pedido
    INNER JOIN articulos AS a
        ON d.codigo_de_articulo = a.codigo_de_articulo
    WHERE
        p.id_de_cliente = c.id_de_cliente
        AND a.descripcion = 'lápiz'
);

SELECT
    c.id_de_cliente,
    c.apellido,
    c.nombre
FROM clientes AS c
WHERE c.id_de_cliente NOT IN (
    SELECT p.id_de_cliente
    FROM pedidos AS p
    INNER JOIN detalles AS d
        ON p.numero_de_pedido = d.numero_de_pedido
    INNER JOIN articulos AS a
        ON d.codigo_de_articulo = a.codigo_de_articulo
    WHERE
        a.descripcion = 'lápiz'
        AND p.id_de_cliente IS NOT NULL
);

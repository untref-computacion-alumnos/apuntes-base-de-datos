SELECT
    c.nombre,
    c.localidad,
    l.articulo,
    l.cantidad
FROM clientes AS c
INNER JOIN pedidos AS p
    ON c.numero_de_cliente = p.numero_de_cliente
INNER JOIN lineas_de_pedidos AS l
    ON p.numero_de_pedido = l.numero_de_pedido
WHERE
    c.numero_de_vendedor = 5
    AND p.fecha = DATE '1991-03-03';

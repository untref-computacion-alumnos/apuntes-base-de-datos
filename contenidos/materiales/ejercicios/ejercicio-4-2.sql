SELECT DISTINCT
    v.nombre
FROM vendedores AS v
INNER JOIN clientes AS c
    ON v.numero_de_vendedor = c.numero_de_vendedor
INNER JOIN pedidos AS p
    ON c.numero_de_cliente = p.numero_de_cliente
INNER JOIN lineas_de_pedidos AS l
    ON p.numero_de_pedido = l.numero_de_pedido
WHERE
    c.localidad = 'Rosario'
    AND l.precio_unitario > 10;

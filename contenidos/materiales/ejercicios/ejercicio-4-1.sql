SELECT
    c.nombre,
    c.localidad
FROM clientes AS c
INNER JOIN pedidos AS p
    ON c.numero_de_cliente = p.numero_de_cliente
INNER JOIN lineas_de_pedidos AS l
    ON p.numero_de_pedido = l.numero_de_pedido
GROUP BY c.numero_de_cliente, c.nombre, c.localidad
HAVING AVG(l.cantidad) > 100;

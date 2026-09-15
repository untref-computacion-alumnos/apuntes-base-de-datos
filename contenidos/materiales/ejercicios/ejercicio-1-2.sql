SELECT
    c.nombre,
    SUM(pr.precio * l.cantidad) AS monto_total_facturado
FROM clientes AS c
INNER JOIN pedidos AS p
    ON c.numero_de_cliente = p.numero_de_cliente
INNER JOIN lineas AS l
    ON p.numero_de_pedido = l.numero_de_pedido
INNER JOIN productos AS pr
    ON l.codigo = pr.codigo
WHERE p.fecha >= DATE '1996-05-10'
GROUP BY c.numero_de_cliente, c.nombre
HAVING SUM(pr.precio * l.cantidad) > 1000;

SELECT COUNT(DISTINCT pr.color) AS cantidad_de_colores
FROM clientes AS c
INNER JOIN pedidos AS p
    ON c.numero_de_cliente = p.numero_de_cliente
INNER JOIN lineas AS l
    ON p.numero_de_pedido = l.numero_de_pedido
INNER JOIN productos AS pr
    ON l.codigo = pr.codigo
WHERE
    c.nombre = 'Pepe'
    AND pr.codigo = 5;

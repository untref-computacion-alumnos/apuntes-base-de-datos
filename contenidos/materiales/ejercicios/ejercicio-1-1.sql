SELECT DISTINCT pr.descripcion
FROM productos AS pr
INNER JOIN lineas AS l
    ON pr.codigo = l.codigo
INNER JOIN pedidos AS p
    ON l.numero_de_pedido = p.numero_de_pedido
INNER JOIN clientes AS c
    ON p.numero_de_cliente = c.numero_de_cliente
WHERE c.ciudad = 'Rosario';

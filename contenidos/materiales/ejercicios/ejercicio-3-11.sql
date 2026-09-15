SELECT DISTINCT p.numero_de_pedido
FROM pedidos AS p
INNER JOIN detalles AS d
    ON p.numero_de_pedido = d.numero_de_pedido
INNER JOIN articulos AS a
    ON d.codigo_de_articulo = a.codigo_de_articulo
WHERE a.tipo IN ('A', 'B');

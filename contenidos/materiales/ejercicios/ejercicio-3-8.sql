SELECT
    a.codigo_de_articulo,
    a.descripcion
FROM articulos AS a
INNER JOIN detalles AS d
    ON a.codigo_de_articulo = d.codigo_de_articulo
INNER JOIN pedidos AS p
    ON d.numero_de_pedido = p.numero_de_pedido
WHERE p.fecha_de_entrega > CURRENT_DATE
GROUP BY a.codigo_de_articulo, a.descripcion, a.stock
HAVING SUM(d.cantidad) > a.stock;

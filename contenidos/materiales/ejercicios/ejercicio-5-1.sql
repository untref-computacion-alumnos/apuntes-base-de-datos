SELECT
    a.codigo_de_articulo,
    a.descripcion,
    SUM(d.cantidad) AS total_unidades
FROM articulos AS a
INNER JOIN detalles AS d
    ON a.codigo_de_articulo = d.codigo_de_articulo
INNER JOIN pedidos AS p
    ON d.numero_de_pedido = p.numero_de_pedido
WHERE
    p.fecha_de_entrega BETWEEN CURRENT_DATE AND (
        CURRENT_DATE + INTERVAL '7' DAY
    )
GROUP BY a.codigo_de_articulo, a.descripcion;

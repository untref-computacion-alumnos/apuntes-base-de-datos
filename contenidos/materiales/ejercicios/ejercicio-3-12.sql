SELECT
    a.codigo_de_articulo,
    a.descripcion
FROM articulos AS a
WHERE NOT EXISTS (
    SELECT 1
    FROM detalles AS d
    INNER JOIN pedidos AS p
        ON d.numero_de_pedido = p.numero_de_pedido
    WHERE
        d.codigo_de_articulo = a.codigo_de_articulo
        AND p.fecha_de_entrega > CURRENT_DATE
);

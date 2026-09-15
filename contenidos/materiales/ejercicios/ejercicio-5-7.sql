SELECT DISTINCT
    a.codigo_de_articulo,
    a.descripcion,
    a.precio,
    c.apellido,
    c.nombre
FROM articulos AS a
INNER JOIN detalles AS d
    ON a.codigo_de_articulo = d.codigo_de_articulo
INNER JOIN pedidos AS p
    ON d.numero_de_pedido = p.numero_de_pedido
INNER JOIN clientes AS c
    ON p.id_de_cliente = c.id_de_cliente
WHERE a.precio = (
    SELECT MAX(a_max.precio)
    FROM articulos AS a_max
);

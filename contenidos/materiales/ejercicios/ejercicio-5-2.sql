SELECT
    a.codigo_de_articulo,
    a.descripcion
FROM articulos AS a
WHERE NOT EXISTS (
    SELECT 1
    FROM detalles AS d
    WHERE d.codigo_de_articulo = a.codigo_de_articulo
);

SELECT
    a.codigo_de_articulo,
    a.descripcion
FROM articulos AS a
LEFT JOIN detalles AS d
    ON a.codigo_de_articulo = d.codigo_de_articulo
WHERE d.codigo_de_articulo IS NULL;

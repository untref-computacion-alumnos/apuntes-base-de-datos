SELECT
    a.codigo_de_articulo,
    a.descripcion,
    a.precio
FROM articulos AS a
WHERE a.precio BETWEEN 20 AND 50;

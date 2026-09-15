SELECT
    a.codigo_de_articulo,
    a.descripcion,
    a.stock,
    a.tipo,
    a.precio,
    a.punto_de_reorden
FROM articulos AS a
WHERE a.stock < (a.punto_de_reorden * 0.1);

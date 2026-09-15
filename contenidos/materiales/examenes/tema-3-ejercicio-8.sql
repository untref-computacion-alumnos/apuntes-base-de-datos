SELECT art.descripcion
FROM articulos AS art
WHERE art.anio_fabricacion = (
    SELECT MIN(art_min.anio_fabricacion)
    FROM articulos AS art_min
);

WITH pel_2015 AS (
    SELECT
        r.id_de_actor,
        p.nombre
    FROM repartos AS r
    INNER JOIN peliculas AS p
        ON r.id_de_pelicula = p.id_de_pelicula
    WHERE p.anio = 2015
)

SELECT
    a.apellido,
    pel_2015.nombre AS nombre_pelicula
FROM actores AS a
LEFT JOIN pel_2015
    ON a.id_de_actor = pel_2015.id_de_actor
WHERE a.nacionalidad = 'Argentina';

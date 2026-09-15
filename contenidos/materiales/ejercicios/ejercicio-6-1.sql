SELECT
    a.apellido,
    a.nombre
FROM actores AS a
WHERE
    a.nacionalidad = 'Argentina'
    AND NOT EXISTS (
        SELECT 1
        FROM repartos AS r
        INNER JOIN peliculas AS p
            ON r.id_de_pelicula = p.id_de_pelicula
        WHERE
            r.id_de_actor = a.id_de_actor
            AND p.anio = 2020
    );

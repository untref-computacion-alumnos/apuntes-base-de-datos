SELECT
    a.apellido,
    a.nombre
FROM actores AS a
INNER JOIN repartos AS r
    ON a.id_de_actor = r.id_de_actor
INNER JOIN peliculas AS p
    ON r.id_de_pelicula = p.id_de_pelicula
WHERE p.anio = 2016
GROUP BY a.id_de_actor, a.apellido, a.nombre
HAVING COUNT(DISTINCT p.id_de_pelicula) = 2;

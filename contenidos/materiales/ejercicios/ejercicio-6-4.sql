SELECT
    p.nombre,
    p.genero
FROM peliculas AS p
INNER JOIN repartos AS r
    ON p.id_de_pelicula = r.id_de_pelicula
GROUP BY p.id_de_pelicula, p.nombre, p.genero
HAVING COUNT(r.id_de_actor) > 10;

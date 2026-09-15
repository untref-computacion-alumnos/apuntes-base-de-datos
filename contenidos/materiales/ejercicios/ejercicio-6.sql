-- Trabajo Práctico 1 - Ejercicio 6
-- Resolución en SQL ANSI de las consignas descriptas en practica-1.md

-- =============================================================================
-- Esquema
-- =============================================================================

CREATE TABLE actores (
    id_de_actor INTEGER NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_de_actor)
);

CREATE TABLE peliculas (
    id_de_pelicula INTEGER NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    genero VARCHAR(50) NOT NULL,
    anio INTEGER NOT NULL,
    PRIMARY KEY (id_de_pelicula)
);

CREATE TABLE repartos (
    id_de_actor INTEGER NOT NULL,
    id_de_pelicula INTEGER NOT NULL,
    PRIMARY KEY (id_de_actor, id_de_pelicula),
    FOREIGN KEY (id_de_actor) REFERENCES actores (id_de_actor),
    FOREIGN KEY (id_de_pelicula) REFERENCES peliculas (id_de_pelicula)
);

-- =============================================================================
-- Consignas
-- =============================================================================

-- 1. Listar el apellido y el nombre de los actores argentinos que no
--    trabajaron en ninguna película en el año 2020.
SELECT
    act.apellido,
    act.nombre
FROM actores AS act
WHERE
    act.nacionalidad = 'Argentina'
    AND NOT EXISTS (
        SELECT 1
        FROM repartos AS rep
        INNER JOIN peliculas AS pel
            ON rep.id_de_pelicula = pel.id_de_pelicula
        WHERE
            rep.id_de_actor = act.id_de_actor
            AND pel.anio = 2020
    );

-- 2. Listar el apellido y el nombre de los actores que trabajaron en dos
--    películas que se estrenaron en el año 2016.
SELECT
    act.apellido,
    act.nombre
FROM actores AS act
INNER JOIN repartos AS rep
    ON act.id_de_actor = rep.id_de_actor
INNER JOIN peliculas AS pel
    ON rep.id_de_pelicula = pel.id_de_pelicula
WHERE pel.anio = 2016
GROUP BY act.id_de_actor, act.apellido, act.nombre
HAVING COUNT(DISTINCT pel.id_de_pelicula) = 2;

-- 3. Listar los apellidos de todos los actores argentinos y, si trabajaron
--    en alguna película del año 2015, listar el nombre de esas películas
--    (no importa que se repita el apellido si hizo más de una película).
WITH pel_2015 AS (
    SELECT
        rep.id_de_actor,
        pel.nombre
    FROM repartos AS rep
    INNER JOIN peliculas AS pel
        ON rep.id_de_pelicula = pel.id_de_pelicula
    WHERE pel.anio = 2015
)

SELECT
    act.apellido,
    pel_2015.nombre AS nombre_pelicula
FROM actores AS act
LEFT JOIN pel_2015
    ON act.id_de_actor = pel_2015.id_de_actor
WHERE act.nacionalidad = 'Argentina';

-- 4. Listar el nombre y el género de las películas que tienen más de 10
--    actores en su reparto.
SELECT
    pel.nombre,
    pel.genero
FROM peliculas AS pel
INNER JOIN repartos AS rep
    ON pel.id_de_pelicula = rep.id_de_pelicula
GROUP BY pel.id_de_pelicula, pel.nombre, pel.genero
HAVING COUNT(rep.id_de_actor) > 10;

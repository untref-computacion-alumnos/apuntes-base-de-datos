-- Trabajo Práctico 1 - Ejercicio 7
-- Resolución en SQL ANSI de las consignas descriptas en practica-1.md

-- =============================================================================
-- Esquema
-- =============================================================================

CREATE TABLE facultades (
    codigo_de_facultad INTEGER NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    PRIMARY KEY (codigo_de_facultad)
);

CREATE TABLE investigadores (
    dni VARCHAR(15) NOT NULL,
    apellido_y_nombre VARCHAR(150) NOT NULL,
    codigo_de_facultad INTEGER NOT NULL,
    PRIMARY KEY (dni),
    FOREIGN KEY (codigo_de_facultad) REFERENCES facultades (codigo_de_facultad)
);

CREATE TABLE equipos (
    numero_de_serie INTEGER NOT NULL,
    descripcion VARCHAR(150) NOT NULL,
    valor DECIMAL(12, 2) NOT NULL,
    PRIMARY KEY (numero_de_serie)
);

CREATE TABLE reservas (
    dni VARCHAR(15) NOT NULL,
    numero_de_serie INTEGER NOT NULL,
    desde_cuando DATE NOT NULL,
    hasta_cuando DATE NOT NULL,
    PRIMARY KEY (dni, numero_de_serie, desde_cuando),
    FOREIGN KEY (dni) REFERENCES investigadores (dni),
    FOREIGN KEY (numero_de_serie) REFERENCES equipos (numero_de_serie)
);

-- =============================================================================
-- Consignas
-- =============================================================================

-- 1. Listar todos los equipos y, si hay alguna reserva de hoy, mostrar el
--    apellido y nombre del investigador que hizo esa reserva.
WITH res_hoy AS (
    SELECT
        res.numero_de_serie,
        res.dni
    FROM reservas AS res
    WHERE CURRENT_DATE BETWEEN res.desde_cuando AND res.hasta_cuando
)

SELECT
    equ.numero_de_serie,
    equ.descripcion,
    inv.apellido_y_nombre
FROM equipos AS equ
LEFT JOIN res_hoy
    ON equ.numero_de_serie = res_hoy.numero_de_serie
LEFT JOIN investigadores AS inv
    ON res_hoy.dni = inv.dni;

-- 2. Listar el DNI y el apellido y nombre de aquellos investigadores que
--    realizaron más de una reserva.
SELECT
    inv.dni,
    inv.apellido_y_nombre
FROM investigadores AS inv
INNER JOIN reservas AS res
    ON inv.dni = res.dni
GROUP BY inv.dni, inv.apellido_y_nombre
HAVING COUNT(*) > 1;

-- 3. Listar el número de serie y la descripción de los equipos que nunca
--    fueron reservados.
SELECT
    equ.numero_de_serie,
    equ.descripcion
FROM equipos AS equ
WHERE NOT EXISTS (
    SELECT 1
    FROM reservas AS res
    WHERE res.numero_de_serie = equ.numero_de_serie
);

-- 4. Listar el nombre de la facultad y el apellido y nombre de los
--    investigadores que reservaron este año el equipo de mayor valor.
SELECT DISTINCT
    fac.nombre AS nombre_facultad,
    inv.apellido_y_nombre
FROM facultades AS fac
INNER JOIN investigadores AS inv
    ON fac.codigo_de_facultad = inv.codigo_de_facultad
INNER JOIN reservas AS res
    ON inv.dni = res.dni
INNER JOIN equipos AS equ
    ON res.numero_de_serie = equ.numero_de_serie
WHERE equ.valor = (
    SELECT MAX(equ_max.valor)
    FROM equipos AS equ_max
)
AND EXTRACT(YEAR FROM res.desde_cuando) = EXTRACT(YEAR FROM CURRENT_DATE);

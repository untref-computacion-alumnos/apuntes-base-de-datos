-- Trabajo Práctico 1 - Ejercicio 2
-- Resolución en SQL ANSI de las consignas descriptas en practica-1.md

-- =============================================================================
-- Esquema
-- =============================================================================

CREATE TABLE trabajadores (
    legajo INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    tarifa DECIMAL(10, 2) NOT NULL,
    oficio VARCHAR(50) NOT NULL,
    supervisor INTEGER,
    PRIMARY KEY (legajo),
    FOREIGN KEY (supervisor) REFERENCES trabajadores(legajo)
);

CREATE TABLE edificios (
    id INTEGER NOT NULL,
    direccion VARCHAR(150) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    calidad VARCHAR(50) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE asignaciones (
    legajo INTEGER NOT NULL,
    id INTEGER NOT NULL,
    fecha_de_inicio DATE NOT NULL,
    numero_de_dias INTEGER NOT NULL,
    PRIMARY KEY (legajo, id, fecha_de_inicio),
    FOREIGN KEY (legajo) REFERENCES trabajadores(legajo),
    FOREIGN KEY (id) REFERENCES edificios(id)
);

-- =============================================================================
-- Consignas
-- =============================================================================

-- 1. ¿Cuáles son los oficios de los trabajadores asignados al edificio 435?
SELECT DISTINCT tra.oficio
FROM trabajadores AS tra
INNER JOIN asignaciones AS asi
    ON tra.legajo = asi.legajo
WHERE asi.id = 435;

-- 2. Indicar el nombre del trabajador y el de su supervisor.
SELECT
    tra.nombre AS nombre_trabajador,
    sup.nombre AS nombre_supervisor
FROM trabajadores AS tra
LEFT JOIN trabajadores AS sup
    ON tra.supervisor = sup.legajo;

-- 3. Listar el nombre de los trabajadores que no están asignados a ningún
--    edificio cuya categoría sea "oficina".
SELECT tra.nombre
FROM trabajadores AS tra
WHERE NOT EXISTS (
    SELECT 1
    FROM asignaciones AS asi
    INNER JOIN edificios AS edi
        ON asi.id = edi.id
    WHERE
        asi.legajo = tra.legajo
        AND edi.categoria = 'oficina'
);

-- 4. Listar los nombres de los trabajadores que reciben una tarifa por hora
--    mayor que la de su supervisor.
SELECT tra.nombre
FROM trabajadores AS tra
INNER JOIN trabajadores AS sup
    ON tra.supervisor = sup.legajo
WHERE tra.tarifa > sup.tarifa;

-- 5. ¿Cuál es el número total de días que se dedicaron a la plomería en el
--    edificio 312?
SELECT SUM(asi.numero_de_dias) AS total_dias_plomeria
FROM asignaciones AS asi
INNER JOIN trabajadores AS tra
    ON asi.legajo = tra.legajo
WHERE
    asi.id = 312
    AND tra.oficio = 'Plomero';

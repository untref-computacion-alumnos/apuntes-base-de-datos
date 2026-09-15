SELECT
    jug.nombre,
    jug.fecha_nacimiento,
    clu.nombre AS nombre_club
FROM jugadores AS jug
INNER JOIN equipos_actuales AS equ
    ON jug.legajo = equ.legajo
INNER JOIN clubes AS clu
    ON equ.id_club = clu.id_club
WHERE jug.fecha_nacimiento = (
    SELECT MIN(jug_min.fecha_nacimiento)
    FROM jugadores AS jug_min
    INNER JOIN equipos_actuales AS equ_min
        ON jug_min.legajo = equ_min.legajo
    WHERE equ_min.id_club = equ.id_club
);

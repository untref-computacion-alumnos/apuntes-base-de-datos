SELECT
    jug.nombre,
    jug.categoria,
    clu.nombre AS nombre_club
FROM jugadores AS jug
LEFT JOIN equipos_actuales AS equ
    ON jug.legajo = equ.legajo
LEFT JOIN clubes AS clu
    ON equ.id_club = clu.id_club;

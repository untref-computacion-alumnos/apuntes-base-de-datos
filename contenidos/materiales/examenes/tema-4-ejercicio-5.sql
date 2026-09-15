SELECT
    jug.categoria,
    COUNT(*) AS cantidad_de_jugadores
FROM jugadores AS jug
INNER JOIN equipos_actuales AS equ
    ON jug.legajo = equ.legajo
WHERE equ.id_club NOT IN (
    SELECT par.id_club_local
    FROM partidos AS par
    WHERE par.numero_de_fecha = 1
    UNION
    SELECT par.id_club_visitante
    FROM partidos AS par
    WHERE par.numero_de_fecha = 1
)
GROUP BY jug.categoria;

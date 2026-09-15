WITH par_mes AS (
    SELECT
        par.id_club_local AS id_club,
        par.numero_de_zona,
        par.fecha_partido
    FROM partidos AS par
    WHERE
        EXTRACT(YEAR FROM par.fecha_partido) = EXTRACT(YEAR FROM CURRENT_DATE)
        AND EXTRACT(MONTH FROM par.fecha_partido) = EXTRACT(
            MONTH FROM CURRENT_DATE
        )
    UNION
    SELECT
        par.id_club_visitante AS id_club,
        par.numero_de_zona,
        par.fecha_partido
    FROM partidos AS par
    WHERE
        EXTRACT(YEAR FROM par.fecha_partido) = EXTRACT(YEAR FROM CURRENT_DATE)
        AND EXTRACT(MONTH FROM par.fecha_partido) = EXTRACT(
            MONTH FROM CURRENT_DATE
        )
)

SELECT
    clu.nombre,
    clu.numero_de_zona,
    par_mes.numero_de_zona AS zona_del_partido,
    par_mes.fecha_partido
FROM clubes AS clu
LEFT JOIN par_mes
    ON clu.id_club = par_mes.id_club;

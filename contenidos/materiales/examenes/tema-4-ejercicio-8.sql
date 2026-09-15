SELECT par.id_partido
FROM partidos AS par
WHERE
    EXTRACT(YEAR FROM par.fecha_partido) = 2023
    AND par.goles_visitante > (
        SELECT AVG(par_avg.goles_visitante)
        FROM partidos AS par_avg
        WHERE EXTRACT(YEAR FROM par_avg.fecha_partido) = 2023
    );

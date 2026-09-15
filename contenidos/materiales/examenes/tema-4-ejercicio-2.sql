SELECT
    clu.nombre,
    SUM(par.goles_visitante) AS goles_de_visitante
FROM clubes AS clu
INNER JOIN partidos AS par
    ON clu.id_club = par.id_club_visitante
WHERE EXTRACT(YEAR FROM par.fecha_partido) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY clu.id_club, clu.nombre
HAVING SUM(par.goles_visitante) > 10;

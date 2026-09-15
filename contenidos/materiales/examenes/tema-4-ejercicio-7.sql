SELECT clu.nombre
FROM clubes AS clu
WHERE NOT EXISTS (
    SELECT 1
    FROM partidos AS par
    WHERE
        (
            par.id_club_local = clu.id_club
            OR par.id_club_visitante = clu.id_club
        )
        AND par.goles_local = par.goles_visitante
);

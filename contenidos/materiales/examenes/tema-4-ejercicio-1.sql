SELECT
    par.id_partido,
    par.numero_de_fecha,
    par.fecha_partido,
    par.id_club_local,
    par.id_club_visitante
FROM partidos AS par
WHERE
    par.id_club_local IN (
        SELECT clu.id_club
        FROM clubes AS clu
        WHERE clu.nombre LIKE '%Los Andes%'
    )
    OR par.id_club_visitante IN (
        SELECT clu.id_club
        FROM clubes AS clu
        WHERE clu.nombre LIKE '%Los Andes%'
    );

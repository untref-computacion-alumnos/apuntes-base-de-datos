SELECT *
FROM traductor
WHERE traductor.id_traductor NOT IN (
    SELECT id_traductor
    FROM libro
);

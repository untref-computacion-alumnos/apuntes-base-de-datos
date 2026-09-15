SELECT
    e.numero_de_serie,
    e.descripcion
FROM equipos AS e
WHERE NOT EXISTS (
    SELECT 1
    FROM reservas AS r
    WHERE r.numero_de_serie = e.numero_de_serie
);

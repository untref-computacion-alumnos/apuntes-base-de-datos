SELECT DISTINCT
    f.nombre AS nombre_facultad,
    i.apellido_y_nombre
FROM facultades AS f
INNER JOIN investigadores AS i
    ON f.codigo_de_facultad = i.codigo_de_facultad
INNER JOIN reservas AS r
    ON i.dni = r.dni
INNER JOIN equipos AS e
    ON r.numero_de_serie = e.numero_de_serie
WHERE
    e.valor = (
        SELECT MAX(e_max.valor)
        FROM equipos AS e_max
    )
    AND EXTRACT(YEAR FROM r.desde_cuando) = EXTRACT(YEAR FROM CURRENT_DATE);

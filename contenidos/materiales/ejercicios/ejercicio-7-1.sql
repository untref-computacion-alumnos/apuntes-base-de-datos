WITH res_hoy AS (
    SELECT
        r.numero_de_serie,
        r.dni
    FROM reservas AS r
    WHERE CURRENT_DATE BETWEEN r.desde_cuando AND r.hasta_cuando
)

SELECT
    e.numero_de_serie,
    e.descripcion,
    i.apellido_y_nombre
FROM equipos AS e
LEFT JOIN res_hoy
    ON e.numero_de_serie = res_hoy.numero_de_serie
LEFT JOIN investigadores AS i
    ON res_hoy.dni = i.dni;

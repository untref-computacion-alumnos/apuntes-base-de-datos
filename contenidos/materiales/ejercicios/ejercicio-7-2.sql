SELECT
    i.dni,
    i.apellido_y_nombre
FROM investigadores AS i
INNER JOIN reservas AS r
    ON i.dni = r.dni
GROUP BY i.dni, i.apellido_y_nombre
HAVING COUNT(*) > 1;

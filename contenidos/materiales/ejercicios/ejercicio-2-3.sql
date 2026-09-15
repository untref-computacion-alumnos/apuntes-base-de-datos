SELECT t.nombre
FROM trabajadores AS t
WHERE NOT EXISTS (
    SELECT 1
    FROM asignaciones AS a
    INNER JOIN edificios AS e
        ON a.id = e.id
    WHERE
        t.legajo = a.legajo
        AND e.categoria = 'oficina'
);

SELECT t.oficio
FROM trabajadores AS t
INNER JOIN asignaciones AS a
    ON t.legajo = a.legajo
INNER JOIN edificios AS e
    ON a.id = e.id
WHERE e.id = 435;

SELECT SUM(a.numero_de_dias) AS total
FROM asignaciones AS a
INNER JOIN trabajadores AS t
    ON a.legajo = t.legajo
WHERE
    a.id = 312
    AND t.oficio = 'Plomero';

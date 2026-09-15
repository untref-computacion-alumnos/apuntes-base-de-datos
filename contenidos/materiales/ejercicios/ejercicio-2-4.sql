SELECT t.nombre
FROM trabajadores AS t
INNER JOIN trabajadores AS s
    ON t.supervisor = s.legajo
WHERE t.tarifa > s.tarifa;

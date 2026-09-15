SELECT
    t.nombre AS trabajador,
    s.nombre AS supervisor
FROM trabajadores AS t
LEFT JOIN trabajadores AS s
    ON t.legajo = s.supervisor;

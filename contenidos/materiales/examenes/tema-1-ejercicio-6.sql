SELECT
    emp.legajo,
    emp.nombre
FROM empleados AS emp
WHERE NOT EXISTS (
    SELECT 1
    FROM proyectos AS pro
    WHERE
        pro.numero_de_proyecto = emp.numero_de_proyecto
        AND pro.fecha_prevista_fin > CURRENT_DATE
);

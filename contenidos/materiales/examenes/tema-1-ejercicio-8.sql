SELECT
    emp.nombre,
    pro.nombre_proyecto
FROM empleados AS emp
LEFT JOIN proyectos AS pro
    ON emp.numero_de_proyecto = pro.numero_de_proyecto;

SELECT
    pro.numero_de_proyecto,
    pro.nombre_proyecto
FROM proyectos AS pro
INNER JOIN empleados AS emp
    ON pro.numero_de_proyecto = emp.numero_de_proyecto
GROUP BY pro.numero_de_proyecto, pro.nombre_proyecto
HAVING AVG(emp.sueldo) < 8000;

SELECT emp.nombre_departamento
FROM empleados AS emp
WHERE emp.numero_de_proyecto IS NOT NULL
GROUP BY emp.nombre_departamento
HAVING COUNT(DISTINCT emp.numero_de_proyecto) > 1;

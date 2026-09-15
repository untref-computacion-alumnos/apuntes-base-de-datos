SELECT d.descripcion
FROM departamentos AS d
INNER JOIN empleados AS e
    ON d.codigo_de_departamento = e.codigo_de_departamento
GROUP BY d.codigo_de_departamento
HAVING AVG(e.sueldo) > 3000;

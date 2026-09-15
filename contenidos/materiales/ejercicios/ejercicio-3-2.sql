SELECT
    d.codigo_de_departamento,
    d.descripcion,
    SUM(e.sueldo) AS total_de_sueldos,
    AVG(e.sueldo) AS promedio_de_sueldos
FROM empleados AS e
INNER JOIN departamentos AS d
    ON e.codigo_de_departamento = d.codigo_de_departamento
GROUP BY d.codigo_de_departamento, d.descripcion;

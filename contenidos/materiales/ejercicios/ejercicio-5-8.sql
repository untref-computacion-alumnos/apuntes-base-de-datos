SELECT
    d.descripcion,
    COUNT(e.codigo_de_empleado) AS cantidad_de_empleados
FROM departamentos AS d
LEFT JOIN empleados AS e
    ON d.codigo_de_departamento = e.codigo_de_departamento
GROUP BY d.codigo_de_departamento, d.descripcion;

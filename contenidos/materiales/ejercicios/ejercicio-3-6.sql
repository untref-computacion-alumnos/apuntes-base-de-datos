SELECT
    e.codigo_de_empleado,
    e.nombre,
    e.direccion,
    e.codigo_de_departamento,
    e.sueldo
FROM empleados AS e
INNER JOIN pedidos AS p
    ON e.codigo_de_empleado = p.codigo_de_empleado
WHERE p.fecha_de_entrega > CURRENT_DATE
GROUP BY
    e.codigo_de_empleado,
    e.nombre,
    e.direccion,
    e.codigo_de_departamento,
    e.sueldo
HAVING COUNT(*) > 3;

SELECT
    e.codigo_de_empleado,
    e.nombre,
    e.direccion,
    e.codigo_de_departamento,
    e.sueldo
FROM empleados AS e
WHERE (
    SELECT COUNT(*)
    FROM pedidos AS p
    WHERE
        p.codigo_de_empleado = e.codigo_de_empleado
        AND p.fecha_de_entrega > CURRENT_DATE
) > 3;

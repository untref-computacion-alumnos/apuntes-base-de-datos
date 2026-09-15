SELECT
    emp.codigo_de_empleado,
    emp.nombre,
    COUNT(ped.numero_de_pedido) AS cantidad_de_pedidos
FROM empleados AS emp
LEFT JOIN pedidos AS ped
    ON emp.codigo_de_empleado = ped.codigo_de_empleado
WHERE emp.codigo_de_departamento = 'A'
GROUP BY emp.codigo_de_empleado, emp.nombre;

SELECT
    e.nombre,
    e.codigo_de_departamento
FROM empleados AS e
WHERE e.sueldo = (
    SELECT MIN(em.sueldo)
    FROM empleados AS em
);

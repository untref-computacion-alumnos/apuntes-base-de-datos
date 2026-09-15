SELECT
    emp.legajo,
    emp.nombre
FROM empleados AS emp
WHERE emp.sueldo = (
    SELECT MAX(emp_max.sueldo)
    FROM empleados AS emp_max
);

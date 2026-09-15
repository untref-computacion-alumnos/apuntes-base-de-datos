SELECT
    v.nombre,
    v.localidad
FROM vendedores AS v
INNER JOIN clientes AS c
    ON v.numero_de_vendedor = c.numero_de_vendedor
WHERE c.limite_de_credito > (
    SELECT AVG(cl.limite_de_credito)
    FROM clientes AS cl
);

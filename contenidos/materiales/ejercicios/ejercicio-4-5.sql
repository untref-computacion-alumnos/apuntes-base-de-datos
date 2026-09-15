SELECT
    v.nombre
FROM vendedores AS v
WHERE
    v.porcentaje > 7
    AND (
        SELECT COUNT(DISTINCT c.numero_de_cliente)
        FROM clientes AS c
        INNER JOIN pedidos AS p
            ON c.numero_de_cliente = p.numero_de_cliente
        WHERE
            v.numero_de_vendedor = c.numero_de_vendedor
            AND c.localidad = 'Rosario'
            AND p.fecha < DATE '1991-12-31'
    ) > 1;

SELECT
    v.numero_de_vendedor,
    v.nombre
FROM vendedores AS v
INNER JOIN clientes AS c
    ON v.numero_de_vendedor = c.numero_de_vendedor
INNER JOIN pedidos AS p
    ON c.numero_de_cliente = p.numero_de_cliente
WHERE
    v.porcentaje > 7
    AND c.localidad = 'Rosario'
    AND p.fecha < DATE '1991-12-31'
GROUP BY v.numero_de_vendedor, v.nombre
HAVING COUNT(DISTINCT c.numero_de_cliente) > 1;

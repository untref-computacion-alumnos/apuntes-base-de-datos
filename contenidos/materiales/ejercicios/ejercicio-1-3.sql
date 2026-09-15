SELECT c.nombre
FROM clientes AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM pedidos AS p
    WHERE
        p.numero_de_cliente = c.numero_de_cliente
        AND p.fecha = CURRENT_DATE
);

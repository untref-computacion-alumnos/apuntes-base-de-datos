SELECT
    cli.numero_de_cliente,
    cli.nombre,
    cli.ciudad,
    cli.provincia
FROM clientes AS cli
WHERE EXISTS (
    SELECT 1
    FROM pedidos AS ped
    WHERE ped.numero_de_cliente = cli.numero_de_cliente
    GROUP BY ped.fecha
    HAVING COUNT(*) > 1
);

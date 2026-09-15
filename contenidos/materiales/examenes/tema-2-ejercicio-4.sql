SELECT
    cli.numero_de_cliente,
    cli.nombre,
    cli.ciudad,
    cli.provincia,
    COUNT(ped.numero_de_pedido) AS pedidos_del_mes
FROM clientes AS cli
LEFT JOIN pedidos AS ped
    ON
        cli.numero_de_cliente = ped.numero_de_cliente
        AND EXTRACT(YEAR FROM ped.fecha) = EXTRACT(YEAR FROM CURRENT_DATE)
        AND EXTRACT(MONTH FROM ped.fecha) = EXTRACT(MONTH FROM CURRENT_DATE)
GROUP BY cli.numero_de_cliente, cli.nombre, cli.ciudad, cli.provincia;

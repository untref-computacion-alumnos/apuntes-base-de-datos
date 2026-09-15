SELECT
    cli.nombre,
    AVG(lin.cantidad) AS promedio_pedido
FROM clientes AS cli
INNER JOIN pedidos AS ped
    ON cli.numero_de_cliente = ped.numero_de_cliente
INNER JOIN lineas AS lin
    ON ped.numero_de_pedido = lin.numero_de_pedido
WHERE EXTRACT(YEAR FROM ped.fecha) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY cli.numero_de_cliente, cli.nombre
HAVING COUNT(DISTINCT ped.numero_de_pedido) > 20;

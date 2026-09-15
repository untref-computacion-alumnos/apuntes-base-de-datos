SELECT DISTINCT cli.nombre
FROM clientes AS cli
INNER JOIN pedidos AS ped
    ON cli.numero_de_cliente = ped.numero_de_cliente
INNER JOIN lineas AS lin
    ON ped.numero_de_pedido = lin.numero_de_pedido
INNER JOIN productos AS pro
    ON lin.codigo_de_producto = pro.codigo_de_producto
WHERE pro.precio > (
    SELECT AVG(pro_avg.precio)
    FROM productos AS pro_avg
);

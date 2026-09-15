SELECT
    pro.descripcion,
    cli.nombre
FROM productos AS pro
LEFT JOIN lineas AS lin
    ON pro.codigo_de_producto = lin.codigo_de_producto
LEFT JOIN pedidos AS ped
    ON lin.numero_de_pedido = ped.numero_de_pedido
LEFT JOIN clientes AS cli
    ON
        ped.numero_de_cliente = cli.numero_de_cliente
        AND cli.ciudad = 'Rosario';

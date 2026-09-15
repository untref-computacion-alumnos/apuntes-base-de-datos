SELECT pro.descripcion
FROM productos AS pro
WHERE NOT EXISTS (
    SELECT 1
    FROM lineas AS lin
    INNER JOIN pedidos AS ped
        ON lin.numero_de_pedido = ped.numero_de_pedido
    INNER JOIN clientes AS cli
        ON ped.numero_de_cliente = cli.numero_de_cliente
    WHERE
        lin.codigo_de_producto = pro.codigo_de_producto
        AND cli.provincia = 'La Rioja'
        AND EXTRACT(YEAR FROM ped.fecha) = EXTRACT(YEAR FROM CURRENT_DATE)
        AND EXTRACT(MONTH FROM ped.fecha) = EXTRACT(MONTH FROM CURRENT_DATE)
);

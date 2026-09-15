SELECT
    p.numero_de_pedido,
    p.id_de_cliente,
    p.codigo_de_empleado,
    p.fecha_de_entrega
FROM pedidos AS p
INNER JOIN clientes AS c
    ON p.id_de_cliente = c.id_de_cliente
WHERE c.nombre LIKE 'M%';

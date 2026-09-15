SELECT
    c.apellido,
    c.nombre,
    c.telefono,
    COUNT(p.numero_de_pedido) AS cantidad_de_pedidos
FROM clientes AS c
LEFT JOIN pedidos AS p
    ON
        c.id_de_cliente = p.id_de_cliente
        AND p.fecha_de_entrega >= CURRENT_DATE - INTERVAL '1' MONTH
GROUP BY c.id_de_cliente, c.apellido, c.nombre, c.telefono;

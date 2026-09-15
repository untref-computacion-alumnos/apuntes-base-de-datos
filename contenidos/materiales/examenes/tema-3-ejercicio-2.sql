SELECT
    cli.nombre,
    SUM(ser.precio) AS total_pagado
FROM clientes AS cli
INNER JOIN trabajos AS tra
    ON cli.numero_de_cliente = tra.numero_de_cliente
INNER JOIN servicios AS ser
    ON tra.numero_de_servicio = ser.numero_de_servicio
WHERE EXTRACT(YEAR FROM tra.fecha) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY cli.numero_de_cliente, cli.nombre
HAVING SUM(ser.precio) > 10000;

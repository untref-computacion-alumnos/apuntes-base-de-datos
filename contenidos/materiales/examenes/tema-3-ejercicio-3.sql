SELECT DISTINCT
    cli.nombre,
    cli.direccion
FROM clientes AS cli
INNER JOIN trabajos AS tra
    ON cli.numero_de_cliente = tra.numero_de_cliente
INNER JOIN articulos AS art
    ON tra.codigo_de_articulo = art.codigo_de_articulo
INNER JOIN servicios AS ser
    ON tra.numero_de_servicio = ser.numero_de_servicio
WHERE
    (EXTRACT(YEAR FROM CURRENT_DATE) - art.anio_fabricacion) > 10
    AND ser.precio > 100;

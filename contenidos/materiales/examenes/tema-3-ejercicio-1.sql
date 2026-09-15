SELECT COUNT(DISTINCT art.codigo_de_articulo) AS cantidad_de_articulos
FROM articulos AS art
INNER JOIN trabajos AS tra
    ON art.codigo_de_articulo = tra.codigo_de_articulo
INNER JOIN clientes AS cli
    ON tra.numero_de_cliente = cli.numero_de_cliente
WHERE
    cli.nombre = 'Juan'
    AND NOT EXISTS (
        SELECT 1
        FROM trabajos AS tra_anio
        WHERE
            tra_anio.codigo_de_articulo = art.codigo_de_articulo
            AND tra_anio.numero_de_cliente = cli.numero_de_cliente
            AND EXTRACT(YEAR FROM tra_anio.fecha) = EXTRACT(
                YEAR FROM CURRENT_DATE
            )
    );

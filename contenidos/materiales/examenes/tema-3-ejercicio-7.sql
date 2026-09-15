SELECT cli.nombre
FROM clientes AS cli
WHERE NOT EXISTS (
    SELECT 1
    FROM trabajos AS tra
    INNER JOIN articulos AS art
        ON tra.codigo_de_articulo = art.codigo_de_articulo
    WHERE
        tra.numero_de_cliente = cli.numero_de_cliente
        AND art.anio_fabricacion = EXTRACT(YEAR FROM CURRENT_DATE) - 2
);

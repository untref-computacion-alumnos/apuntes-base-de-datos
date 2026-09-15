WITH tra_caba AS (
    SELECT
        tra.codigo_de_articulo,
        cli.nombre
    FROM trabajos AS tra
    INNER JOIN clientes AS cli
        ON tra.numero_de_cliente = cli.numero_de_cliente
    WHERE
        cli.localidad = 'CABA'
        AND tra.fecha = DATE '2018-01-01'
)

SELECT
    art.descripcion,
    tra_caba.nombre
FROM articulos AS art
LEFT JOIN tra_caba
    ON art.codigo_de_articulo = tra_caba.codigo_de_articulo;

WITH tra_mes AS (
    SELECT
        tra.numero_de_cliente,
        art.descripcion
    FROM trabajos AS tra
    INNER JOIN articulos AS art
        ON tra.codigo_de_articulo = art.codigo_de_articulo
    WHERE
        EXTRACT(YEAR FROM tra.fecha) = EXTRACT(YEAR FROM CURRENT_DATE)
        AND EXTRACT(MONTH FROM tra.fecha) = EXTRACT(MONTH FROM CURRENT_DATE)
)

SELECT
    cli.nombre,
    tra_mes.descripcion
FROM clientes AS cli
LEFT JOIN tra_mes
    ON cli.numero_de_cliente = tra_mes.numero_de_cliente
WHERE cli.localidad = 'Rosario';

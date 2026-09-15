SELECT
    cli.nombre,
    cli.ciudad
FROM clientes AS cli
WHERE NOT EXISTS (
    SELECT 1
    FROM proyectos AS pro
    WHERE pro.numero_de_cliente = cli.numero_de_cliente
);

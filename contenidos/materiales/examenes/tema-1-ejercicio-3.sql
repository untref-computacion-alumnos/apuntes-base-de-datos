SELECT
    cli.numero_de_cliente,
    cli.nombre,
    pro.nombre_proyecto,
    pro.presupuesto
FROM clientes AS cli
LEFT JOIN proyectos AS pro
    ON cli.numero_de_cliente = pro.numero_de_cliente;

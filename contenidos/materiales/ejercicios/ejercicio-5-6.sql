SELECT
    c.id_de_cliente,
    c.apellido,
    c.nombre,
    c.telefono
FROM clientes AS c
WHERE EXISTS (
    SELECT 1
    FROM articulos AS a
    WHERE
        a.descripcion = 'lápiz'
        AND a.stock > a.punto_de_reorden
);

SELECT AVG(pro.precio) AS precio_promedio
FROM productos AS pro
WHERE pro.color <> 'Rojo';

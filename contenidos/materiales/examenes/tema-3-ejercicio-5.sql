SELECT art.descripcion
FROM articulos AS art
INNER JOIN trabajos AS tra
    ON art.codigo_de_articulo = tra.codigo_de_articulo
INNER JOIN servicios AS ser
    ON tra.numero_de_servicio = ser.numero_de_servicio
WHERE
    ser.precio > 100
    AND EXTRACT(YEAR FROM tra.fecha) = EXTRACT(YEAR FROM CURRENT_DATE)
    AND EXTRACT(MONTH FROM tra.fecha) = EXTRACT(MONTH FROM CURRENT_DATE)
GROUP BY art.codigo_de_articulo, art.descripcion
HAVING COUNT(*) > 10;

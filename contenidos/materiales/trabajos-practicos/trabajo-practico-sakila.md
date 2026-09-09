# Trabajo Práctico Sakila

## Ejercicio 1

Listar `first_name` y `last_name` de los actores que trabajaron en la película
`African Egg`.

```sql
SELECT
	a.first_name,
	a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa
	ON a.actor_id = fa.actor_id
INNER JOIN film AS f
	ON fa.film_id = f.film_id
WHERE f.title = "AFRICAN EGG";
```

## Ejercicio 2

Listar `first_name` y `last_name` de los actores que nunca trabajaron en una
película del género `Horror`.

```sql
SELECT
	a.first_name,
	a.last_name
FROM actor AS a
WHERE NOT EXISTS (
	SELECT 1
	FROM film_actor AS fa
	INNER JOIN film_category AS fc
		ON fa.film_id = fc.film_id
	INNER JOIN category AS c
		ON fc.category_id = c.category_id
	WHERE fa.actor_id = a.actor_id AND c.name = "Horror"
);
```

## Ejercicio 3

Listar `name` por cada categoría de película y la cantidad de películas de cada
una.

```sql
SELECT
	c.name,
	COUNT(fc.film_id) AS peliculas
FROM category AS c
LEFT JOIN film_category AS fc
	ON c.category_id = fc.category_id
GROUP BY c.category_id, c.name;
```

## Ejercicio 4

Listar `first_name` y `last_name` de los actores y en qué película trabajó cada
uno.

```sql
SELECT
	a.first_name,
	a.last_name,
	f.title
FROM actor AS a
LEFT JOIN film_actor AS fa
	ON a.actor_id = fa.actor_id
LEFT JOIN film AS f
	ON fa.film_id = f.film_id;
```

## Ejercicio 5

Listar `first_name` y `last_name` de cada cliente y, si el cliente rentó
películas, la cantidad de las mismas.

```sql
SELECT
	c.first_name,
	c.last_name,
	COUNT(r.rental_id) AS CANTIDAD
FROM customer AS c
LEFT JOIN rental AS r
	ON c.customer_id = r.customer_id
GROUP BY c.customer_id;
```

## Ejercicio 6

Listar `last_name` de los actores que participaron en 30 o más películas,
indicando la cantidad de películas con el nombre **CANTIDAD** ordenados de menor
a mayor.

```sql
SELECT
	a.last_name,
	COUNT(fa.film_id) AS CANTIDAD
FROM actor AS a
INNER JOIN film_actor AS fa
	ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id) >= 30
ORDER BY CANTIDAD ASC;
```

## Ejercicio 7

Listar `title` de cada película y la cantidad de clientes diferentes que la
alquilaron, ordenados por ese número de mayor a menor.

En caso de coincidir las cantidades, ordenar el `title` alfabéticamente.

```sql
SELECT
	f.title,
	COUNT(DISTINCT r.customer_id) AS cantidad_de_clientes
FROM film AS f
INNER JOIN inventory AS i
	ON f.film_id = i.film_id
INNER JOIN rental AS r
	ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY cantidad_de_clientes DESC, f.title ASC;
```

---
title: Cómo pasar de una consigna a una consulta SQL
---

# Cómo pasar de una consigna a una consulta SQL

Esta guía complementa `practica-1.md` y los archivos `ejercicio-1.sql` a
`ejercicio-7.sql`. No repite las resoluciones: explica el razonamiento para
llegar a ellas, de forma que se pueda aplicar a cualquier consigna nueva.

## 1. Leer el esquema antes que la consigna

Antes de escribir una sola línea de SQL:

1. Identificar las tablas involucradas y sus claves primarias/foráneas
   (el diagrama entidad-relación de cada ejercicio ya lo muestra).
2. Trazar el camino entre las tablas que hacen falta para la consulta.
   Si dos tablas no están directamente relacionadas, buscar la tabla
   intermedia que las conecta (por ejemplo, `productos` y `clientes` en el
   Ejercicio 1 se conectan a través de `lineas` y `pedidos`).
3. Anotar qué campo de cada tabla responde a qué parte de la consigna
   (¿"cliente" es un nombre en texto libre o una FK a una tabla `clientes`?
   Ver Ejercicio 3 vs. Ejercicio 5, donde el mismo enunciado cambia de
   modelo).

## 2. Separar la consigna en tres preguntas

Toda consigna de este tipo se puede descomponer en:

- **¿Qué se pide mostrar?** → columnas del `SELECT` (¿son campos crudos,
  o hay que calcular/agregar algo?).
- **¿Qué filas califican?** → condiciones del `WHERE` (o del `HAVING` si el
  filtro es sobre un valor agregado).
- **¿Hay que agrupar o comparar contra un agregado?** → `GROUP BY` +
  funciones de agregación, o una subconsulta escalar.

## 3. Diccionario de frases → patrón SQL

| Frase en la consigna | Patrón SQL | Ejemplo |
|---|---|---|
| "el total/promedio/cantidad de..." | `SUM`/`AVG`/`COUNT` + `GROUP BY` | Ej. 3.2, 3.9 |
| "...para cada X" | `GROUP BY` por la clave de X | Ej. 3.2, 3.4 |
| "que supere/sea mayor a un número fijo" | filtro sobre agregado → `HAVING` | Ej. 1.2 |
| "que no [verbo] ningún/nada" | `NOT EXISTS` (o `NOT IN` / `LEFT JOIN ... IS NULL`) | Ej. 1.3, 3.3, 3.12 |
| "algún/alguna" | `EXISTS` o `IN` | Ej. 4.3 |
| "todos los ..., aunque no tengan ..." | `LEFT JOIN` (nunca `INNER JOIN`) | Ej. 5.8, 5.9, 7.1 |
| "más de N" / "exactamente N" | `HAVING COUNT(...) > N` / `= N` | Ej. 2.4, 6.2, 7.2 |
| "el/los de mayor/menor valor" | `WHERE columna = (SELECT MAX/MIN(columna) FROM tabla)` | Ej. 3.5, 5.7, 7.4 |
| "en promedio más de N" | `HAVING AVG(...) > N` | Ej. 4.1 |
| "esta semana / el último mes / este año" | `CURRENT_DATE`, `INTERVAL`, `EXTRACT(YEAR FROM ...)` | Ej. 1.4, 5.1, 7.4 |
| "que contenga la letra X (sin importar mayúsculas)" | `UPPER(columna) LIKE '%X%'` | Ej. 5.4 |
| "que empiece con X" | `LIKE 'X%'` | Ej. 5.3 |

## 4. Elegir el tipo de JOIN según si se pueden perder filas

- `INNER JOIN`: cuando la fila solo tiene sentido si existe la relación
  (por ejemplo, un pedido siempre tiene un cliente).
- `LEFT JOIN`: en cuanto la consigna dice "aunque no tengan", "todos los...",
  o pide mostrar algo "si existe" sin descartar el resto (Ej. 2.2 —
  trabajador sin supervisor —, Ej. 5.8, Ej. 7.1).
- Cuando el `LEFT JOIN` lleva además una condición (por ejemplo "solo si la
  reserva es de hoy", Ej. 7.1), esa condición **va en el `ON`, no en el
  `WHERE`** — si se pone en el `WHERE`, el motor descarta las filas sin
  match y el `LEFT JOIN` se comporta como un `INNER JOIN` (ver Ej. 5.9 y
  7.1, donde esto se aplica a propósito).

## 5. "Ninguno"/"nunca": tres formas de expresarlo, y cuál usar

Cuando la consigna pide "los que nunca..." o "los que no...", hay tres
formas equivalentes:

1. `NOT EXISTS (subconsulta correlacionada)` — la más segura, no tiene
   problemas con `NULL`.
2. `NOT IN (subconsulta)` — más corta, pero **hay que filtrar los `NULL`**
   del lado derecho con `IS NOT NULL`, porque si un solo valor de la
   subconsulta es `NULL`, el `NOT IN` completo deja de matchear cualquier
   fila (ver Ej. 5.5.b).
3. `LEFT JOIN ... WHERE columna_derecha IS NULL` — útil cuando además se
   necesita algo de la tabla del lado "no existe" (no es el caso más común
   acá, pero es intercambiable con `NOT EXISTS`, ver Ej. 5.2).

El Ejercicio 5 pide explícitamente resolver algunas consignas "con y sin
`NOT EXISTS`" para practicar esta equivalencia.

## 6. Cuándo el filtro va en `WHERE` y cuándo en `HAVING`

- `WHERE` filtra **filas individuales** antes de agrupar (por ejemplo, una
  fecha, un tipo, una ciudad).
- `HAVING` filtra **grupos ya agregados** (un total, un promedio, un
  conteo). Si el filtro necesita `SUM`, `AVG`, `COUNT`, etc., no puede ir en
  `WHERE`.
- Cuidado con las columnas no agregadas que aparecen en el `HAVING` sin
  estar dentro de una función: en SQL ANSI, tienen que estar en el
  `GROUP BY` (ver Ej. 3.8, donde `art.stock` se agrega al `GROUP BY` solo
  para poder compararlo en el `HAVING`).

## 7. Autorreferencias (una tabla que se relaciona consigo misma)

Cuando una tabla tiene una FK que apunta a su propia clave primaria (por
ejemplo `trabajadores.supervisor → trabajadores.legajo` en el Ejercicio 2),
hay que hacer un `JOIN` de la tabla contra sí misma usando dos alias
distintos, uno para "el registro" y otro para "el registro referenciado".

## 8. Convenciones de estilo aplicadas en los `.sql`

Los archivos `ejercicio-*.sql` siguen estas reglas (compatibles con
`sqruff`/`sqlfluff` en dialecto `ansi`, ver `.sqruff` en este directorio, y
pensadas para que el LSP `sqls` pueda resolver columnas y tablas sin
ambigüedad):

- Palabras clave en mayúsculas (`SELECT`, `FROM`, `INNER JOIN`, `WHERE`...).
- Identificadores en minúsculas y `snake_case`, igual que en el esquema
  original.
- Alias de tabla siempre explícitos con `AS`, cortos y consistentes dentro
  de un mismo archivo (por ejemplo `cli` para `clientes`, `ped` para
  `pedidos`).
- `JOIN` siempre explícito (`INNER JOIN` / `LEFT JOIN`, nunca `JOIN` a
  secas ni comas en el `FROM`), con el `ON` en la línea siguiente,
  indentado.
- Una columna por línea en el `SELECT` cuando hay más de una, con coma al
  final de línea (trailing comma).
- Nunca `SELECT *`: incluso cuando la consigna pide "todos los datos", se
  listan las columnas explícitamente.
- Cada sentencia termina en `;`.
- Fechas y duraciones en formato ANSI: `DATE '1996-05-10'`,
  `CURRENT_DATE`, `INTERVAL 'n' DAY/MONTH`, `EXTRACT(YEAR FROM ...)`, en vez
  de funciones específicas de un motor (`GETDATE()`, `NOW()`, `DATEADD`,
  etc.).
- Los `CREATE TABLE` de cada archivo son autocontenidos y repiten el
  esquema de esa consigna puntual (aunque el nombre de una tabla se repita
  entre ejercicios, cada archivo se puede ejecutar de forma independiente).

## 9. Checklist rápido antes de dar por terminada una consulta

1. ¿Las tablas que uso son las mínimas necesarias para llegar del dato de
   filtro al dato de salida?
2. ¿El `JOIN` es `INNER` o `LEFT` a propósito, no por default?
3. ¿El filtro de agregado está en `HAVING` y el filtro de fila en `WHERE`?
4. ¿"Ninguno"/"nunca" está resuelto con `NOT EXISTS`/`NOT IN` con guarda de
   `NULL`, y no con una comparación que silenciosamente devuelva vacío?
5. ¿Las columnas del `SELECT` que no son agregadas están en el `GROUP BY`?
6. ¿Los alias son consistentes y explícitos en todo el archivo?

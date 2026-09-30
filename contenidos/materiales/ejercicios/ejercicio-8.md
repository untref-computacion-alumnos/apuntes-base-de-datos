---
title: Práctica de Dependencias Funcionales
---

# Ejercicio 8

Para cada uno de los ejercicios siguientes:

- **a)** Determinar los atributos necesarios para resolver lo planteado.
- **b)** Determinar las dependencias funcionales entre esos atributos.

> No se solicita hacer las tablas, por lo tanto **no hay ID** (no se agregan
> identificadores artificiales).

Ver el apunte [](../../apuntes/06-dependencias-funcionales.md) para la teoría.

## Consignas

**1.** Se quiere mantener una base de datos para un campeonato. Se realiza uno
por año, con varios grupos de equipos que juegan entre sí. Un equipo tiene un
conjunto de jugadores, un capitán y un director técnico. Cada campeonato
consiste en un conjunto de partidos de equipos del mismo grupo, cada uno en un
estadio y en una fecha determinada. Se registra quién ganó cada partido. Al
finalizar el campeonato se determinan los equipos 1.º, 2.º y 3.º dentro de cada
grupo de acuerdo a la cantidad de partidos ganados.

**2.** En una biblioteca hay dos tipos de usuarios: sin carnet (solo pueden
realizar consultas en la sala de lecturas) y con carnet (pueden retirar libros
en préstamo por una semana). El material bibliográfico está compuesto por libros
y revistas. Estas últimas solo se pueden consultar en la sala de lecturas. No
olvidar que de todo el material puede haber varios ejemplares. Se requiere
registrar los préstamos para saber quién tiene el libro, cuándo lo va a devolver
y si quedan o no ejemplares del libro solicitado.

**3.** Los pilotos participan en distintas escuderías según la temporada. Para
seleccionar los pilotos, las escuderías consultan sus datos personales y cuántas
veces ganaron, en qué temporada y en qué circuitos. Los pilotos pueden correr en
distintas categorías. Según estas categorías se arman las competencias por
temporada. Para cada competencia se elige un circuito.

**4.** En una facultad es necesario conocer quién es el consejero de cada
estudiante. Los consejeros deben ser profesores titulares de alguna materia. Los
estudiantes eligen a su consejero. Cada materia tiene un solo titular. Al
comienzo de cada semestre el estudiante puede cambiar de consejero e
inscribirse en varias materias. Por lo menos una de esas materias debe ser
dictada por el departamento en el que es titular su consejero. Por lo tanto, es
necesario que el estudiante pueda conocer el departamento que dicta cada
materia. Se registran teléfono, dirección y fecha de nacimiento tanto de
profesores como de alumnos.

**5.** Explicitar las dependencias funcionales consideradas para esta empresa.
Una empresa de alquiler de vehículos desea implementar una base de datos con la
información de su negocio. Se tienen vehículos identificados por su número de
matrícula, y de los que se conoce su marca, color, modelo y año. Un contrato de
alquiler de vehículo está identificado por un número de contrato y se realiza en
una fecha dada entre un cliente y un vehículo, registrándose el período de
alquiler en días y el precio del servicio. Se considera que en una misma fecha
no se puede alquilar más de una vez el mismo vehículo al mismo cliente.

## Resolución del ejercicio 5

Atributos: `matricula`, `marca`, `color`, `modelo`, `anio`, `nro_contrato`,
`fecha`, `cedula` (del cliente), `periodo`, `precio`.

Dependencias funcionales:

- `matricula` $\to$ `marca, color, modelo, anio`
- `nro_contrato` $\to$ `fecha, cedula, matricula, periodo, precio`
- `fecha, cedula, matricula` $\to$ `nro_contrato` (por la restricción de que en
  una misma fecha no se alquila más de una vez el mismo vehículo al mismo
  cliente)

Si además se registraran los datos del cliente, se agregaría
`cedula` $\to$ `nombre, direccion, telefono`.

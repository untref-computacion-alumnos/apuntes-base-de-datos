---
title: Trabajo Práctico de Normalización
---

# Ejercicio 9

Ver los apuntes [](../../apuntes/06-dependencias-funcionales.md) y
[](../../apuntes/07-descomposicion-y-formas-normales.md) para la teoría.

## Consignas

**1.** Siendo $R(A, B, C, D, E, F, G)$ y $F$ el siguiente conjunto de
dependencias funcionales:

$$
\begin{aligned}
AB &\to C & D &\to EG \\
BC &\to D & BE &\to C \\
C &\to A & CG &\to BD \\
ACD &\to B & CE &\to AG
\end{aligned}
$$

Listar las posibles claves candidatas de $R$.

**2.** **a)** Calcular $F^+$ (clausura de $F$) para $R(A_1, A_2, A_3, A_4, A_5,
A_6)$ siendo:

$$
F = \{A_4 \to A_6,\ A_3A_4 \to A_5,\ A_1 \to A_2,\ A_3 \to A_1\}
$$

**b)** Listar las posibles claves candidatas de $R$.

**3.** Una base de datos para una firma inversora consta de los siguientes
atributos: $B$ agente de bolsa; $O$ oficina; $I$ inversor; $S$ acción; $Q$
cantidad de un tipo de acción poseída por un inversor; $D$ dividendo pagado por
un tipo de acción. Con
$F = \{S \to D,\ IS \to Q,\ I \to B,\ B \to O\}$:

**a)** ¿Cuál es la clave de $R(BOISDQ)$? ¿Por qué?

**b)** Plantear otras dependencias derivadas de las expresadas.

**4.** Probar que $\{XY \to Z,\ X \to Y\} \Rightarrow X \to Z$:

**a)** Utilizando los axiomas de Armstrong.

**b)** Utilizando la definición de dependencia funcional.

**5.** Siendo $R(M, N, O, P, Q, R, S)$ y $F$ el siguiente conjunto de
dependencias funcionales:

$$
F = \{MN \to O,\ N \to QR,\ P \to RO,\ O \to S,\ M \to P,\ P \to N\}
$$

Hallar una descomposición en FNBC sin pérdida de información. Justificar cada
paso.

**6.** Dado $R = ABDCEF$ y el conjunto de dependencias funcionales
$\{A \to BC,\ B \to C,\ C \to AC,\ AD \to E,\ AE \to F\}$:

**a)** Determinar todas las claves de $R$. Justificar.

**b)** ¿Está en 2FN? ¿En 3FN? ¿En FNBC?

**c)** Hallar una descomposición en 3FN sin pérdida de información y que
preserve las dependencias funcionales.

**d)** Hallar una descomposición en FNBC sin pérdida de información y que
preserve las dependencias funcionales. ¿Es posible?

**e)** La descomposición de $R$ en $R_1(ABC)$ y $R_2(DEF)$, ¿es sin pérdida de
información? Justificar la respuesta.

**7.** En cada producto de una fábrica intervienen distintas partes en distintas
cantidades. Cada parte se puede comprar a varios proveedores. Se compra al de
mejor precio. En la orden de producción figuran: la fecha de la orden, un número
que la identifica, el producto, las partes que la componen y en qué cantidad, y
el proveedor y el precio de cada parte.

**a)** Diseñar una base de datos relacional en 3FN que permita confeccionar esa
orden y enviar por correo los pedidos a los proveedores para confeccionar cada
orden.

**b)** Explicitar las dependencias funcionales utilizadas.

**c)** Seleccionar claves primarias y justificar.

**8.** Siendo $R$ y $F$ las del ejercicio 3:

**a)** Encontrar una descomposición de $R$ en FNBC sin pérdida de información.
¿Se preservaron las dependencias funcionales?

**b)** Si $R_1(ISQD)$ y $R_2(IBO)$ es una descomposición de $R$: ¿en qué forma
normal se encuentra cada una? ¿Qué anomalías y redundancias subsisten y cuáles
se resolvieron? ¿La descomposición es sin pérdida de información? ¿Se preservan
las dependencias funcionales?

**c)** Ídem b) para $R_1(SD)$, $R_2(IB)$, $R_3(ISQ)$, $R_4(BO)$.

**9.** Sea $R(A, B, C, D, E, F)$ y
$F = \{A \to B,\ CD \to F,\ E \to AD,\ B \to C,\ D \to F\}$:

**a)** ¿La descomposición $R_1(A, B, D)$, $R_2(C, D, E)$, $R_3(B, F)$,
$R_4(A, C)$ es sin pérdida de información?

**b)** ¿Es sin pérdida de dependencias?

**c)** Descomponer $R$ sin pérdida de información ni de dependencias hasta
llevarla a 3FN. Justificar cada paso.

**10.** Dada la relación $R = \{A, B, C, D, E, F\}$ y el conjunto de dependencias
válidas en $R$:

$$
F = \{A \to B,\ A \to C,\ C \to D,\ E \to B,\ D \to F,\ EB \to A\}
$$

indicar cuál de las siguientes afirmaciones es cierta (o sea, la clausura de
esos conjuntos de dependencias contiene a $F$):

- **a)** $\{A \to B, A \to C, C \to D, E \to B, D \to F, EB \to A\}$ es un
  recubrimiento minimal.
- **b)** $\{A \to B, A \to C, C \to D, E \to B, D \to F, B \to A\}$ es un
  recubrimiento minimal.
- **c)** $\{A \to B, A \to C, C \to D, D \to F, E \to A\}$ es un recubrimiento
  minimal.
- **d)** $\{A \to B, C \to D, E \to B, D \to F, EB \to A\}$ es un recubrimiento
  minimal.

**11.** Dada la relación $R = (A, B, C, D)$ y
$F = \{A \to B,\ D \to C,\ B \to D\}$, determinar cuáles de las siguientes
afirmaciones son verdaderas (justificar):

- **a)** $R$ está en 2FN.
- **b)** $R$ está en 3FN.
- **c)** $R_1 = (A, B, D)$ está en FNBC (con las correspondientes dependencias
  funcionales de $R$).
- **d)** Ídem para $R_2 = (A, B, C)$.

**12.** Dada la siguiente relación $R$, responder verdadero o falso:

| I | S | Q |
| - | - | - |
| 1 | 1 | 1 |
| 4 | 2 | 1 |
| 3 | 3 | 3 |
| 2 | 1 | 1 |
| 1 | 4 | 1 |
| 1 | 6 | 5 |

- **a)** $R$ está en 2FN.
- **b)** $R$ está en 3FN.
- **c)** La clave es $IS$.
- **d)** $R$ está en FNBC.
- **e)** $I \leftrightarrow Q$ (es decir, $I \to Q$ y $Q \to I$).

---

## Preguntas de repaso de la unidad

Ver la sección "Preguntas de repaso" del apunte
[](../../apuntes/07-descomposicion-y-formas-normales.md).

---

## Ejercicios resueltos

### Ejemplo 1: normalización por dependencias parciales

Ver la sección "Ejemplo paso a paso" del apunte
[](../../apuntes/07-descomposicion-y-formas-normales.md) (con
$R = (A, B, C, D, E, F)$ y $F = \{AB \to C;\ AD \to F;\ AC \to E\}$) y el
algoritmo alternativo de síntesis a partir del recubrimiento minimal.

### Ejemplo 2: equivalencia de conjuntos de dependencias

Dados $DF_1 = \{A \to B, B \to A, A \to C, A \to D\}$ y
$DF_2 = \{A \to B, B \to A, B \to C, B \to D\}$, ver la sección "Equivalencia
de conjuntos de dependencias" del apunte
[](../../apuntes/06-dependencias-funcionales.md): resultan equivalentes.

### Ejemplo 3: recubrimiento minimal

Dado $E = \{B \to A, D \to A, AB \to D\}$, el recubrimiento minimal es
$\{D \to A, B \to D\}$ (ver la sección "Recubrimiento minimal" del apunte
[](../../apuntes/06-dependencias-funcionales.md)).

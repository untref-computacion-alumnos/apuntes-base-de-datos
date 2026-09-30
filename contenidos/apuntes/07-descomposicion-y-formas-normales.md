# Descomposición y formas normales

## 1. Propiedades deseables de una descomposición

Una **descomposición** de $R$ es un conjunto $\{R_1, R_2, \dots, R_n\}$ tal que
$R = \bigcup_i R_i$. Al partir una tabla se buscan dos propiedades:

- **No pérdida de información.**
- **Conservación de las dependencias funcionales.** Perder DF significa perder
  restricciones de integridad.

**Ejemplo.** Sea `proveedores(proveedor, nombre, insumo, precio)` con
$F = \{\text{proveedor, insumo} \to \text{precio},\
\text{proveedor} \to \text{nombre}\}$. Una forma de partirla sin perder
dependencias es:

```text
R1(proveedor, insumo, precio)
R2(proveedor, nombre)
```

Además, como la intersección `proveedor` es clave de $R_2$, no se pierde
información (teorema de la sección 2).

---

## 2. Descomposición sin pérdida de información

Una descomposición de $R$ es **sin pérdida de información** (con respecto a un
conjunto de dependencias $F$) si para toda $r$ de esquema $R$ que satisface $F$
resulta:

$$
r = \pi_{R_1}(r) \bowtie \pi_{R_2}(r) \bowtie \dots \bowtie \pi_{R_n}(r)
$$

donde las $r_i = \pi_{R_i}(r)$ son las proyecciones de $r$ sobre los atributos
de $R_i$. O sea: al volver a juntar las partes con un _join_ natural se
recupera exactamente la tabla original, sin tuplas de más ("tuplas falsas") ni
de menos.

### 2.1. Descomposición en dos tablas

**Teorema.** Sea $D = \{R_1, R_2\}$ una descomposición de $R$. Si
$R_1 \cap R_2$ contiene una clave de $R_1$ o de $R_2$, entonces la
descomposición es sin pérdida de información. Dicho de otro modo, se cumple
si $R_1 \cap R_2 \to R_1$ o $R_1 \cap R_2 \to R_2$.

**Ejemplo.** $T(\text{legajo, nombre, categoria, salario})$ con
$F = \{\text{legajo} \to \text{nombre},\ \text{legajo} \to \text{categoria},\
\text{categoria} \to \text{salario}\}$. La clave es `legajo` y hay una
dependencia transitiva (`legajo` $\to$ `salario`), por lo que no está en 3FN.

Se la descompone en:

```text
T1(legajo, nombre, categoria)      F1 = {legajo → nombre, legajo → categoria}
T2(categoria, salario)             F2 = {categoria → salario}
```

Como $T_1 \cap T_2 = \{\text{categoria}\}$ y `categoria` es clave de $T_2$, la
descomposición es sin pérdida de información. Tampoco pierde dependencias.

### 2.2. Descomposición en más de dos tablas: el método del _tableau_

Para decidir si una descomposición en **más de dos** tablas es buena se arma una
matriz con una fila por cada $R_i$ y una columna por cada atributo de $R$:

- Si el atributo $A_j$ pertenece a $R_i$, la celda es $a_j$.
- Si no, la celda es $b_{ij}$.

Luego se aplican las dependencias de $F$: si dos filas tienen los mismos
valores en el antecedente de una DF, se igualan sus valores del consecuente (si
alguno es una "$a$", el otro pasa a ser esa "$a$"). Si al terminar aparece una
fila con **todas "$a$"**, la descomposición es sin pérdida de información.

**Ejemplo 1.** $R = SAIP$, $R_1 = SA$, $R_2 = SIP$, $F = \{S \to A,\
SI \to A\}$.

|       | S     | A     | I        | P        |
| ----- | ----- | ----- | -------- | -------- |
| $SA$  | $a_1$ | $a_2$ | $b_{13}$ | $b_{14}$ |
| $SIP$ | $a_1$ | $b_{22}$ | $a_3$ | $a_4$    |

Como $S \to A$ y las dos filas coinciden en $S$, se iguala $b_{22} = a_2$. Queda
una fila de "$a$" (la de $SIP$), por lo tanto es una **buena descomposición**.

**Ejemplo 2.** $R = ABCDEF$, $R_1 = ABC$, $R_2 = CD$, $R_3 = DEF$,
$F = \{C \to A,\ C \to D,\ E \to F\}$.

|       | A        | B        | C        | D        | E        | F        |
| ----- | -------- | -------- | -------- | -------- | -------- | -------- |
| $ABC$ | $a_1$    | $a_2$    | $a_3$    | $b_{14}$ | $b_{15}$ | $b_{16}$ |
| $CD$  | $b_{21}$ | $b_{22}$ | $a_3$    | $a_4$    | $b_{25}$ | $b_{26}$ |
| $DEF$ | $b_{31}$ | $b_{32}$ | $b_{33}$ | $a_4$    | $a_5$    | $a_6$    |

En la columna de $C$ hay dos "$a$" (filas 1 y 2), así que se aplican las DF con
$C$ como antecedente: por $C \to D$ resulta $b_{14} = a_4$ y por $C \to A$
resulta $b_{21} = a_1$.

|       | A        | B        | C        | D     | E        | F        |
| ----- | -------- | -------- | -------- | ----- | -------- | -------- |
| $ABC$ | $a_1$    | $a_2$    | $a_3$    | $a_4$ | $b_{15}$ | $b_{16}$ |
| $CD$  | $a_1$    | $b_{22}$ | $a_3$    | $a_4$ | $b_{25}$ | $b_{26}$ |
| $DEF$ | $b_{31}$ | $b_{32}$ | $b_{33}$ | $a_4$ | $a_5$    | $a_6$    |

En la columna de $E$ no hay dos "$a$", por lo que $E \to F$ no se puede usar. El
proceso termina sin ninguna fila con todas "$a$": **no es una buena
descomposición**.

¿Y si se agrega la dependencia $D \to E$? Las tres filas tienen $a_4$ en $D$, así
que $b_{15} = b_{25} = a_5$, y a partir de ahí se puede usar $E \to F$, con lo
que $b_{16} = b_{26} = a_6$. La fila $ABC$ queda con todas
"$a$" ($a_1 \dots a_6$): la descomposición pasa a ser sin pérdida de
información.

---

## 3. Descomposición sin pérdida de dependencias

Sea $F$ un conjunto de DF de $R$ y $R_1, \dots, R_n$ una descomposición de $R$.

- La **restricción de $F$ a $R_i$** es el conjunto $F_i$ de todas las DF de
  $F^+$ que incluyen solo atributos de $R_i$.
- Sea $F' = F_1 \cup F_2 \cup \dots \cup F_n$. Si $(F')^+ = F^+$, la
  descomposición es **sin pérdida de dependencias** ($F'$ puede ser distinto de
  $F$).

**Ejemplo.** $R = ABCDEF$, $R_1 = ABC$, $R_2 = CD$, $R_3 = DEF$ y
$F = \{C \to A,\ C \to D,\ E \to F\}$. Las clausuras son $A^+ = A$, $B^+ = B$,
$C^+ = CAD$, $D^+ = D$, $E^+ = EF$ y $F^+ = F$. Resulta $F_1 = \{C \to A\}$,
$F_2 = \{C \to D\}$ y $F_3 = \{E \to F\}$: **no se perdieron dependencias**
(aunque, como se vio en la sección anterior, sí se perdió información).

¿Y si a $F$ se le agrega $B \to E$? No está en $F_1$, $F_2$ ni $F_3$ porque $B$ y
$E$ no están juntos en ninguna de las tres tablas. Como en $F_1 \cup F_2 \cup
F_3$ la clausura de $B$ es solo $B$, no se puede derivar: **se pierden
dependencias**.

---

## 4. Formas normales

### 4.1. Primera forma normal (1FN)

Una relación está en **1FN** si y solo si todos sus dominios simples
subyacentes contienen solo valores **atómicos** (indivisibles). No puede haber
atributos multivaluados ni grupos repetidos.

**Ejemplo.** La tabla de la izquierda no está en 1FN (columnas repetidas para
un valor multivaluado); la de la derecha sí:

| Articulo | Prov1  | Prov2  | Prov3 |
| -------- | ------ | ------ | ----- |
| Maíz     | -      | Granja | -     |
| Arroz    | Casita | -      | -     |

| Codigo | Proveedor |     | Articulo | Cod_prov |
| ------ | --------- | --- | -------- | -------- |
| 145    | Casita    |     | Maíz     | 154      |
| 154    | Granja    |     | Arroz    | 145      |

### 4.2. Segunda forma normal (2FN)

Una relación está en **2FN** si y solo si está en 1FN y todo atributo no clave
depende funcionalmente de **toda** la clave (no hay dependencias parciales).

### 4.3. Tercera forma normal (3FN)

Una relación está en **3FN** si y solo si está en 2FN y todo atributo no clave
depende **directamente** de la clave (no hay dependencias transitivas). Dicho
formalmente, para toda DF no trivial $X \to A$ se cumple al menos una de estas:

1. $X$ es una superclave, **o**
2. $A$ es un miembro de alguna clave candidata (es un atributo primo).

(Teorey, 1989.)

**Ejemplo.** $T(\text{legajo, nombre, categoria, salario})$ con
$F = \{\text{legajo} \to \text{nombre},\ \text{legajo} \to \text{categoria},\
\text{categoria} \to \text{salario}\}$ y clave `(legajo, categoria)`. Hay
dependencia parcial (`legajo` determina a `nombre` por sí solo) y también
transitiva: **no está en 2FN ni en 3FN**. Se descompone en:

```text
T1(legajo, nombre, categoria)
T2(categoria, salario)
```

con $T_1 \cap T_2 = \{\text{categoria}\} \to T_2$. La descomposición es sin
pérdida de información ni de dependencias, y $T_1$ y $T_2$ están en 3FN.

### 4.4. Forma normal de Boyce-Codd (FNBC / BCNF)

Una relación está en **FNBC** si, para toda DF no trivial $X \to A$, el atributo
$X$ es una **superclave**. Es una condición más fuerte que la 3FN: se elimina la
excepción "o $A$ es un miembro de una clave candidata".

**Ejemplo.** Retomando las reglas de negocio de vendedores y gerentes, una
buena descomposición es:

```text
R1(vend_id, vend_nbr, ger_id)
R2(ger_id, ger_nbr)
R3(prod_nbr, prod_desc)
R4(ger_id, prod_nbr, vend_id)      F4 = {ger_id, prod_nbr → vend_id, vend_id → ger_id}
```

$R_4$ está en **3FN**, a pesar de que `vend_id` no es clave y `vend_id` $\to$
`ger_id` vale en $R_4$, porque `ger_id` es miembro de una clave. Pero **no está
en FNBC**, ya que el antecedente de `vend_id` $\to$ `ger_id` no es superclave.

Y no se resuelven todas las anomalías. Si el vendedor 2 pasa del gerente 19 al
gerente 4 y conserva el producto 3, en $R_1$ la fila `(2, 'pepe', 19)` pasa a
`(2, 'pepe', 4)`, y en $R_4$ la fila `(19, 'Prod 3', 2)` pasa a
`(4, 'Prod 3', 2)`. Pero además es posible que se agregue, modifique o borre en
$R_4$ una fila como `(19, 'Prod 3', otro vendedor del gerente 19)` y
`(4, 'Prod 3', otro vendedor del gerente 4)`, quedando datos inconsistentes.

### 4.5. Cuarta forma normal (4FN)

Antes hace falta definir la **dependencia multivaluada** (DMV). Sea $R$ una
relación y $X$, $Y$ dos subconjuntos de atributos de $R$. Se dice que
$X \twoheadrightarrow Y$ ("$Y$ depende de forma multivaluada de $X$") si, dados
los valores de $X$, hay un conjunto de valores de $Y$ asociado, y ese conjunto
es **independiente** de los demás atributos $Z = R - X - Y$.

Formalmente, $X \twoheadrightarrow Y$ vale si para cada par de tuplas $t_1$ y
$t_2$ de $R$ que coinciden en $X$ existe una tupla $t_3$ tal que:

- Coincide con $t_1$ y $t_2$ en $X$.
- Coincide con $t_1$ en $Y$.
- Coincide con $t_2$ en todos los atributos de $R$ que no pertenecen ni a $X$
  ni a $Y$.

**Ejemplo.** Un alumno cursa varias asignaturas y practica varios deportes, dos
cosas independientes entre sí:

| DNI        | Asignatura | Deporte  |
| ---------- | ---------- | -------- |
| 12.324.334 | PR1        | natación |
| 12.324.334 | PR1        | fútbol   |
| 12.324.334 | CA10       | natación |
| 12.324.334 | CA10       | fútbol   |
| 12.324.334 | FS11       | natación |
| 12.324.334 | FS11       | fútbol   |

Vale `DNI` $\twoheadrightarrow$ `Deporte` (y, por lo tanto, también
`DNI` $\twoheadrightarrow$ `Asignatura`).

Propiedades:

- Dada $R(A, B, C)$, $A \twoheadrightarrow B$ vale si y solo si también vale
  $A \twoheadrightarrow C$. Por eso se representan juntas:
  $A \twoheadrightarrow B \mid C$.
- Una DMV $A \twoheadrightarrow B$ es **trivial** cuando $B \subseteq A$ (o
  cuando $A \cup B = R$).

Una relación está en **4FN** si y solo si está en 3FN (o en FNBC, cualquiera de
las dos) y **no posee dependencias multivaluadas no triviales**.

**Ejemplo.**

1. Cada curso puede tener varios profesores.
2. Cada curso utiliza varios textos.
3. El texto utilizado para un curso es independiente del profesor.

`CURSOS(nom_curso, profesor, libro)` se descompone en:

```text
CURSOS(nom_curso, profesor)
BIBLIOGRAFIA(nom_curso, libro)
```

### 4.6. Quinta forma normal (5FN)

**Teorema de Fagin.** $R(A, B, C)$ satisface la dependencia de reunión
$*((A, B), (A, C))$ si y solo si $A \twoheadrightarrow B \mid C$. Es decir, las
DMV son un caso particular de descomposición sin pérdida en dos partes.

**Dependencia de reunión (DR).** Se dice que $R$ satisface la DR
$*(R_1, R_2, \dots, R_n)$ si y solo si $R$ es igual a la reunión de sus
proyecciones $R_1, R_2, \dots, R_n$, donde cada $R_i$ es un subconjunto de
atributos de $R$. O sea, si es descomponible sin pérdida de información.

Una relación está en **5FN** si y solo si toda dependencia de reunión en $R$ es
una consecuencia de las claves candidatas.

**Ejemplo 1.** `proveedores(id_proveedor, ciudad, pais, codigo_postal, ...)`.
No hay dependencias `ciudad, pais` $\to$ `codigo_postal` (puede haber varios
códigos postales en la misma ciudad), ni `codigo_postal` $\to$ `ciudad, pais`
(el código postal puede repetirse en países distintos y además puede ser
nulo). Para descomponer sin perder información hay que incluir en cada tabla el
`id_proveedor`, porque es la única clave. Cada tabla resultante contiene la
clave primaria y la relación está en 5FN.

**Ejemplo 2.** Sea `SPJ(S, P, J)`: la tupla $(S_i, P_i, J_i)$ significa que el
proveedor $S_i$ suministra la pieza $P_i$ al proyecto $J_i$. Si un proveedor
suministra una pieza a un proyecto, se compromete a suministrarle todas las
piezas que posea y que ese proyecto utilice. Se cumple la restricción: si
existen las tuplas $(S_1, P_1, J_x)$, $(S_x, P_1, J_1)$ y $(S_1, P_x, J_1)$,
entonces debe aparecer la tupla $(S_1, P_1, J_1)$ en `SPJ`. Es decir, si:

- el proveedor $S_1$ suministra la pieza $P_1$,
- la pieza $P_1$ se usa en el proyecto $J_1$, y
- $S_1$ suministra otra pieza a $J_1$,

entonces $S_1$ está obligado a suministrar $P_1$ a $J_1$.

Esta restricción genera una situación de redundancia: si $S_1$ y $S_2$
suministran $P_3$, y $J_1$ lo usa y se lo pide a $S_1$ (se agrega
$(S_1, P_3, J_1)$), entonces se debe agregar también $(S_2, P_3, J_1)$.

`SPJ` **no está en 5FN**: ninguna de sus tres proyecciones `SP(S, P)`,
`PJ(P, J)` y `SJ(S, J)` contiene la clave primaria (que es la combinación de
los tres atributos), y el _join_ de las tres proyecciones genera la relación
original. Después de descomponer, cada una de las tres tablas queda en 5FN.

### 4.7. Resumen

| Forma normal | Condición                                                          |
| ------------ | ------------------------------------------------------------------ |
| 1FN          | Todos los valores son atómicos.                                    |
| 2FN          | 1FN y sin dependencias parciales de la clave.                      |
| 3FN          | 2FN y sin dependencias transitivas ($X$ superclave o $A$ primo).   |
| FNBC         | Todo determinante ($X$ de una DF no trivial) es superclave.        |
| 4FN          | 3FN/FNBC y sin dependencias multivaluadas no triviales.            |
| 5FN          | Toda dependencia de reunión es consecuencia de las claves.         |

Cada forma normal más alta implica las anteriores: 5FN $\Rightarrow$ 4FN
$\Rightarrow$ FNBC $\Rightarrow$ 3FN $\Rightarrow$ 2FN $\Rightarrow$ 1FN.

---

## 5. Algoritmos de descomposición

### 5.1. Descomposición por dependencias parciales y transitivas

Se parte la tabla a partir de las dependencias que violan la forma normal
deseada, verificando en cada paso que la partición sea sin pérdida de
información (la intersección contiene una clave de alguna de las partes) y, si
es posible, sin pérdida de dependencias.

**Ejemplo.** Sea $F = \{\text{empid, fecha\_inicio} \to \text{proynro,
fecha\_fin};\ \text{empid} \to \text{empnombre, tenro, oficnro, proynro,
deptnro};\ \text{tenro} \to \text{oficnro};\ \text{proynro} \to
\text{proynombre, fecha\_inicio, fecha\_fin};\ \text{deptnro} \to
\text{deptnombre, mgrid};\ \text{mgrid} \to \text{deptnro}\}$.

- **Tabla 1:** `(empid, fecha_inicio, ...)` tiene una clave compuesta que hay
  que separar según las DF que involucran a un componente individual de la
  clave en su lado izquierdo (dependencia parcial). Se empieza por otra tabla
  con un solo atributo como antecedente.
- **Tabla 2:** dadas `empid` $\to$ `empnombre, tenro, oficnro, proynro, deptnro`
  y `tenro` $\to$ `oficnro`, hay que eliminar los lados derechos redundantes que
  provocan la dependencia transitiva (`oficnro`) y ponerlos en otra tabla:
  - Tabla 2a: `(empid, empnombre, tenro, proynro, deptnro)`
  - Tabla 2b: `(tenro, oficnro)`
- **Tabla 3:** `(proynro, proynombre, fecha_inicio, fecha_fin)`
- **Tabla 4:** `(deptnro, deptnombre, mgrid)` (también vale
  `mgrid` $\to$ `deptnro`).

### 5.2. Ejemplo paso a paso

Sea $R = (A, B, C, D, E, F)$ y $F = \{AB \to C;\ AD \to F;\ AC \to E\}$. La
clave es $ABD$ (ningún otro atributo está en un consecuente: ni $A$, $B$ ni $D$
son determinados por nada, y $ABD^+ = ABCDEF$).

1. Se empieza con $AC \to E$, una de las dependencias parciales válidas en $R$.
   Se parte $R$ en $R_1(A, C, E)$ y $R_2(A, B, C, D, F)$, para que
   $R_1 \cap R_2 = AC \to R_1$ y no se pierda información. Como
   $F_1 = \{AC \to E\}$ y $F_2 = \{AB \to C;\ AD \to F\}$, no se perdieron
   dependencias.
2. En $R_1$ la clave es $AC$ y está en 5FN. $R_2$ **no** está en 3FN porque su
   clave es $ABD$ y hay dependencias parciales. Se sigue partiendo.
3. Para $R_2$ se empieza con $AB \to C$: $R_{21}(A, B, C)$ y
   $R_{22}(A, B, D, F)$, para que $R_{21} \cap R_{22} = AB \to R_{21}$.
   Quedan $F_{21} = \{AB \to C\}$ y $F_{22} = \{AD \to F\}$: no se perdieron
   dependencias.
4. En $R_{21}$ la clave es $AB$ y la única dependencia es $AB \to C$, así que
   está en 5FN. $R_{22}$ **no** está en 3FN porque la única dependencia es
   $AD \to F$ y es parcial (la clave es $ABD$). Se sigue partiendo.
5. $R_{221}(A, D, F)$ y $R_{222}(A, B, D)$, con claves $AD$ y $ABD$
   respectivamente. $R_{221} \cap R_{222} = AD \to R_{221}$. Como
   $F_{221} = \{AD \to F\}$, $AD$ es clave y $R_{221}$ está en 5FN. $F_{222}$
   solo tiene dependencias triviales, $ABD$ es clave y también está en 5FN.

**Resultado:**

```text
R1   = (A, C, E)     F1   = {AC → E}
R21  = (A, B, C)     F21  = {AB → C}
R221 = (A, D, F)     F221 = {AD → F}
R222 = (A, B, D)     F222 = {triviales}
```

> El orden importa. Si se empieza con $AB \to C$, quedan $(A, B, C)$ y
> $(A, B, D, E, F)$ y se **pierde** $AC \to E$; por eso se prueba empezar con
> otra. Si se empieza con $AD \to F$, quedan $(A, D, F)$ y $(A, B, C, D, E)$; se
> parte esta última en $(A, C, E)$ y $(A, B, C, D)$, y después esta en
> $(A, B, C)$ y $(A, B, D)$. Otra descomposición posible, que en este caso
> resulta igual (no siempre es así).

### 5.3. Síntesis a partir de un recubrimiento minimal

Otro algoritmo, que garantiza 3FN sin pérdida de información ni de
dependencias:

1. Hallar un **recubrimiento minimal** de las dependencias funcionales (ver el
   apunte anterior). Todas las dependencias son elementales: plenas (no
   parciales), no triviales y con un único atributo implicado; no existen
   atributos extraños ($A$ es extraño en $X \to Y$ si $(X - A) \to Y$ también
   vale); y no existe ninguna dependencia redundante.
2. **Agrupar** las DF que tengan el mismo implicante (antecedente) y/o uno
   equivalente.
3. **Crear un esquema $R_i$** para cada partición, con todos los atributos que
   participan en las dependencias del grupo, y como dependencias las del grupo.
4. Si existen atributos que no son implicantes ni implicados, o si la clave de
   la relación original no quedó en ninguna tabla, crear un esquema adicional
   con estos atributos, o con la clave de la relación, sin dependencias
   (solo triviales).

**Ejemplo.** $R = (A, B, C, D, E, F)$ y $F = \{AB \to C;\ AD \to F;\ AC \to E\}$,
que ya es minimal, con clave $ABD$. Con cada dependencia se arma una tabla:

```text
R1 = (A, C, E)     F1 = {AC → E}
R2 = (A, B, C)     F2 = {AB → C}
R3 = (A, D, F)     F3 = {AD → F}
```

Y como la clave original no quedó en ninguna, se agrega $R_4 = (A, B, D)$, que
tiene solo dependencias triviales.

Probar que no se pierde información **no es necesario** en este algoritmo (está
garantizado), pero se puede verificar con el _tableau_:

|       | A     | B        | C        | D        | E        | F        |
| ----- | ----- | -------- | -------- | -------- | -------- | -------- |
| $ABC$ | $a_1$ | $a_2$    | $a_3$    | $b_{14}$ | $b_{15}$ | $b_{16}$ |
| $ADF$ | $a_1$ | $b_{22}$ | $b_{23}$ | $a_4$    | $b_{25}$ | $a_6$    |
| $ACE$ | $a_1$ | $b_{32}$ | $a_3$    | $b_{34}$ | $a_5$    | $b_{36}$ |
| $ABD$ | $a_1$ | $a_2$    | $b_{43}$ | $a_4$    | $b_{45}$ | $b_{46}$ |

- $AC \to E$: filas 1 y 3 coinciden en $A, C$, entonces $b_{15} = a_5$.
- $AD \to F$: filas 2 y 4 coinciden en $A, D$, entonces $b_{46} = a_6$.
- $AB \to C$: filas 1 y 4 coinciden en $A, B$, entonces $b_{43} = a_3$.
- $AC \to E$ otra vez: ahora las filas 1 y 4 coinciden en $A, C$, entonces
  $b_{45} = a_5$.

La fila de $ABD$ queda con todas "$a$": es una buena descomposición.

### 5.4. Descomposición en FNBC

Se aplica lo mismo que en la sección 5.2, partiendo por las dependencias
$X \to A$ tales que $X$ **no** es superclave, con la intersección
$R_1 \cap R_2 = X$ y $R_1 = X^+$ (o $XA$). Siempre se puede llegar a FNBC sin
perder información, pero **no siempre** es posible conservar todas las
dependencias (ver el ejemplo de $R_4$ en la sección 4.4). En cambio, siempre es
posible llegar a 3FN sin perder ni información ni dependencias (algoritmo de la
sección 5.3).

---

## 6. Proceso de diseño de una base de datos

La normalización forma parte del **diseño lógico** de una base de datos. El
proceso completo es:

1. **Dominio de la aplicación (universo de discurso).**
2. **Modelado de datos:** se obtiene el **modelo conceptual** (con el modelo
   entidad-relación o UML).
3. **Diseño lógico:** se obtiene el **modelo lógico**, usando el modelo de datos
   del SGBD elegido (por ejemplo el relacional). Es en esta etapa donde se
   normaliza.
4. **Diseño físico:** se obtiene el **modelo físico**, específico del SGBD y
   orientado a la optimización de los recursos (índices, almacenamiento).

---

## 7. Preguntas de repaso

1. Explicar la diferencia entre clave primaria, clave candidata y superclave.
2. ¿Cómo se implementan en el modelo relacional algunas restricciones de
   integridad?
3. Enunciar el teorema o propiedad que fundamenta el método de normalización de
   dividir en dos las tablas.
4. Demostrar usando los axiomas de Armstrong que
   $X \to Y;\ WY \to Z \Rightarrow WX \to Z$.
5. Explicar el significado de "descomposición sin pérdida de información".
6. Explicar el significado de "descomposición sin pérdida de dependencias".
7. Dada una tabla, especificar una dependencia que se verifique, una que no, y
   decidir si $A \to B$ vale en $R(A, B, C)$.
8. ¿Cuál es el objetivo de normalizar una base de datos?
9. Definir dependencia funcional, dar un ejemplo y enunciar los axiomas de
   Armstrong.
10. Definir 3FN y dar un ejemplo ($R$, $F$ y $r$) donde $r$ es una instancia de
    $R$ que verifica $F$ y está en 2FN pero no en 3FN.
11. Analizar si $F = \{A \to C, AC \to D, E \to AD, E \to H\}$ y
    $G = \{A \to CD, E \to AH\}$ son equivalentes. Justificar.
12. Sea $R(A, B, C, D)$ y $F = \{A \to C, B \to D, A \to D\}$: dar una
    descomposición que pierda información; una que no pierda información pero
    que pierda dependencias; y un ejemplo $(R_2, F_2)$ en 3FN pero no en FNBC.

# Dependencias funcionales

## 1. Introducción: por qué normalizar

Un esquema mal diseñado, con demasiados atributos en una misma tabla, produce
redundancia y problemas al modificar los datos. Como ejemplo clásico (Korth y
Silberschatz), sea el esquema:

```text
prestar(nombre_sucursal, activo, ciudad_sucursal, numero_prestamo, nombre_cliente, cantidad)
```

Los problemas que aparecen son:

1. **Anomalía de actualización:** si se agrega un préstamo hay que asegurarse de
   que los datos de la sucursal (`activo` y `ciudad_sucursal`) sean los mismos
   que ya están cargados en las otras filas de esa sucursal.
2. **Anomalías de inserción y borrado:** una sucursal que todavía no tiene
   préstamos no se puede dar de alta y, si se borran todos sus préstamos,
   desaparece la sucursal.
3. **Pérdida de información al partir mal la tabla:** si se la parte en
   `(nombre_sucursal, activo, ciudad_sucursal, numero_prestamo, cantidad)` y
   `(nombre_cliente, cantidad)`, y hay varios préstamos con la misma
   `cantidad`, al volver a juntarlas aparecen **tuplas falsas**.

La causa principal es que **en la misma tabla hay más de una entidad**. Hay que
"partir" la tabla, pero no de cualquier manera. Los objetivos de normalizar son:

- Eliminar la redundancia innecesaria.
- Preservar la integridad de los datos.
- Evitar la pérdida de información.
- Evitar las anomalías de inserción, borrado y actualización.

Para partir bien las tablas existen herramientas matemáticas: las
**dependencias funcionales** y las **formas normales**.

> Toda relación debe establecerse con una clave primaria.

---

## 2. Definición de dependencia funcional

Sea $R(A_1, A_2, \dots, A_n)$ un esquema de relación y sean $X$ e $Y$
conjuntos de atributos de $R$. Se dice que $X$ **determina funcionalmente** a
$Y$ (o que $Y$ **depende funcionalmente** de $X$), y se escribe:

$$
X \to Y
$$

si y solo si, para toda tabla (ocurrencia) $r$ de esquema $R$, se cumple que
para todo par de tuplas $t, t'$ de $r$:

$$
t[X] = t'[X] \Rightarrow t[Y] = t'[Y]
$$

Es decir, si dos filas coinciden en los valores de $X$, tienen que coincidir
también en los valores de $Y$.

### 2.1. Propiedades

- Una dependencia funcional es una propiedad de la **semántica** (el
  significado) de los atributos: **es del mundo real**.
- Las dependencias funcionales deben mantenerse en **todas** las instancias de
  cualquier relación $r$ de $R$ donde esos atributos estén juntos.
- Una DF es una propiedad del **esquema**, no de una instancia en particular.
  Que en una tabla concreta parezca valer una dependencia no alcanza para
  afirmar que es una DF; en cambio, un solo contraejemplo alcanza para
  descartarla.

### 2.2. Ejemplos

**Ejemplo 1.** En la tabla `alumno`, `legajo` $\to$ `apellido`. Significa que si
existe el legajo `1000` con el apellido `Wainer`, no puede haber otra fila con
legajo `1000` y otro apellido. En realidad el `legajo` se "inventa" para poder
relacionar a cada alumno con sus materias y notas dentro de la base de datos.

> Esto no asegura que no haya duplicados, por lo que conviene definir además una
> clave `UNIQUE` con apellido, nombre, fecha de nacimiento, etc.

**Ejemplo 2.** En ninguna tabla real vale `apellido` $\to$ `nombre`, porque
puede haber hermanos.

**Ejemplo 3.** Dada la tabla:

| ID          | Nombre   | Grado      |
| ----------- | -------- | ---------- |
| 111-11-1111 | Miguel F | MIS        |
| 222-22-2222 | Samuel S | FIN        |
| 333-33-3333 | Hernan H | Estudiante |
| 777-77-7777 | Miguel F | FIN        |
| 555-55-5555 | Samuel S | MIS        |
| 888-88-8888 | Tomás T  | MKTG       |

- `ID` $\to$ `Nombre` y `ID` $\to$ `Grado` (puede ser necesario hacer un
  relevamiento para confirmarlo).
- `Nombre` $\not\to$ `ID` y `Nombre` $\not\to$ `Grado` (ver a `Miguel F`).
- `Grado` $\not\to$ `ID` y `Grado` $\not\to$ `Nombre` (ver `FIN` o `MIS`).

**Ejemplo 4.** En una relación `R(A, B, C)` con las filas
`(a1, b1, c1)`, `(a2, b1, c1)`, `(a1, b1, c2)` y `(a2, b1, c3)`:

- Se verifica `A` $\to$ `B` (todas las filas tienen `b1`).
- No se verifica `A` $\to$ `C`: `a1` aparece con `c1` y con `c2`.
- Tampoco vale `B` $\to$ `C`: `b1` aparece con `c1`, `c2` y `c3`.

### 2.3. Relación con las claves

- Las claves determinan funcionalmente a todos los otros atributos de la tabla.
- Cuando las dependencias funcionales de una tabla **no** son de la forma
  _clave_ $\to$ _otros atributos_, hay que revisar si no se están poniendo
  demasiados atributos en esa tabla.
- A veces la dependencia es de muchos atributos a uno (por ejemplo,
  `marca, bar, dia` $\to$ `precio`).
- Si un atributo no está determinado por ningún otro, tiene que formar parte de
  la clave.
- Las DF que no son de las claves surgen de restricciones del mundo real. Por
  ejemplo, "no puede haber dos cursos en la misma aula al mismo tiempo" se
  escribe `aula, dia, hora` $\to$ `curso`.

### 2.4. De las reglas de negocio a las dependencias

Dado un enunciado, cada regla de negocio se traduce en una DF:

| Regla de negocio                                    | Dependencia funcional                      |
| --------------------------------------------------- | ------------------------------------------ |
| Todo vendedor tiene uno y solo un nombre.           | `vend_id` $\to$ `vend_nombre`              |
| Todo gerente tiene uno y solo un nombre.            | `ger_id` $\to$ `ger_nombre`                |
| Todo producto tiene una y solo una descripción.     | `prod_nbr` $\to$ `prod_desc`               |
| Todo gerente asigna cada producto a un solo vendedor. | `ger_id, prod_nbr` $\to$ `vend_id`       |
| Cada vendedor trabaja para uno y solo un gerente.   | `vend_id` $\to$ `ger_id`                   |

Otro ejemplo, el de una empresa de alquiler de vehículos:

- `matricula` $\to$ `marca, color, modelo, anio`
- `cedula` $\to$ `nombre, direccion, telefono`
- `nro_contrato` $\to$ `fecha, cedula, matricula, periodo, precio`
- `fecha, cedula, matricula` $\to$ `nro_contrato`

### 2.5. Ejemplo integrador: la orden de producción

_En cada producto de una fábrica intervienen distintas partes en distintas
cantidades. Cada parte se puede comprar a varios proveedores y se compra al de
mejor precio. En la orden de producción figuran: la fecha, un número que la
identifica, el producto, las partes que la componen y en qué cantidad, y el
proveedor y el precio de cada parte._

Dependencias funcionales consideradas:

- Un producto tiene partes en cierta cantidad: `producto, parte` $\to$
  `cantidad`.
- Una parte tiene un precio según el proveedor: `parte, proveedor` $\to$
  `precio`.
- Un proveedor tiene una dirección de correo: `proveedor` $\to$ `direccion`.
- Una orden tiene número, fecha y producto: `numero` $\to$ `fecha, producto`.

Y las tablas en 3FN que resultan:

```text
COMP(producto, parte, cantidad)
LISTA(parte, proveedor, precio)
PROVEEDOR(proveedor, direccion)
ORDEN(numero, fecha, producto)
```

Con estas tablas se puede confeccionar la orden y enviarla por correo, y la
consistencia de los datos la controla el SGBD definiendo:

- `PRIMARY KEY` en `ORDEN(numero)` y `PROVEEDOR(proveedor)`.
- `FOREIGN KEY` de `ORDEN(producto)` hacia `COMP(producto)` y de
  `LISTA(proveedor)` hacia `PROVEEDOR(proveedor)`.
- `PRIMARY KEY` (o índice `UNIQUE`) en `LISTA(parte, proveedor)` y
  `COMP(producto, parte)`.

Para generar la orden, el proceso busca cómo está compuesto el producto (parte
y cantidad), mira qué proveedor tiene el menor precio y le envía la orden a ese
proveedor, a su dirección.

Si se agrega una tabla de seguimiento (con un `estado`: recibida, pendiente,
anulada, etc.) para poder reimprimir o regenerar la orden aunque cambien los
precios o se mude el proveedor:

```text
(numero, fecha, producto, parte, cantidad, proveedor, precio, estado)
```

solo `estado` es modificable; los demás campos se cargan en el alta de la orden
y no se cambian más. Esa tabla **no está normalizada**, pero la redundancia es
intencional y controlada.

---

## 3. Superclaves y claves

Sea $X$ un conjunto de atributos de $R$.

- $X$ es **superclave** de $R$ si y solo si, para todo conjunto $Y$ de
  atributos de $R$, se cumple $X \to Y$.
- $X$ es **clave** (o **clave candidata**) si es una superclave **minimal**: no
  existe un $Z \subsetneq X$ que también sea superclave.
- La **clave primaria** es la clave candidata que se elige entre todas las
  candidatas.

En resumen: toda clave es superclave, pero no toda superclave es clave.

---

## 4. Implicación lógica y clausura de un conjunto de dependencias

Sea $F$ un conjunto de dependencias funcionales de $R$. Se dice que $F$
**implica lógicamente** a $X \to Y$ si para toda $r$ de esquema $R$ que
satisface las dependencias de $F$, también es verdadera $X \to Y$ en $r$.

- $F^+$ (**clausura de $F$**) es el conjunto de todas las dependencias
  funcionales que se deducen de $F$.
- $F$ es **completo** si $F^+ = F$.
- $F$ y $G$ son **equivalentes** si $F^+ = G^+$.

---

## 5. Axiomas de Armstrong

Sean $X$, $Y$, $Z$ conjuntos de atributos de $R$:

1. **Reflexividad (trivial):** si $Y \subseteq X$, entonces $X \to Y$,
   independientemente de $F$.
2. **Aumentatividad:** si $X \to Y \in F$, entonces $XZ \to YZ \in F^+$ para
   todo $Z$ (se puede usar una versión más general con $W \subseteq Z$: si
   $X \to Y$, entonces $XZ \to YW$).
3. **Transitividad:** si $X \to Y$ e $Y \to Z$ pertenecen a $F$, entonces
   $X \to Z \in F^+$.

### 5.1. Consistencia y completitud

- **Lema 1 (consistencia):** si $X \to Y$ se deduce de $F$ por los axiomas de
  Armstrong, entonces $X \to Y$ es verdadera en toda $r$ de esquema $R$ donde
  las dependencias de $F$ son verdaderas, o sea $X \to Y \in F^+$.
- **Completitud:** si $X \to Y \in F^+$, entonces $X \to Y$ se puede inferir de
  $F$ por los axiomas de Armstrong.

Ambas propiedades forman el **teorema**: los axiomas de Armstrong son
**consistentes y completos**. Por lo tanto, $F^+$ es el conjunto de
dependencias que se pueden demostrar a partir de $F$ con estos axiomas.

### 5.2. Reglas derivadas

A partir de los axiomas se demuestran las siguientes reglas:

- **Unión:** si $X \to Y$ y $X \to Z$, entonces $X \to YZ$.
- **Pseudotransitividad:** si $X \to Y$ y $WY \to Z$, entonces $XW \to Z$.
- **Descomposición:** si $X \to Y$ y $Z \subseteq Y$, entonces $X \to Z$.

**Demostración de la pseudotransitividad** (`X → Y; WY → Z ⟹ WX → Z`):

1. $X \to Y$ (dato).
2. $WX \to WY$ (aumentatividad de 1 con $W$).
3. $WY \to Z$ (dato).
4. $WX \to Z$ (transitividad de 2 y 3).

**Demostración de la unión** (`X → Y; X → Z ⟹ X → YZ`):

1. $X \to Y$ (dato) y, aumentando con $X$, $X \to XY$.
2. $X \to Z$ (dato) y, aumentando con $Y$, $XY \to YZ$.
3. $X \to YZ$ (transitividad de 1 y 2).

---

## 6. Clausura de un conjunto de atributos

La **clausura de $X$ respecto de $F$**, notada $X^+$, es el conjunto de todos
los atributos $A$ tales que $X \to A$ se puede deducir de $F$ con los axiomas de
Armstrong.

- **Lema 3:** $X \to Y$ se deduce de $F$ por los axiomas de Armstrong si y solo
  si $Y \subseteq X^+$.
- Por lo tanto, $X$ es **superclave** si y solo si $X^+ = R$.

### 6.1. Algoritmo para calcular $X^+$ (Ullman)

- **Entrada:** $R$, $F$.
- **Salida:** $X^+$.
- **Método:** construir una sucesión de conjuntos $X_0, X_1, \dots$

1. $X_0 = X$.
2. $X_{i+1} = X_i \cup \{A \mid \text{existe } Y \to Z \in F \text{ con } A \in Z
   \text{ e } Y \subseteq X_i\}$.
3. Repetir hasta que $X_{i+1} = X_i$.

Como $R$ es finito, el algoritmo termina, y ese último conjunto es $X^+$.

### 6.2. Ejemplo

Calcular $(AG)^+$ en $R(A, B, C, G, H, I)$ con respecto a
$F = \{A \to B, A \to C, CG \to H, CG \to I, B \to H\}$:

1. $AG$
2. $AGB$ porque $A \to B$.
3. $AGBC$ porque $A \to C$.
4. $AGBCH$ porque $CG \to H$.
5. $AGBCHI$ porque $CG \to I$.

La clausura de $AG$ es todo $R$, por lo tanto es **superclave**. Es además
**minimal**, ya que $A^+ = ABCH$ y $G^+ = G$, por lo tanto es **clave**.

No hay más claves: `A` y `G` no aparecen en ningún consecuente, así que ningún
otro atributo puede determinarlos y **toda clave debe contenerlos**. Como $AG$
ya es clave, es la única.

---

## 7. Recubrimiento minimal

Un conjunto $F$ de dependencias funcionales es **minimal** (o **recubrimiento
minimal**) si y solo si:

1. Toda dependencia tiene un **único atributo** en el consecuente
   ($X \to A$).
2. No existe $X \to A \in F$ tal que $F - \{X \to A\}$ sea equivalente a $F$
   (**no hay dependencias redundantes**).
3. No existe $X \to A \in F$ y $Z \subsetneq X$ tal que
   $(F - \{X \to A\}) \cup \{Z \to A\}$ sea equivalente a $F$ (**no hay
   atributos extraños** en el antecedente).

- **Lema 4:** para todo $F$ existe un $G$ equivalente tal que todas las
  dependencias de $G$ tienen un solo atributo en el consecuente.
- **Teorema:** todo conjunto de dependencias funcionales $F$ es equivalente a un
  conjunto $F'$ minimal.

### 7.1. Cómo obtener un recubrimiento minimal

En palabras: (1) descomponer los consecuentes para que cada dependencia tenga un
solo atributo a la derecha, (2) eliminar los atributos extraños de los
antecedentes y (3) eliminar las dependencias redundantes.

En forma de algoritmo, para hallar un recubrimiento minimal $F$ de $E$:

1. Establecer $F := E$.
2. **Reemplazar** cada DF $X \to \{A_1, A_2, \dots, A_n\}$ de $F$ por las $n$
   dependencias $X \to A_1$, $X \to A_2$, ..., $X \to A_n$.
3. **Atributos redundantes:** por cada DF $X \to A$ de $F$ y por cada atributo
   $B \in X$, si $(X - \{B\})^+$ respecto de $F$ contiene a $A$, reemplazar
   $X \to A$ por $(X - \{B\}) \to A$.
4. **Dependencias redundantes:** por cada DF $X \to A$ de $F$, si
   $F - \{X \to A\}$ es equivalente a $F$, eliminar $X \to A$ de $F$.

**Ejemplo.** Dado $E = \{B \to A, D \to A, AB \to D\}$, hallar el recubrimiento
minimal.

- ¿Hay DF con varios atributos a la derecha? Ninguna.
- ¿Hay atributos redundantes? En $AB \to D$: $A^+ = A$ y $B^+ = BAD$, así que
  $A$ es redundante y queda $E_1 = \{B \to A, D \to A, B \to D\}$.
- ¿Hay DF redundantes? En $E_1 - \{B \to A\}$ se calcula $B^+ = BDA$, así que
  $B \to A$ es redundante y queda $E_2 = \{D \to A, B \to D\}$.

Entonces $\{D \to A, B \to D\}$ es un recubrimiento minimal de $E$.

### 7.2. Ejemplo

Sea $F = \{A \to B, B \to C, AC \to D\}$. **No es minimal**, porque no cumple la
condición 3: $C$ es un atributo extraño en $AC \to D$, ya que $A \to C$ se
deduce de $A \to B$ y $B \to C$.

$F_1 = \{A \to B, B \to C, A \to D\}$ es equivalente a $F$:

- Con $F$ se demuestra $A \to D$ porque $A^+ = ABCD$.
- Con $F_1$ se demuestra $AC \to D$ porque $AC^+ = ABCD$.

$F_1$ **es minimal**, porque si se saca cualquiera de sus dependencias no se
puede deducir a partir de las que quedan.

En cambio, $F_2 = \{A \to B, B \to C, C \to D\}$ **no es equivalente** a $F$:
no se puede demostrar $C \to D$ a partir de $F$ (en $F$, $C^+ = C$).

### 7.3. Ejemplo con dependencias sobre un mismo esquema

Sea $F = \{A \to C, AC \to D, E \to AD, E \to H\}$. ¿Es minimal? Si no lo es,
encontrar un $G$ equivalente.

1. **¿Toda dependencia tiene un solo atributo a la derecha?** No: $E \to AD$.
   Se descompone en $E \to A$ y $E \to D$.
2. **¿Hay atributos extraños?** En $AC \to D$ ninguno lo es: $A^+ = AC$ (no
   contiene a $D$) y $C^+ = C$, así que no se puede reducir el antecedente.
3. **¿Hay dependencias redundantes?** $E \to D$ se deduce de $E \to A$,
   $A \to C$ y $AC \to D$ (o sea, $E^+$ sin usar $E \to D$ igual contiene a
   $D$), así que se elimina.

Resultado: $G = \{A \to C, AC \to D, E \to A, E \to H\}$.

---

## 8. Equivalencia de conjuntos de dependencias

Para saber si $F$ y $G$ son equivalentes hay que ver que cada uno **cubre** al
otro, es decir, que $F \subseteq G^+$ y $G \subseteq F^+$. Para cada dependencia
$X \to Y$ de $F$ se calcula $X^+$ con respecto a $G$ y se verifica que
$Y \subseteq X^+$ (y viceversa).

**Ejemplo.** Dados:

$$
DF_1 = \{A \to B, B \to A, A \to C, A \to D\}
$$

$$
DF_2 = \{A \to B, B \to A, B \to C, B \to D\}
$$

Las dependencias $A \to B$ y $B \to A$ están en ambos conjuntos, por lo que las
únicas de $DF_1$ que no están en $DF_2$ son $A \to C$ y $A \to D$.

- El cierre de $A$ con respecto a $DF_2$ es $A^+ = ABCD$. Como $C$ y $D$ están
  contenidos en el cierre, todas las dependencias de $DF_1$ están en $DF_2^+$,
  luego $DF_2$ es un recubrimiento de $DF_1$.
- El cierre de $B$ con respecto a $DF_1$ es $B^+ = BACD$. Por lo tanto,
  $B \to C$ y $B \to D$ están en $DF_1^+$, luego $DF_1$ es un recubrimiento de
  $DF_2$.

**Conclusión:** $DF_1$ y $DF_2$ son equivalentes.

> Se dice que $G$ **cubre** a $F$ cuando $F \subseteq G^+$. Si además $F$ cubre
> a $G$, los conjuntos son equivalentes; si no, solo uno cubre al otro (ver el
> ejemplo de $F_2$ en la sección 7.2, que no es equivalente a $F$).

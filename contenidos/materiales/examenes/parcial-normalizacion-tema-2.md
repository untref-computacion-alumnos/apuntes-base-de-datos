---
title: Parcial de Normalización — Tema 2
---

# Parcial de Normalización: Tema 2

Consignas del Tema 2 del parcial de normalización (2025). Ver los apuntes
[](../../apuntes/06-dependencias-funcionales.md) y
[](../../apuntes/07-descomposicion-y-formas-normales.md) para la teoría.

> Nota: en el original aparecía `M->KM` (dependencia trivial); por analogía con
> el Tema 4 se corrigió a $M \to K$. También se corrigió "3FHBC" por "3FNBC" y
> "tercera forma Formal" por "tercera forma normal".

## Consignas

**1.** Dado $R(H, I, J, K, L, M)$ y el conjunto de dependencias funcionales

$$
F = \{H \to IJ,\ J \to H,\ KM \to L,\ M \to K,\ HK \to M\}
$$

- **a)** ¿Está $R$ en tercera forma normal?
- **b)** ¿Es $F$ minimal?
- **c)** Llevar a la 3FNBC sin pérdida de información.
- **d)** Verificar si en la descomposición resultante se pierden dependencias.
- **e)** Decidir si la descomposición $R_1(H, I, K)$, $R_2(K, M)$ y
  $R_3(L, J, M)$ es sin pérdida de información.

Justificar cada paso.

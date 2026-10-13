---
title: Parcial de Normalización — Tema 4
---

# Parcial de Normalización: Tema 4

Consignas del Tema 4 del parcial de normalización (2025). Ver los apuntes
[](../../apuntes/06-dependencias-funcionales.md) y
[](../../apuntes/07-descomposicion-y-formas-normales.md) para la teoría.

> Nota: en el original aparecía `O->NO` (dependencia trivial en parte); por
> analogía con el Tema 2 se corrigió a $O \to N$.

## Consignas

**1.** Dado $R(N, P, K, L, M, O)$ y el conjunto de dependencias funcionales

$$
F = \{N \to PO,\ O \to N,\ KM \to L,\ M \to K,\ NK \to M\}
$$

- **a)** ¿Está $R$ en tercera forma normal?
- **b)** ¿Es $F$ minimal?
- **c)** Llevar a la 3FNBC sin pérdida de información.
- **d)** Verificar si en la descomposición resultante se pierden dependencias.
- **e)** Decidir si la descomposición $R_1(N, P, K)$, $R_2(K, M)$ y
  $R_3(L, O, M)$ es sin pérdida de información.

Justificar cada paso.

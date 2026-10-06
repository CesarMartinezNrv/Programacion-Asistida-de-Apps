/** Implementación de aplicar: aproxima al centavo. Precondiciones del domain. */
export function redondeoExacto() {
  return Object.freeze({ aplicar: valor => Math.round(valor * 100) / 100 })
}

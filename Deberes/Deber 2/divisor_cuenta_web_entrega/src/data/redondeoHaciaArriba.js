/** Implementación intercambiable: sube al entero siguiente, sin cambiar el cálculo. */
export function redondeoHaciaArriba() {
  return Object.freeze({ aplicar: valor => Math.ceil(valor) })
}

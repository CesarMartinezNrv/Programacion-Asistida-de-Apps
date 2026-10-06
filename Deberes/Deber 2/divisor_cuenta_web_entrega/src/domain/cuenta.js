/** Crea datos inmutables. Recibe números; validarEntrada comprueba sus reglas. */
export function cuenta(monto, personas, propina) {
  return Object.freeze({ monto, personas, propina })
}

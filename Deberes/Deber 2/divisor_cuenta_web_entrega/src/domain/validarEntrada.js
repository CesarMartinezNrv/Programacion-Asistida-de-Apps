/** Devuelve null si es válida, o el primer mensaje en orden monto/personas/propina. */
export function validarEntrada({ monto, personas, propina }) {
  if (!Number.isFinite(monto) || monto < 0) return 'Monto inválido'
  if (!Number.isInteger(personas) || personas < 1) return 'Debe haber al menos una persona'
  if (!Number.isFinite(propina) || propina < 0) return 'Propina inválida'
  return null
}

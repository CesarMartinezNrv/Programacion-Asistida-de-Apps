import { resultado } from './resultado.js'

/** Solo calcula y delega redondeo. Recibe cuenta válida y contrato aplicar(valor). */
export function calcularDivision(entrada, estrategia) {
  const importe = entrada.monto * (1 + entrada.propina / 100) / entrada.personas
  return resultado(estrategia.aplicar(importe))
}

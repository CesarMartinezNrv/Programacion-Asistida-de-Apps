/**
 * Contrato estructural ISP; cualquier objeto que lo cumpla es sustituible.
 * @typedef {Object} EstrategiaRedondeo
 * @property {(valor: number) => number} aplicar
 * Precondición: valor finito no negativo; valor * 100 también finito.
 * Poscondición: importe finito no negativo. No valida ni formatea.
 */
export {}

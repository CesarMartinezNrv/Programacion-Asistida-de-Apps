import { it, expect } from 'vitest'
import { cuenta } from '../src/domain/cuenta.js'
import { validarEntrada } from '../src/domain/validarEntrada.js'
import { formateadorMoneda } from '../src/presentation/formateadorMoneda.js'

it.each([
  [0, 1, 0, null], [-1, 1, 0, 'Monto inválido'], [Infinity, 1, 0, 'Monto inválido'],
  [1, 0, 0, 'Debe haber al menos una persona'], [1, 2.5, 0, 'Debe haber al menos una persona'],
  [1, 1, -1, 'Propina inválida'], [1, 1, NaN, 'Propina inválida'],
  [NaN, 0, -1, 'Monto inválido'],
])('validación de %s/%s/%s', (monto, personas, propina, esperado) => {
  expect(validarEntrada(cuenta(monto, personas, propina))).toBe(esperado)
})
it('formato grande conserva dos decimales sin exponente', () => {
  expect(formateadorMoneda(1e21)).toBe('1000000000000000000000.00')
})

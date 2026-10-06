import { describe, it, expect, vi } from 'vitest'
import { casos } from './casosDePrueba.js'
import { cuenta } from '../src/domain/cuenta.js'
import { validarEntrada } from '../src/domain/validarEntrada.js'
import { calcularDivision } from '../src/domain/calcularDivision.js'
import { redondeoExacto } from '../src/data/redondeoExacto.js'
import { redondeoHaciaArriba } from '../src/data/redondeoHaciaArriba.js'

describe('Seis casos de aceptación de la spec', () => {
  for (const caso of casos) {
    it(caso.nombre, () => {
      const entrada = cuenta(caso.monto, caso.personas, caso.propina)
      const calcular = vi.fn(calcularDivision)
      const error = validarEntrada(entrada)
      // Mismo flujo que el coordinador: un error impide invocar cálculo.
      if (error === null) {
        const estrategias = { exacto: redondeoExacto(), arriba: redondeoHaciaArriba() }
        const salida = calcular(entrada, estrategias[caso.modo])
        expect(salida.importe).toBeCloseTo(caso.esperado, 2)
      }
      if ('errorEsperado' in caso) {
        expect(error).toBe(caso.errorEsperado)
        expect(calcular).not.toHaveBeenCalled()
      } else {
        expect(error).toBeNull()
        expect(calcular).toHaveBeenCalledOnce()
      }
    })
  }
})

it('LSP: el mismo cálculo sustituye estrategias sin comprobar su tipo', () => {
  const entrada = cuenta(10, 3, 0)
  const ejecutar = estrategia => calcularDivision(entrada, estrategia).importe
  expect(ejecutar(redondeoExacto())).toBeCloseTo(3.33, 2)
  expect(ejecutar(redondeoHaciaArriba())).toBeCloseTo(4.00, 2)
})

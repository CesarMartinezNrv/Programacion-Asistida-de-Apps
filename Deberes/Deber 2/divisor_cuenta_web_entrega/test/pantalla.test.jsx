import { describe, it, expect, vi } from 'vitest'
import { render, screen, fireEvent } from '@testing-library/react'
import { PantallaDivisor } from '../src/presentation/PantallaDivisor.jsx'
import { validarEntrada } from '../src/domain/validarEntrada.js'
import { calcularDivision } from '../src/domain/calcularDivision.js'
import { redondeoExacto } from '../src/data/redondeoExacto.js'
import { redondeoHaciaArriba } from '../src/data/redondeoHaciaArriba.js'
import { formateadorMoneda } from '../src/presentation/formateadorMoneda.js'

function abrir() {
  const calcular = vi.fn(calcularDivision)
  render(<PantallaDivisor dependencias={{ validar: validarEntrada, calcular,
    estrategias: { exacto: redondeoExacto(), arriba: redondeoHaciaArriba() }, formatear: formateadorMoneda }} />)
  return calcular
}
function ingresar(monto, personas, propina = '0') {
  fireEvent.change(screen.getByLabelText('Monto'), { target: { value: monto } })
  fireEvent.change(screen.getByLabelText('Personas'), { target: { value: personas } })
  fireEvent.change(screen.getByLabelText('Propina (%)'), { target: { value: propina } })
  fireEvent.click(screen.getByRole('button', { name: 'Calcular' }))
}

describe('Tres pruebas obligatorias de pantalla', () => {
  it('100, 4, 10 muestra 27.50', () => {
    abrir(); ingresar('100', '4', '10')
    expect(screen.getByTestId('resultado')).toHaveTextContent('27.50')
  })
  it('cero personas muestra error sin resultado y sin calcular', () => {
    const calcular = abrir(); ingresar('50', '0')
    expect(screen.getByRole('alert')).toHaveTextContent('Debe haber al menos una persona')
    expect(screen.queryByTestId('resultado')).not.toBeInTheDocument()
    expect(calcular).not.toHaveBeenCalled()
  })
  it('abc muestra Monto inválido', () => {
    const calcular = abrir(); ingresar('abc', '4')
    expect(screen.getByRole('alert')).toHaveTextContent('Monto inválido')
    expect(calcular).not.toHaveBeenCalled()
  })
})

describe('Aclaraciones y transiciones de la spec', () => {
  it('cero y coma decimal se aceptan', () => {
    abrir(); ingresar('0', '2', '0')
    expect(screen.getByTestId('resultado')).toHaveTextContent('0.00')
    ingresar('100,00', '4', '10,0')
    expect(screen.getByTestId('resultado')).toHaveTextContent('27.50')
  })
  it.each(['', '-1', '12abc', 'Infinity', '1,000.00', '0x10'])('monto %s se rechaza sin calcular', monto => {
    const calcular = abrir(); ingresar(monto, '4')
    expect(screen.getByRole('alert')).toHaveTextContent('Monto inválido')
    expect(calcular).not.toHaveBeenCalled()
  })
  it.each(['', '-1', '2.5', 'abc'])('personas %s se rechaza', personas => {
    abrir(); ingresar('50', personas)
    expect(screen.getByRole('alert')).toHaveTextContent('Debe haber al menos una persona')
  })
  it.each(['', '-1', 'abc'])('propina %s se rechaza', propina => {
    abrir(); ingresar('50', '4', propina)
    expect(screen.getByRole('alert')).toHaveTextContent('Propina inválida')
  })
  it('edición y modo eliminan resultado; hacia arriba devuelve 4.00', () => {
    abrir(); ingresar('10', '3')
    expect(screen.getByTestId('resultado')).toHaveTextContent('3.33')
    fireEvent.change(screen.getByLabelText('Redondeo'), { target: { value: 'arriba' } })
    expect(screen.queryByTestId('resultado')).not.toBeInTheDocument()
    fireEvent.click(screen.getByRole('button', { name: 'Calcular' }))
    expect(screen.getByTestId('resultado')).toHaveTextContent('4.00')
    fireEvent.change(screen.getByLabelText('Monto'), { target: { value: '11' } })
    expect(screen.queryByTestId('resultado')).not.toBeInTheDocument()
  })
  it('un error tras un resultado lo elimina y corregirlo vuelve a calcular', () => {
    abrir(); ingresar('100', '4', '10')
    ingresar('100', '0', '10')
    expect(screen.queryByTestId('resultado')).not.toBeInTheDocument()
    ingresar('100', '4', '10')
    expect(screen.queryByRole('alert')).not.toBeInTheDocument()
    expect(screen.getByTestId('resultado')).toHaveTextContent('27.50')
  })
  it('desbordamiento muestra mensaje sin invocar cálculo', () => {
    const calcular = abrir(); ingresar('1e308', '1', '100')
    expect(screen.getByRole('alert')).toHaveTextContent('El monto calculado es demasiado grande')
    expect(calcular).not.toHaveBeenCalled()
  })
})

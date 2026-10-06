import { useState } from 'react'
import { cuenta } from '../domain/cuenta.js'

/** Convierte el texto completo con coma o punto; inválido se representa como NaN. */
function numero(texto) {
  const normalizado = texto.trim().replace(',', '.')
  if (!/^[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$/.test(normalizado)) return NaN
  return Number(normalizado)
}

/** Estado y coordinación. Recibe servicios del domain y contratos, nunca data. */
export function useDivisor({ validar, calcular, estrategias, formatear }) {
  const [campos, setCampos] = useState({ monto: '', personas: '2', propina: '0', modo: 'exacto' })
  const [salida, setSalida] = useState({ resultado: null, error: null })

  /** Editar cualquier campo elimina el cálculo anterior y el error. */
  function cambiar(campo, valor) {
    setCampos(anteriores => ({ ...anteriores, [campo]: valor }))
    setSalida({ resultado: null, error: null })
  }

  /** Valida antes de calcular; publica error o resultado, nunca ambos. */
  function ejecutar() {
    const personas = /^[+-]?\d+$/.test(campos.personas.trim()) ? Number(campos.personas) : NaN
    const entrada = cuenta(numero(campos.monto), personas, numero(campos.propina))
    const error = validar(entrada)
    if (error !== null) {
      setSalida({ resultado: null, error })
      return
    }
    // Precondición de las estrategias, equivalente al controller Flutter.
    const importe = entrada.monto * (1 + entrada.propina / 100) / entrada.personas
    if (!Number.isFinite(importe) || !Number.isFinite(importe * 100)) {
      setSalida({ resultado: null, error: 'El monto calculado es demasiado grande' })
      return
    }
    const estrategia = estrategias[campos.modo]
    if (!estrategia) {
      setSalida({ resultado: null, error: 'Modo de redondeo inválido' })
      return
    }
    setSalida({ resultado: calcular(entrada, estrategia), error: null })
  }

  return { campos, cambiar, ejecutar, error: salida.error,
    resultado: salida.resultado === null ? null : formatear(salida.resultado.importe) }
}

import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { validarEntrada } from './domain/validarEntrada.js'
import { calcularDivision } from './domain/calcularDivision.js'
import { redondeoExacto } from './data/redondeoExacto.js'
import { redondeoHaciaArriba } from './data/redondeoHaciaArriba.js'
import { formateadorMoneda } from './presentation/formateadorMoneda.js'
import { PantallaDivisor } from './presentation/PantallaDivisor.jsx'

// Único punto de composición de servicios y estrategias concretas en src/.
const dependencias = Object.freeze({ validar: validarEntrada, calcular: calcularDivision,
  estrategias: Object.freeze({ exacto: redondeoExacto(), arriba: redondeoHaciaArriba() }),
  formatear: formateadorMoneda })

createRoot(document.getElementById('root')).render(
  <StrictMode><PantallaDivisor dependencias={dependencias} /></StrictMode>,
)

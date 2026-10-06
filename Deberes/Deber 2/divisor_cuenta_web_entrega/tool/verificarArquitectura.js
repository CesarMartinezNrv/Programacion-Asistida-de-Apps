import { readdirSync, readFileSync } from 'node:fs'
import { join } from 'node:path'
import assert from 'node:assert/strict'

/** Recorre archivos de src para comprobar reglas arquitectónicas explícitas. */
function archivos(directorio) {
  return readdirSync(directorio, { withFileTypes: true }).flatMap(entrada => {
    const ruta = join(directorio, entrada.name)
    return entrada.isDirectory() ? archivos(ruta) : [ruta]
  })
}
for (const ruta of archivos('src')) {
  const texto = readFileSync(ruta, 'utf8')
  const normalizada = ruta.replaceAll('\\', '/')
  if (normalizada.startsWith('src/domain/')) {
    assert(!/from\s+['"][^'"]*(react|data)/.test(texto), `${ruta}: dependencia indebida`)
    assert(!/\b(document|window|HTMLElement)\b/.test(texto), `${ruta}: DOM en dominio`)
  }
  if (!normalizada.startsWith('src/data/') && normalizada !== 'src/main.jsx') {
    assert(!/redondeoExacto|redondeoHaciaArriba/.test(texto), `${ruta}: concreción fuera de main`)
  }
  if (normalizada.startsWith('src/presentation/')) {
    assert(!/from\s+['"][^'"]*\/data\//.test(texto), `${ruta}: presentación depende de data`)
  }
}
const calculo = readFileSync('src/domain/calcularDivision.js', 'utf8')
assert(!/instanceof|===\s*['"](?:exacto|arriba)|toFixed|inválido|al menos una persona/.test(calculo))
console.log('PASS DIP: domain sin React, DOM ni data; presentation sin data')
console.log('PASS composición: estrategias concretas solo en data y main.jsx')
console.log('PASS OCP/LSP: cálculo sin comprobaciones de tipo o modo')
console.log('PASS SRP: cálculo sin validación ni formato')

# Tasks: Dividir cuenta en React

Input: spec, plan, research, data-model y contracts/ui; pruebas exigidas por Deber2.md.

## Phase 1: Setup
- [X] T001 Configurar Vitest, jsdom y scripts en vite.config.js, package.json y test/setup.js.
- [X] T002 Mantener spec.md idéntica y registrar evidencia en evidencias/spec-inicial.diff.

## Phase 2: Foundational
- [X] T003 [P] Crear objetos inmutables en src/domain/cuenta.js y src/domain/resultado.js: monto y propina finitos no negativos; personas entero positivo como precondición.
- [X] T004 [P] Documentar contrato aplicar(valor) en src/domain/estrategiaRedondeo.js; importe finito no negativo entra y sale.

## Phase 3: US1 — Repartir con propina (P1)
Objetivo: 100/4/10 → 27.50, 90/3/0 → 30.00 y 10/3/0 → 3.33.
Prueba independiente: test/division.test.js casos 1, 2 y 5; primer caso pantalla.
- [X] T005 [US1] Traducir los datos sin cambios y crear runner en test/casosDePrueba.js y test/division.test.js.
- [X] T006 [US1] Crear pruebas obligatorias de pantalla antes de la vista en test/pantalla.test.jsx.
- [X] T007 [US1] Implementar fórmula pura en src/domain/calcularDivision.js y exacto en src/data/redondeoExacto.js (FR-002, FR-003).
- [X] T008 [US1] Implementar formato de dos decimales con punto sin moneda en src/presentation/formateadorMoneda.js (FR-004).
- [X] T009 [US1] Implementar estado local e inyección en src/presentation/useDivisor.js: monto vacío, dos personas, cero propina, modo exacto; sin librerías de estado.
- [X] T010 [US1] Crear pantalla accesible y componer servicios en src/presentation/PantallaDivisor.jsx y src/main.jsx (FR-001, FR-009).

## Phase 4: US2 — Entradas inválidas (P1)
Prueba independiente: casos 3 y 4; pantalla error sin resultado y abc.
- [X] T011 [US2] Crear pruebas de cero, coma, negativos, vacíos, no finitos y personas fraccionarias en test/entrada.test.js (SC-004).
- [X] T012 [US2] Implementar validación ordenada monto/personas/propina en src/domain/validarEntrada.js; null válido y mensajes exactos (FR-005, FR-006, FR-008).
- [X] T013 [US2] Implementar parseo completo, desbordamiento y limpieza al editar/cambiar modo en src/presentation/useDivisor.js (FR-007, edge cases, SC-002).

## Phase 5: US3 — Redondeo (P2)
Prueba independiente: mismo reparto 10/3/0 → 4.00 hacia arriba; LSP.
- [X] T014 [US3] Implementar hacia arriba sin modificar cálculo en src/data/redondeoHaciaArriba.js y selector en src/presentation/PantallaDivisor.jsx.
- [X] T015 [US3] Probar sustitución en test/division.test.js y cambio de modo en test/pantalla.test.jsx (LSP, SC-003).

## Phase 6: Polish
- [X] T016 Verificar arquitectura en tool/verificarArquitectura.js; dominio sin React/DOM/data, estrategias solo data/main, cálculo sin formato/validación.
- [X] T017 Ejecutar pruebas y build, registrar tiempos reales en evidencias/ y bitacora.md.
- [X] T018 Medir diffs e inventarios, responder seis preguntas en respuestas.md e incluir la explicación paso a paso en respuestas.md.

## Dependencias y estrategia
Setup → fundamentos → US1 → US2 → US3 → verificaciones y entrega. Es la secuencia de ejecución en esta sesión.
MVP: US1 con datos válidos; después errores y estrategias. Pruebas escritas antes de src.
Paralelizables: T003 y T004 por archivos independientes; se ejecutan secuencialmente aquí.
US1: formato T008 independiente del cálculo una vez definido resultado. US2: pruebas T011 separadas del parser. US3: datos de estrategia separados de la vista, pero se integra tras US1.

## Phase 7: Convergence
- [X] T019 Eliminar restos de plantilla sin uso en src/App.jsx, src/App.css, src/index.css, src/assets/ y public/ (plan: alcance de una pantalla; unrequested, LOW).


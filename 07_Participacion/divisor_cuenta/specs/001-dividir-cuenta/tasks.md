# Tasks: Dividir cuenta
**Input**: spec.md, plan.md, research.md, data-model.md y contracts/ui.md.
**Tests**: solicitadas por el enunciado; escribir antes de implementar.
## Phase 1: Setup
- [ ] T001 Verificar SDK y exclusiones en pubspec.yaml y .gitignore, sin paquetes nuevos.
## Phase 2: Foundational
- [ ] T002 Crear Cuenta y Resultado inmutables en lib/domain/cuenta.dart y lib/domain/resultado.dart.
- [ ] T003 Definir interfaz de un método en lib/domain/estrategia_redondeo.dart.
## Phase 3: US1 — reparto (P1)
Objetivo: reparto válido; comprobación independiente: casos 1, 2 y 5.
- [ ] T004 [US1] Traducir seis escenarios en test/casos_de_prueba.dart y bucle en test/division_test.dart.
- [ ] T005 [US1] Implementar redondeo a centavos en lib/data/redondeo_exacto.dart.
- [ ] T006 [US1] Implementar fórmula sin validar/formatear en lib/domain/calcular_division.dart.
- [ ] T007 [US1] Implementar dos decimales en lib/presentation/formateador_moneda.dart.
## Phase 4: US2 — validación (P1)
Objetivo: rechazar errores; comprobación independiente: casos 3 y 4, negativos, vacíos.
- [ ] T008 [US2] Crear pruebas de aclaraciones en test/entrada_test.dart.
- [ ] T009 [US2] Implementar validación “finito >= 0” y “personas >= 1” en lib/domain/validar_entrada.dart.
- [ ] T010 [US2] Normalizar coma/punto y limpiar resultados en lib/presentation/divisor_controller.dart.
## Phase 5: US3 — modo y pantalla (P2)
Objetivo: entero hacia arriba; comprobación independiente: caso 6 y sustitución LSP.
- [ ] T011 [US3] Agregar sustitución LSP en test/division_test.dart.
- [ ] T012 [US3] Implementar ceilToDouble en lib/data/redondeo_hacia_arriba.dart.
- [ ] T013 [US3] Crear tres pruebas de widget y modo hacia arriba en test/pantalla_test.dart.
- [ ] T014 [US3] Dibujar entradas, selector y salida en lib/presentation/pantalla_divisor.dart.
- [ ] T015 [US3] Inyectar servicios y estrategias únicamente en lib/main.dart; retirar test/widget_test.dart del contador base.
## Phase 6: Polish
- [ ] T016 Ejecutar dominio sin motor con tool/verificar_domain.dart.
- [ ] T017 Ejecutar analyze, test nativo y Chrome; guardar salidas en ../.herramientas/evidencias/.
- [ ] T018 Construir APK debug y verificar SOLID; guardar salidas en ../.herramientas/evidencias/.
- [ ] T019 Documentar funciones y ejecutar converge en README.md y specs/001-dividir-cuenta/convergence.md.
## Dependencies & Execution Order
T001 -> T002/T003 -> US1 -> US2 -> US3 -> Polish.
T004/T008/T011/T013 deben existir antes del código correspondiente.
US2 y US3 usan el caso de uso US1; cada historia tiene escenarios independientes.
## Parallel Examples
US1: T005 y T007 pueden hacerse en archivos distintos tras T004.
US2: diseño de T008 y T009 en archivos distintos, implementación después del test.
US3: T012 y T013 en archivos distintos tras T011.
En esta ejecución trabaja un solo agente, sin delegación.
## Implementation Strategy
MVP cálculo exacto, después errores y finalmente selector/pantalla.
No marcar verificación exitosa cuando solo se haya intentado.


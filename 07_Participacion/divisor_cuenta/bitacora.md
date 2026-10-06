# Bitácora del Deber 2

Creada inicialmente en 07_Participacion/divisor_cuenta durante la rama sdd antes de la Parte 1. La entrega final se conserva en main por instrucción del usuario. Proyecto Flutter SDD copiado a ../divisor_cuenta sin sobrescribir la versión previa de main.

| Métrica | Flutter (laboratorio) | React (este deber) |
|---|---:|---:|
| Minutos hasta primera compilación | no registrado | 9.83 |
| Minutos hasta que pasan los 6 casos | no registrado | 10.15 |
| Iteraciones del usuario después del prompt inicial | no registrado | 0 |
| Líneas escritas a mano por estudiante | no registrado | 0 |
| Enunciados spec modificados | — | 0/64 |
| Enunciados Constitution modificados | — | 13/27 |
| Plan: enunciados modificados | — | 40/54 |
| Plan: líneas físicas del diff | — | +50 / -44 |
| Casos de aceptación que pasan | 6/6 verificados en esta sesión | 6/6 |
| Suite completa | 18/18 en navegador en esta sesión | 36/36 |

Horarios observados, America/Guayaquil (UTC-5):
- Inicio de planificación React: 2026-10-06 10:26:00.
- Primer build correcto: 2026-10-06 10:35:50; el cronómetro siguió.
- Seis casos verdes: 2026-10-06 10:36:09; cronómetro detenido.
- Los tiempos de pruebas/build individuales mostrados por los runners son duraciones de comandos; no se confunden con el cronómetro total.

La guía define el inicio por el envío del primer prompt /speckit-plan. En esta sesión el usuario autorizó toda la práctica en un solo prompt: no envió prompts por fase. Se tomó como equivalente operativo la marca UTC inmediatamente anterior a ejecutar setup-plan de la Parte 5. Es una adaptación explícita de la medición, no un tiempo histórico estimado. Incluye elaboración de plan/tareas/pruebas/código, llamadas de herramientas y comprobaciones del entorno que se intercalaron.

No hubo mensajes correctivos del usuario; los ajustes autónomos del agente no cuentan como iteraciones. Las tareas que la guía pide hacer a mano (Parte 2 y casosDePrueba.js) fueron elaboradas por el agente por petición del usuario, y deben ser revisadas personalmente; no se atribuyen al estudiante como trabajo manual.

Spec Kit 1.0.13, Codex skills: init, constitution, plan, tasks, analyze, implement y converge. No se ejecutó speckit-specify. No hooks instalados. Research delegado por requerimiento de speckit-plan; no cuenta como iteración del usuario.

Incidencias: Windows bloquea flutter_tester.exe. El runner web necesitó package:test y una copia local ignorada de CanvasKit debido a un fallo de separadores de ruta. Las 18 pruebas Flutter pasan con tool/probar_web.ps1. La validación completa Flutter se logró mientras avanzaba la preparación/implementación React; por tanto no se afirma haber cumplido estrictamente el orden «suite Flutter completa antes de cualquier implementación React». Los seis casos y LSP en Dart puro ya habían sido verificados antes de planificar. La entrega final comprueba ambas suites.

El cambio a main se hizo conservando cambios locales. La revisión automática rechazó restaurar toda la carpeta original; se evitó sobrescribirla y se creó una copia nueva desde sdd. La carpeta original del laboratorio en main conserva su código previo. La copia nueva permite repetir el experimento SDD sin esa ambigüedad.

Segunda convergencia: completada; 19 tareas satisfechas y ninguna brecha pendiente, registrada en specs/001-dividir-cuenta/convergence.md. Tiempos Flutter históricos desconocidos: no se infiere que React sea más rápido ni que SDD sea superior solo con esta sesión.

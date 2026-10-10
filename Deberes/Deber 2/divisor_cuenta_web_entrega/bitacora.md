# Bitácora del Deber 2

La bitácora se inició en el laboratorio anterior. La entrega final quedó en `main`, como pedí. Se usó una copia del proyecto Flutter para conservar el laboratorio original.

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

## Horarios del cronómetro

Registro del 6 de octubre de 2026, hora de Ecuador (UTC-5):

- Inicio de la planificación de React: **10:26:00**.
- Primer build correcto: **10:35:50**, después de **9 min 50 s**. El cronómetro siguió contando.
- Los seis casos pasaron: **10:36:09**, después de **10 min 9 s**. Aquí se detuvo el cronómetro.

La guía indica empezar con el primer mensaje de planificación. Como pedí todo el trabajo en un solo mensaje, se tomó como inicio el momento de preparar el plan de React. El tiempo incluye la preparación, la programación, las pruebas y los ajustes de las herramientas. Las duraciones que aparecen en la salida de cada comando no son el tiempo total del cronómetro.

## Ayuda utilizada

El trabajo se preparó con Codex. No escribí líneas de código a mano ni envié mensajes para corregir la aplicación durante esa medición. Los ajustes que hizo el agente por su cuenta no se contaron como mensajes correctivos.

El análisis y los casos que la guía pide hacer a mano también se prepararon con ayuda del agente. Debo revisarlos y poder explicarlos antes de entregar. Las correcciones posteriores de redacción no cambian el cronómetro original.

## Revisiones y problemas encontrados

Se usó Spec Kit 1.0.13 para preparar las reglas, el plan y las tareas, revisar el proyecto e implementarlo. No se volvió a ejecutar `speckit-specify`: se conservó la spec anterior. Se completaron las 19 tareas y la revisión final quedó en `specs/001-dividir-cuenta/convergence.md`.

Windows bloqueó la herramienta que ejecuta las pruebas de Flutter. Por eso se hicieron en Chrome, con un ajuste en las herramientas de prueba. Se pueden repetir con `tool/probar_web.ps1` dentro del proyecto Flutter.

Antes de planificar React se comprobaron los seis casos y el intercambio de los modos de redondeo en Dart. Las 18 pruebas completas de Flutter terminaron después, mientras avanzaba el trabajo de React. Ese orden fue distinto al pedido por la guía y queda registrado aquí.

Al final pasaron **18 pruebas en Flutter y 36 en React**. No se registró el tiempo del laboratorio anterior, así que no puedo afirmar que React fue más rápido.

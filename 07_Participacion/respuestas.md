# Respuestas — Participación 7
Fecha de ejecución: 2026-10-01.

## 1. Métricas, agente y cumplimiento
| Métrica | rama vibe | rama sdd |
|---|---|---|
| Mensajes posteriores registrados en la fase (ver regla de conteo) | 5 | 1 |
| Correcciones funcionales pedidas por el usuario | 0 | 0 |
| Casos de aceptación cumplidos | 5/6 | 6/6 |
| Pruebas automatizadas propias que pasan | 1 de pantalla inicial | 18: seis casos + LSP + seis de entradas + cinco widgets |
| Archivos Dart en lib/ | 1 | 11 |
| Líneas en lib/, incluyendo comentarios y vacías | 100 | 289 |
| ¿domain/ depende de Flutter? | No existe domain/; el cálculo está en un archivo que importa Flutter | No |
| ¿Hay separación presentation/domain/data? | No | Sí |
| ¿Agregó decisiones no pedidas textualmente? | Sí: propina, validaciones, dos decimales y valores iniciales a partir de la frase mínima | Sí: valores iniciales, orden de errores, limpieza al editar y protección de desbordamiento, documentadas |
| ¿Otra estrategia sin modificar el cálculo existente? | No: habría que extraer o editar calcular() | Sí: nueva implementación de EstrategiaRedondeo y conexión en main/UI |
| Tiempo secundario | No medido | No medido |

**Agente:** Codex en la app de escritorio, misma sesión en ambas ramas.
**Modelo:** familia GPT-6, según la identificación del agente; el identificador exacto
seleccionado y el nivel de razonamiento no están expuestos en esta sesión. No se cambió
modelo ni configuración entre implementaciones. No se inventa una variante o nivel.
Si la materia exige el nombre exacto de la opción de la interfaz, debe transcribirse de
la configuración visible del usuario antes de entregar.

**Instrucciones:** AGENTS.md en divisor_cuenta, rama sdd; vibe no tiene instrucciones
específicas de arquitectura. **Git:** caso C; repositorio padre existente, alternativa
autorizada por el usuario. No quedó un repositorio anidado.

**Conteo:** hubo una solicitud global para hacer el ejercicio. Antes de completar vibe,
el usuario envió cinco mensajes: respetar carpeta, cambiar organización a carpetas,
preguntar por las ramas, autorizar las ramas existentes y “continúa”. La guía cuenta
mensajes de cambio, explicación o acción, así que se conservan como cinco mensajes de
esa fase, aunque no fueron cinco arreglos de la app. En SDD hubo un mensaje con respuestas
a las dos aclaraciones. Las herramientas y correcciones autónomas no cuentan.
No hubo solicitudes iniciales independientes por rama: esta cifra no es una medición
controlada de iteraciones de desarrollo y no se usa para concluir superioridad.

SDD cumplió mejor los criterios observados: 6/6 frente a 5/6. Vibe cumple el reparto
exacto y los errores principales, pero no permite seleccionar hacia arriba.
En vibe el agente decidió propina y validación por su cuenta. En SDD los dos modos,
los mensajes, los seis escenarios y la arquitectura están escritos; cero/negativos y
coma/punto quedaron confirmados por el usuario. Hubo 19 tareas, todas completadas.

## 2. Pruebas SDD llevadas a vibe
Se ejecutó, desde la raíz del repositorio:
```powershell
git switch vibe
git checkout sdd -- 07_Participacion/divisor_cuenta/test
cd 07_Participacion/divisor_cuenta
flutter test --reporter expanded
```
No compilaron las pruebas SDD. Primer error:
```text
test/division_test.dart:6:8: Error: Error when reading 'lib/domain/cuenta.dart': The system cannot find the path specified
import 'package:divisor_cuenta/domain/cuenta.dart';
```
Eso prueba una diferencia de arquitectura y contratos de prueba; por sí solo no prueba
un fallo funcional. El test original de vibe permaneció durante la copia y pasó:
resultado global 1 aprobado y tres archivos de test que no pudieron cargar.
No se interpreta esto como “0/6 funcionales”.

Se verificaron después las entradas en la interfaz con el navegador:
| Caso | Esperado | vibe observado | sdd observado |
|---|---|---|---|
| 1: 100, 4, 10%, exacto | 27.50 | 27.50 | 27.50 |
| 2: 90, 3, 0%, exacto | 30.00 | 30.00 | 30.00 |
| 3: 50, 0 personas | mensaje, sin resultado | correcto | correcto |
| 4: abc | Monto inválido | correcto | correcto |
| 5: 10, 3, exacto | 3.33 | 3.33 | 3.33 |
| 6: 10, 3, arriba | 4.00 | selector ausente; solo 3.33 | 4.00 |

Para reutilizar los tests habría que extraer validación/cálculo, crear entidades e
interfaz y adaptar la composición. Una alternativa sería escribir tests de UI adaptados
a vibe, pero no sería reutilización literal de los tests de dominio.
Después se restauró test/ con:
```powershell
git restore --source=HEAD --staged --worktree -- 07_Participacion/divisor_cuenta/test
```
El diff de test/ quedó vacío. Las pruebas originales de vibe luego pasaron: 1/1.
Evidencias: [transferencia](evidencias/vibe-pruebas-sdd.txt), [vibe UI](evidencias/vibe-manual.txt),
[SDD UI](evidencias/sdd-manual.txt).

## 3. SOLID y evidencia
| Regla | sdd | vibe | Principio que explica la diferencia |
|---|---|---|---|
| Dominio sin Flutter | pasa: sin coincidencias | no hay dominio separado; lib/main.dart importa Flutter | DIP y arquitectura |
| Instanciación concreta en composición | pasa semánticamente: estrategias inyectadas en main | no hay estrategias que inyectar | DIP |
| Cálculo sin if/cast de tipo | pasa | no tiene interfaz sustituible; búsqueda vacía no demuestra LSP | OCP/LSP |
| Cálculo sin validar/formatear | pasa | calcular() valida, calcula y usa toStringAsFixed | SRP |
| Interfaz de un método | EstrategiaRedondeo.redondear | no existe interfaz | ISP |
| Extender sin editar cálculo | nueva estrategia | hay que editar/extraer calcular() | OCP |

Comandos PowerShell equivalentes a los grep de la guía, desde el proyecto:
```powershell
rg -n 'package:flutter' lib/domain
rg -n 'import.*data' lib/presentation
rg -n 'RedondeoExacto\(\)|RedondeoHaciaArriba\(\)' lib
rg -n 'is Redondeo|as Redondeo' lib/domain/calcular_division.dart
rg -n 'toStringAsFixed|inválido|al menos una persona' lib/domain/calcular_division.dart
```
SDD: primera, segunda, cuarta y quinta búsquedas no imprimen nada.
Búsqueda de constructor:
```text
lib/main.dart:19: 'exacto': RedondeoExacto(),
lib/main.dart:20: 'arriba': RedondeoHaciaArriba(),
lib/data/redondeo_hacia_arriba.dart:4: const RedondeoHaciaArriba();
lib/data/redondeo_exacto.dart:4: const RedondeoExacto();
```
La expresión de la guía también encuentra **declaraciones de constructores**, que
no instancian objetos. No se ocultaron esas coincidencias: las únicas expresiones que
crean las estrategias en lib están en main. El checklist “solo aparecen en main” se
cumple como regla de composición, no literalmente como resultado de ese grep.
La interfaz define un método y la prueba LSP pasa en la suite.

En vibe:
```text
lib/main.dart:1: import 'package:flutter/material.dart';
lib/domain existe: False
lib contiene: main.dart
28: void calcular() {
36: error = 'Monto inválido';
38: error = 'Debe haber al menos una persona';
42: resultado = (...).toStringAsFixed(
```
Estas comprobaciones aportan evidencia de dependencias y separación; no demuestran
automáticamente todo SOLID. La revisión de diseño y la prueba LSP completan la evidencia.
Archivos: [SDD](evidencias/sdd-solid.txt), [vibe](evidencias/vibe-solid.txt).

## 4. Clarify
Se hicieron dos preguntas reales en el chat y se incorporaron a la spec:
1. “¿Aceptamos montos y propinas de cero, rechazando valores negativos?” Respuesta:
   “Sí, aceptar cero y rechazar negativos”. Define validación: la guía solo especificaba
   cero personas y monto no numérico, no todos los límites de monto/propina.
2. “¿Permitir coma decimal además del punto?” Respuesta: “Sí, permitir ambos”.
   Evita que un usuario hispanohablante reciba error al ingresar 100,50.

Las preguntas se agruparon en el mecanismo de preguntas del chat antes del plan y sus
respuestas se reutilizaron al ejecutar clarify. No se simularon respuestas ni una
conversación separada. En vibe el agente eligió aceptar cero y rechazar negativos;
solo el punto decimal se acepta al usar double.tryParse sin normalización.
En SDD ambas decisiones quedaron confirmadas y tienen pruebas.

## 5. Diff, alcance y mantenibilidad
`git diff vibe sdd --stat -- 07_Participacion`:
```text
60 files changed, 5817 insertions(+), 108 deletions(-)
```
Solo lib:
```text
11 files changed, 282 insertions(+), 93 deletions(-)
```
Gran parte del diff completo son las skills, scripts y plantillas oficiales de Spec Kit.
No son miles de líneas nuevas de funcionalidad de la app.
Vibe agregó propina, validaciones y valores iniciales a partir de una frase que no los
detallaba. SDD documentó decisiones adicionales, como ocultar resultados al editar y
proteger el desbordamiento, para completar casos límite. Se agregaron seis pruebas de
entrada, dos widgets extra y el verificador Dart puro como apoyo a la validación.
No se añadieron login, historial, servicios de red, persistencia ni otras pantallas.

Retomaría más fácilmente SDD: la spec y las tareas explican decisiones, los tests fijan
comportamiento y las capas indican dónde cambiar. A un compañero le enviaría el README,
spec.md, plan.md y las pruebas de sdd. Para una estrategia al múltiplo de cinco, crearía
otra clase en data y la conectaría en main/pantalla; no tocaría CalcularDivision ni las
estrategias existentes. En vibe habría que editar o extraer el método calcular().
Vibe es más breve; SDD tiene más documentos y clases. Esa diferencia es un coste visible,
no una garantía universal de calidad. [Diff completo](evidencias/diff-stat.txt).

## 6. Otra herramienta SDD y cuándo usar vibe
Elegí **OpenSpec**. Organiza cada cambio con propuesta, especificaciones, diseño y tareas
en una carpeta, permite revisar artefactos con un flujo flexible y destaca su uso sobre
proyectos existentes. Lo preferiría para una mejora pequeña en una app que ya funciona,
por ejemplo añadir redondeo de cinco a este divisor.
[Fuente primaria: OpenSpec](https://github.com/Fission-AI/OpenSpec).

En contraste, el proceso SDD de Spec Kit usado aquí parte de una constitución y sigue
especificación, plan, tareas, implementación y convergencia. Es apropiado para explicitar
las reglas y la trazabilidad que exige esta práctica.
[Fuente primaria: Spec Kit](https://github.com/github/spec-kit).

Usaría vibe para un prototipo personal desechable de diez minutos que calcule cuánto
paga cada amigo, sin cuentas reales persistidas ni requisitos complejos. Conversar y
probar directamente sería razonable; al incorporar varias reglas, colaboración o
mantenimiento prolongado, explicitar requisitos y tests cobra más valor.

## Evidencias finales y límites
- [x] main, vibe y sdd en el repositorio existente.
- [x] merge-base vibe sdd = 3b38a523fea391c7c7bae19afbd861ba740b1270.
- [x] Misma sesión/agente; sin cambios de modelo o configuración.
- [x] AGENTS.md y .specify versionados en sdd.
- [x] Constitución, spec, plan, 19 tareas, análisis y convergencia.
- [x] Archivos de casos, pruebas de dominio y widgets.
- [x] 18 pruebas nativas pasan: [salida](evidencias/sdd-test-native.txt).
- [x] Análisis limpio: [salida](evidencias/sdd-analyze.txt).
- [x] APK debug construido: [salida](evidencias/sdd-build-apk.txt).
- [x] Dominio sin imports Flutter y composición semántica en main.
- [x] respuestas.md y analisis.md en main.
- Publicación de ramas: ver [registro](evidencias/publicacion.txt).

El entorno informó falta de Visual Studio para Windows; no impidió construir Android.
El primer bloqueo del tester fue transitorio: la suite nativa final pasó.
Chrome y Edge no completaron la carga de la suite y no se cuentan como pruebas aprobadas.
La comparación no fue ciega y el contador de mensajes mezcla gestión y aclaración.
Los IDs exactos de modelo/nivel deben consultarse en la interfaz del usuario si se exige
esa precisión. El proyecto base continúa en main por diseño; la app terminada está en sdd.


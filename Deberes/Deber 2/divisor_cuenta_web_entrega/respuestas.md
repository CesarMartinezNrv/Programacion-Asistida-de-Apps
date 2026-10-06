# Deber 2 - SDD: migración de Flutter a React

Programación Asistida de Aplicaciones - USFQ. Fecha: 6 de octubre de 2026.
Trabajo preparado para César Martínez. Agente: Codex.

## Resultado comprobado

React/Vite con JavaScript, una pantalla y useState, capas presentation → domain ← data. **6/6 casos de aceptación, LSP y tres pruebas obligatorias de pantalla**; suite ampliada **36/36**. Build correcto. Flutter SDD: **18/18**, All tests passed en Chrome, con ajuste de runner para Windows. Cronómetro React: **9.83 min hasta primer build; 10.15 min hasta seis casos**. Sin tiempos históricos Flutter para comparar.

La especificación viajó intacta: **64/64 enunciados, 100%**, bajo el método publicado en [analisis_spec.md](analisis_spec.md). La constitución original tiene 14 reglas idénticas, 12 adaptadas y 1 reemplazada. El plan modifica 40/54 decisiones inventariadas.

## Ubicación y alcance

- Origen inmutable: rama sdd, commit 0e14e00ef58f9146f9c0f51ff5fadd30f599412f; feature 07_Participacion/divisor_cuenta/specs/001-dividir-cuenta.
- Copia Flutter de entrega: ../divisor_cuenta, creada desde ese commit, más el ajuste de pruebas. No sobrescribe la carpeta anterior de main.
- React local: divisor_cuenta_web, repositorio propio en main. Constitución: .specify/memory/constitution.md; feature: specs/001-dividir-cuenta.
- Publicación conjunta: main del repositorio existente; la fuente React se exporta también a ../divisor_cuenta_web_entrega, conservando el proyecto local independiente. El bundle Git acompaña su historial. No hay necesidad de crear una rama feature.
- SPECIFY_FEATURE_DIRECTORY: specs/001-dividir-cuenta; se configura en ../ejecutar.ps1 y queda persistido por los scripts de Spec Kit. La spec aún dice sdd porque identifica su origen.
- No se ejecutó speckit-specify. Las skills se ejecutan por el agente, no son ejecutables de shell que generen automáticamente la app. Scripts y reportes prueban las fases.

## 1. ¿Qué porcentaje viajó intacto, adaptado o no reusable?

Intacto **100% (64/64)**; adaptado **0%**; no reusable **0%**. Todos los enunciados inventariados describen entradas, resultados, restricciones de producto, validación o criterios ejecutables. Ninguno exige Flutter, Dart, Riverpod ni widgets. La fecha y Feature Branch=sdd son metadatos de origen, no decisiones de implementación; se excluyen del denominador y se conservan en el archivo.

El método cuenta enunciados atómicos por aparición, divide obligaciones independientes y no deduplica reglas repetidas entre FR, Edge Cases y SC. Otra deduplicación cambiaría el denominador, pero aquí seguiría siendo 100% reusable porque ninguna obligación depende de Flutter. %CÓMO = 0/64 × 100 = 0%. No supera el 30%, **umbral pedagógico del deber**, no una regla universal.

Evidencia: diff inicial y final sin salida, código 0, archivos de diff de 0 bytes; comparación adicional del objeto Git inicial 6cce762 contra sdd idéntica; SHA256 de ambas copias igual. El tiempo 10.15 min es contexto descriptivo: no mide calidad ni demuestra que SDD sea más rápido que otro enfoque. No existe cronómetro Flutter histórico comparable.

## 2. Constitution: regla por regla

La tabla completa C01-C27 de [analisis_spec.md](analisis_spec.md) cita cada regla original y la redacción React. Resultado: **14/27 idénticas (51.85%)**, **12/27 adaptadas (44.44%)** y **1/27 reemplazada (3.70%)**. Modificadas: 13/27. Las cifras corresponden a la Constitution original 1.0.0 de sdd, preservada en evidencias/constitution-flutter-original.md, no a la aclaración posterior del runner web en la copia Flutter.

Ejemplos: «presentation depende de domain, nunca de data» y «No guardar secretos ni API keys» permanecen idénticas. «domain no importa package:flutter ni data» se adapta a «src/domain no importa react, DOM ni data; es JavaScript puro». «main.dart es el único punto...» pasa a src/main.jsx. «redondear(double importe)» pasa al contrato aplicar(valor), con una sola operación. No desaparecen SRP, OCP, LSP, ISP ni DIP.

La regla «El SDK y sus dependencias generadas son la base; no agregar paquetes externos» se reemplaza por el stack React/Vite/Vitest/Testing Library/jsdom exigido y la prohibición de librerías externas de estado. Mantener literalmente esa prohibición impediría cumplir el deber. La constitución React es 2.0.0 por esta sustitución incompatible. La copia Flutter añade una excepción de desarrollo en 1.0.1 para package:test; no cambia producto ni reglas de negocio. No se introducen principios nuevos de producto sin equivalente; el catálogo explicativo responde a la regla de la materia.

## 3. ¿Se modificó algún enunciado de la spec?

No. Se conservaron los bytes de la spec y su significado. El cálculo, los mensajes, la pantalla única y los modos de redondeo no dependen de tecnología. React implementa las decisiones en plan y código. No hay commit de adaptación de spec porque no hubo adaptación. La presencia de sdd como metadato no es contradicción con trabajar en main, y el análisis lo documenta.

Los inconvenientes encontrados pertenecen al CÓMO: runner Flutter bloqueado, assets CanvasKit y herramientas Node/npm. Se resolvieron en configuración y scripts; no se alteraron los seis escenarios para conseguir pruebas verdes. El historial conserva el commit de copia 6cce762 y el plan 8731e80. Evidencia de identidad en evidencias/spec-inicial-historial.txt y evidencias/spec-identidad.txt.

## 4. Los seis casos en Flutter y React

| Caso | Monto / personas / propina / modo | Esperado Flutter | Esperado React | Cambió |
|---|---|---|---|---|
| 1. reparto normal | 100 / 4 / 10 / exacto | 27.50 | 27.50 | No |
| 2. sin propina | 90 / 3 / 0 / exacto | 30.00 | 30.00 | No |
| 3. cero personas | 50 / 0 / 0 / exacto | Debe haber al menos una persona | Debe haber al menos una persona | No |
| 4. monto no numerico | NaN / 4 / 0 / exacto | Monto inválido | Monto inválido | No |
| 5. redondeo exacto | 10 / 3 / 0 / exacto | 3.33 | 3.33 | No |
| 6. redondeo hacia arriba | 10 / 3 / 0 / arriba | 4.00 | 4.00 | No |


No cambió entrada, valor esperado, mensaje ni escenario. double.nan de Dart se representa como NaN en JavaScript; es una traducción sintáctica, no otra regla. Una comprobación automatizada parseó casos-flutter.dart, importó casosDePrueba.js y comparó los seis objetos; evidencia comparacion-casos.json con iguales=true. Las suites verifican 27.50, 30.00, 3.33, 4.00 y los dos mensajes exactos. Las pruebas de errores comprueban también que no se invoca calcular.

La guía pide que el estudiante escriba a mano ese archivo y el análisis. En esta entrega los produjo el agente según la solicitud del usuario: **0 líneas manuales del estudiante**. Deben revisarse y explicarse personalmente; no se presenta la autoría manual como un dato observado.

## 5. ¿Qué partes del plan Flutter ya no sirven?

1. **Dart/Flutter y widgets**: .dart, MaterialApp y widgets se sustituyen por módulos .js, JSX y el DOM de React. El plan apunta al navegador, no a Android.
2. **setState y DivisorController por constructor**: useDivisor usa useState y recibe servicios ordinarios. PantallaDivisor importa el hook estáticamente; main.jsx compone estrategias y servicios. No se inyecta el hook como prop.
3. **flutter_test/test_api**: Vitest ejecuta dominio; Testing Library interactúa con controles accesibles en jsdom. Se añaden setupFiles y jest-dom, conservando los datos de los seis casos.
4. **Interfaz Dart redondear(double)**: JavaScript usa el contrato estructural aplicar(valor). La calculadora depende de esa operación y no reconoce clases concretas.
5. **lib/ y main.dart**: src/domain, src/data, src/presentation y main.jsx conservan la dirección de dependencias pero cambian rutas y composición.
6. **Herramientas y empaquetado**: Flutter produce APK; npm run build produce dist/ para web. Node ejecuta herramientas; no se añadió backend.

El inventario P01-P54 está en [analisis_plan.md](analisis_plan.md): **40/54 decisiones modificadas**, 14 intactas. El diff físico tiene **50 líneas añadidas y 44 eliminadas**. No se equiparan estas operaciones a decisiones atómicas: la guía usa ambos términos, por eso se informan separadamente. Sobreviven cálculo puro, almacenamiento ausente, rendimiento constante, alcance y varias comprobaciones SOLID; cambia sobre todo cómo se materializan.

## 6. Artefacto más y menos reusable

La **spec** fue el artefacto físico más reusable: copia idéntica, diff vacío y 64/64 enunciados intactos. Los **escenarios de prueba** empatan en significado: mismos seis objetos comparados y resultados verdes. El archivo runner no viaja byte por byte porque la sintaxis cambia.

El **código de implementación** fue el menos reusable físicamente: se reescribieron módulos Dart como JavaScript/JSX y controles Flutter como DOM. Se reutilizan las fórmulas y responsabilidades, pero no los archivos ejecutables. Entre los documentos de diseño, plan y tasks son los menos portables: el inventario del plan modifica 40/54 decisiones y las tareas nombran archivos/herramientas distintos. La constitución queda en medio: preserva principios pero adapta lenguaje y una restricción de dependencias.

Esta evidencia apoya la hipótesis de separación QUÉ/CÓMO **en este repositorio**, no demuestra una superioridad universal ni una diferencia temporal contra vibe coding. Haría falta otra ejecución comparable con criterios y registro iguales para esa conclusión.

## Bitácora y límites de medición

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



Inicio: 2026-10-06 10:26:00; build: 2026-10-06 10:35:50; fin: 2026-10-06 10:36:09, UTC-5. Se tomó la ejecución inicial de planificación como equivalente al envío del prompt porque el usuario pidió todo en un solo mensaje. Los tiempos individuales de los runners no son el cronómetro. No hubo mensajes correctivos posteriores del usuario. Ver [bitacora.md](bitacora.md) para el registro íntegro.

Limitación de orden: la suite Flutter completa pudo ejecutarse tras resolver Windows y CanvasKit durante el avance React; antes de planificar sí se habían verificado seis casos y LSP en Dart puro. Se informa esa desviación del orden indicado, sin atribuir un All tests passed previo que no ocurrió. Al entregar, ambas suites están comprobadas. El bloqueo nativo de Windows sigue aplicando; se usa la alternativa web reproducible.

## Evidencias y checklist de entrega

- Spec inicial/final sin cambios; hashes e historial preservados.
- Análisis de spec y Constitution, plan nuevo y tasks trazables.
- analyze ejecutado; converge disponible y ejecutado, con limpieza de restos Vite en T019 y pasada final registrada.
- No nueva spec ni nuevas reglas de negocio; Node 24.19.0 cumple requisito. [Vite](https://vite.dev/guide/) documenta Node 20.19+/22.12+; [Node releases](https://nodejs.org/en/about/previous-releases) permite consultar soporte vigente.
- React: 36/36; build correcto; dominio sin React/DOM/data; concrete strategies solo data/main; errores impiden cálculo.
- Flutter SDD: 18/18 en Chrome; script para repetir prueba y excepción de dependencia documentados.
- Navegador real: desktop/móvil sin desbordamiento, cálculo offline y sin errores JS.
- main local y exportación para publicación GitHub. Estado real de publicación en ../publicacion.md; no se declara subida antes de verificar remoto.
- Pendiente personal: revisar el análisis y las pruebas solicitadas a mano y poder explicar las funciones.

## Salidas completas relevantes

### spec-identidad.txt

```text
Comando: git diff --no-index -- <Flutter>/specs/001-dividir-cuenta/spec.md <React>/specs/001-dividir-cuenta/spec.md
Exit code: 0
stdout: vacío (0 bytes)

SHA256:
divisor_cuenta\specs\001-dividir-cuenta\spec.md: a2b5bedfb7e20ca617724d5c0aca02014b82d3162ad733813779974984fa33a8
divisor_cuenta_web\specs\001-dividir-cuenta\spec.md: a2b5bedfb7e20ca617724d5c0aca02014b82d3162ad733813779974984fa33a8
```

### spec-inicial-historial.txt

```text
Comparación de objetos Git: sdd:07_Participacion/divisor_cuenta/specs/001-dividir-cuenta/spec.md y React 6cce762:specs/001-dividir-cuenta/spec.md
Resultado: contenido idéntico. No se regeneró la spec.
SHA256 Git normalizado: a4226f2fca6e00e8a4b760d2e6891f849179b3e6299b1d68c26bcc11141508f4
```

### flutter-dominio.txt

```text
PASS 1. reparto normal
PASS 2. sin propina
PASS 3. cero personas
PASS 4. monto no numerico
PASS 5. redondeo exacto
PASS 6. redondeo hacia arriba
PASS LSP; 7 comprobaciones Dart puro
```

### flutter-web.txt

```text
00:00 +0: loading C:/Programacion de apps/07_Participacion/divisor_cuenta/test/division_test.dart
00:00 +0: test\division_test.dart: 1. reparto normal
00:00 +1: test\division_test.dart: 2. sin propina
00:00 +2: test\division_test.dart: 3. cero personas
00:00 +3: test\division_test.dart: 4. monto no numerico
00:00 +4: test\division_test.dart: 5. redondeo exacto
00:00 +5: test\division_test.dart: 6. redondeo hacia arriba
00:00 +6: test\division_test.dart: LSP: mismo cálculo, estrategias sustituibles sin casts
00:00 +7: loading C:/Programacion de apps/07_Participacion/divisor_cuenta/test/entrada_test.dart
00:07 +7: test\entrada_test.dart: Cero es válido
00:07 +8: test\entrada_test.dart: Punto y coma decimal tienen igual resultado
00:07 +9: test\entrada_test.dart: Negativos y valores no finitos se rechazan
00:07 +10: test\entrada_test.dart: Personas fraccionarias y vacías se rechazan
00:07 +11: test\entrada_test.dart: Error posterior borra resultado anterior
00:07 +12: test\entrada_test.dart: Campos vacíos e importe excesivo no producen resultado
00:07 +13: loading C:/Programacion de apps/07_Participacion/divisor_cuenta/test/pantalla_test.dart
00:14 +13: test\pantalla_test.dart: 100, 4, 10 muestra 27.50
00:15 +14: test\pantalla_test.dart: 50 y cero personas muestra error sin resultado
00:16 +15: test\pantalla_test.dart: abc muestra Monto inválido
00:16 +16: test\pantalla_test.dart: Selector hacia arriba muestra 4.00
00:17 +17: test\pantalla_test.dart: La composición real inicia la pantalla
00:17 +18: All tests passed!
```

### dominio-react.txt

```text

 RUN  v5.0.3 C:/Programacion de apps/Deberes/Deber 2/divisor_cuenta_web

 ✓ test/division.test.js > Seis casos de aceptación de la spec > 1. reparto normal 4ms
 ✓ test/division.test.js > Seis casos de aceptación de la spec > 2. sin propina 0ms
 ✓ test/division.test.js > Seis casos de aceptación de la spec > 3. cero personas 1ms
 ✓ test/division.test.js > Seis casos de aceptación de la spec > 4. monto no numerico 0ms
 ✓ test/division.test.js > Seis casos de aceptación de la spec > 5. redondeo exacto 1ms
 ✓ test/division.test.js > Seis casos de aceptación de la spec > 6. redondeo hacia arriba 1ms
 ✓ test/division.test.js > LSP: el mismo cálculo sustituye estrategias sin comprobar su tipo 0ms

 Test Files  1 passed (1)
      Tests  7 passed (7)
   Start at  10:36:06
   Duration  3.21s (environment 78%, setup 14%, transform 6%, worker 1%, import 1%)
```

### tests-react.txt

```text
npm notice run divisor_cuenta_web@0.0.0 test
npm notice run vitest run --reporter=verbose

 RUN  v5.0.3 C:/Programacion de apps/Deberes/Deber 2/divisor_cuenta_web

 ✓ test/entrada.test.js > validación de 0/1/0 3ms
 ✓ test/entrada.test.js > validación de -1/1/0 0ms
 ✓ test/entrada.test.js > validación de Infinity/1/0 0ms
 ✓ test/entrada.test.js > validación de 1/0/0 0ms
 ✓ test/entrada.test.js > validación de 1/2.5/0 0ms
 ✓ test/entrada.test.js > validación de 1/1/-1 0ms
 ✓ test/entrada.test.js > validación de 1/1/NaN 0ms
 ✓ test/entrada.test.js > validación de NaN/0/-1 0ms
 ✓ test/entrada.test.js > formato grande conserva dos decimales sin exponente 26ms
 ✓ test/division.test.js > Seis casos de aceptación de la spec > 1. reparto normal 4ms
 ✓ test/division.test.js > Seis casos de aceptación de la spec > 2. sin propina 1ms
 ✓ test/division.test.js > Seis casos de aceptación de la spec > 3. cero personas 1ms
 ✓ test/division.test.js > Seis casos de aceptación de la spec > 4. monto no numerico 0ms
 ✓ test/division.test.js > Seis casos de aceptación de la spec > 5. redondeo exacto 0ms
 ✓ test/division.test.js > Seis casos de aceptación de la spec > 6. redondeo hacia arriba 0ms
 ✓ test/division.test.js > LSP: el mismo cálculo sustituye estrategias sin comprobar su tipo 0ms
 ✓ test/pantalla.test.jsx > Tres pruebas obligatorias de pantalla > 100, 4, 10 muestra 27.50 263ms
 ✓ test/pantalla.test.jsx > Tres pruebas obligatorias de pantalla > cero personas muestra error sin resultado y sin calcular 37ms
 ✓ test/pantalla.test.jsx > Tres pruebas obligatorias de pantalla > abc muestra Monto inválido 27ms
 ✓ test/pantalla.test.jsx > Aclaraciones y transiciones de la spec > cero y coma decimal se aceptan 45ms
 ✓ test/pantalla.test.jsx > Aclaraciones y transiciones de la spec > monto  se rechaza sin calcular 24ms
 ✓ test/pantalla.test.jsx > Aclaraciones y transiciones de la spec > monto -1 se rechaza sin calcular 24ms
 ✓ test/pantalla.test.jsx > Aclaraciones y transiciones de la spec > monto 12abc se rechaza sin calcular 25ms
 ✓ test/pantalla.test.jsx > Aclaraciones y transiciones de la spec > monto Infinity se rechaza sin calcular 24ms
 ✓ test/pantalla.test.jsx > Aclaraciones y transiciones de la spec > monto 1,000.00 se rechaza sin calcular 23ms
 ✓ test/pantalla.test.jsx > Aclaraciones y transiciones de la spec > monto 0x10 se rechaza sin calcular 24ms
 ✓ test/pantalla.test.jsx > Aclaraciones y transiciones de la spec > personas  se rechaza 24ms
 ✓ test/pantalla.test.jsx > Aclaraciones y transiciones de la spec > personas -1 se rechaza 23ms
 ✓ test/pantalla.test.jsx > Aclaraciones y transiciones de la spec > personas 2.5 se rechaza 21ms
 ✓ test/pantalla.test.jsx > Aclaraciones y transiciones de la spec > personas abc se rechaza 22ms
 ✓ test/pantalla.test.jsx > Aclaraciones y transiciones de la spec > propina  se rechaza 25ms
 ✓ test/pantalla.test.jsx > Aclaraciones y transiciones de la spec > propina -1 se rechaza 23ms
 ✓ test/pantalla.test.jsx > Aclaraciones y transiciones de la spec > propina abc se rechaza 25ms
 ✓ test/pantalla.test.jsx > Aclaraciones y transiciones de la spec > edición y modo eliminan resultado; hacia arriba devuelve 4.00 37ms
 ✓ test/pantalla.test.jsx > Aclaraciones y transiciones de la spec > un error tras un resultado lo elimina y corregirlo vuelve a calcular 47ms
 ✓ test/pantalla.test.jsx > Aclaraciones y transiciones de la spec > desbordamiento muestra mensaje sin invocar cálculo 21ms

 Test Files  3 passed (3)
      Tests  36 passed (36)
   Start at  10:36:34
   Duration  4.27s (environment 70%, setup 13%, tests 9%, transform 5%, import 3%, worker 1%)
```

### solid-react.txt

```text
PASS DIP: domain sin React, DOM ni data; presentation sin data
PASS composición: estrategias concretas solo en data y main.jsx
PASS OCP/LSP: cálculo sin comprobaciones de tipo o modo
PASS SRP: cálculo sin validación ni formato
```

### navegador-react.txt

```text
PASS navegador real: 27.50, 4.00 y Monto inválido
PASS cálculo con red desactivada
PASS viewport 390px sin desbordamiento horizontal
PASS sin errores JavaScript
```

### build-primero.txt

```text
npm notice run divisor_cuenta_web@0.0.0 build
npm notice run vite build
vite v8.3.3 building client environment for production...
transforming...
✓ 24 modules transformed.
rendering chunks...
computing gzip size...
dist/index.html                   0.55 kB │ gzip:  0.34 kB
dist/assets/index-DwJIqBLg.css    2.10 kB │ gzip:  0.91 kB
dist/assets/index-Q2Ky4kqc.js   223.69 kB │ gzip: 70.07 kB

✓ built in 2.34s
```

### plan.diff

```text
diff --git a/evidencias/plan-flutter.md b/specs/001-dividir-cuenta/plan.md
index 093dbf3..938e62d 100644
--- a/evidencias/plan-flutter.md
+++ b/specs/001-dividir-cuenta/plan.md
@@ -1,67 +1,73 @@
-# Implementation Plan: Dividir cuenta
-**Branch**: `sdd` | **Date**: 2026-10-01 | **Spec**: [spec.md](spec.md)
-**Input**: especificación aclarada del divisor.
+# Implementation Plan: Dividir cuenta en React
+**Branch**: `main` | **Date**: 2026-10-06 | **Spec**: [spec.md](spec.md)
+**Input**: copia idéntica de la especificación aclarada Flutter sdd.
 
 ## Summary
-Flutter estable, una pantalla, setState y dependencias por constructor.
+React con Vite, JavaScript, una pantalla y estado local con useState.
 Cálculo puro y estrategia de redondeo intercambiable.
 
 ## Technical Context
-**Language/Version**: Dart 3.13.1, Flutter 3.47.1 estable.
-**Primary Dependencies**: SDK Flutter y dependencias de plantilla, sin paquetes adicionales.
+**Language/Version**: JavaScript ES modules; Node v24.19.0.
+**Primary Dependencies**: React 19, React DOM 19, Vite 8, sin librerías externas de estado.
 **Storage**: ninguno.
-**Testing**: flutter_test para widgets; test_api (dependencia del SDK) para dominio sin widgets.
-**Target Platform**: Android y web para verificación alternativa.
-**Project Type**: app móvil de una pantalla.
+**Testing**: Vitest; Testing Library y jest-dom para pantalla; jsdom como entorno.
+**Target Platform**: navegador web moderno.
+**Project Type**: página web estática de una pantalla.
 **Performance Goals**: cálculo síncrono constante, sin operaciones de red.
-**Constraints**: offline; no modificar android/ios ni agregar paquetes.
+**Constraints**: offline durante el uso; sin almacenamiento, login, historial ni backend.
 **Scale/Scope**: tres entradas, dos modos, un resultado.
 
 ## Constitution Check
-Antes y después del diseño: SRP cálculo/validación/formato separados; OCP interfaz;
-LSP sin cast; ISP un método; DIP presentación solo dominio; composición en main.
-Objetos de valor y widgets pueden construirse en sus consumidores.
-Las pruebas de dominio importan test_api y no flutter_test: no dependen del motor.
+Antes y después del diseño: SRP cálculo/validación/formato separados; OCP contrato;
+LSP sin cast; ISP aplicar(valor); DIP presentación solo dominio; composición en main.jsx.
+Objetos de valor y elementos JSX pueden construirse en sus consumidores.
+Dominio JavaScript puro, sin React, DOM ni data.
 No secretos, persistencia ni red. Casos críticos convertidos en pruebas.
+Gate previo y posterior al diseño: PASS; no contradicción de la spec con React.
+La constitución reemplaza explícitamente la prohibición de paquetes Flutter por el stack requerido.
 
 ## Project Structure
 ```text
-lib/
-  domain/cuenta.dart
-  domain/resultado.dart
-  domain/estrategia_redondeo.dart
-  domain/calcular_division.dart
-  domain/validar_entrada.dart
-  data/redondeo_exacto.dart
-  data/redondeo_hacia_arriba.dart
-  presentation/divisor_controller.dart
-  presentation/formateador_moneda.dart
-  presentation/pantalla_divisor.dart
-  main.dart
+src/
+  domain/cuenta.js
+  domain/resultado.js
+  domain/estrategiaRedondeo.js
+  domain/calcularDivision.js
+  domain/validarEntrada.js
+  data/redondeoExacto.js
+  data/redondeoHaciaArriba.js
+  presentation/useDivisor.js
+  presentation/formateadorMoneda.js
+  presentation/PantallaDivisor.jsx
+  presentation/estilos.css
+  main.jsx
 test/
-  casos_de_prueba.dart
-  division_test.dart
-  pantalla_test.dart
-  entrada_test.dart
+  setup.js
+  casosDePrueba.js
+  division.test.js
+  pantalla.test.jsx
+  entrada.test.js
 tool/
-  verificar_domain.dart
+  verificarArquitectura.js
 ```
-**Structure Decision**: estructura solicitada, más pruebas de aclaraciones y comprobador
-Dart puro por el bloqueo de flutter_tester.exe.
+**Structure Decision**: mismas responsabilidades, rutas src y archivos JavaScript/JSX.
+Sin servidor, llamadas de red en runtime ni persistencia.
 
 ## Phase 0: Research
-Ver [research.md](research.md). No desconocidos pendientes.
+Ver [research.md](research.md). Stack definido por la guía; no desconocidos pendientes.
 ## Phase 1: Design
 Ver [data-model.md](data-model.md), [contracts/ui.md](contracts/ui.md) y [quickstart.md](quickstart.md).
-Controller convierte texto, invoca validación, delega cálculo a la estrategia elegida y expone
-error/resultado. Pantalla recibe controller y formateador por constructor.
-main crea validación, cálculo, estrategias, controller y formateador.
-ValidarEntrada devuelve String?; null significa válido.
-RedondeoExacto usa (importe * 100).round() / 100.
-CalcularDivision devuelve Resultado sin validar o formatear.
-Controller rechaza desbordamientos antes de invocar CalcularDivision.
+useDivisor convierte texto, valida, delega cálculo y expone error/resultado mediante useState.
+La pantalla importa el hook estáticamente y recibe servicios ordinarios como dependencias.
+main.jsx crea validación, cálculo, estrategias y formateador y los inyecta en la pantalla.
+validarEntrada devuelve string o null; null significa válido.
+redondeoExacto usa Math.round(valor * 100) / 100; hacia arriba usa Math.ceil(valor).
+calcularDivision devuelve resultado sin validar ni formatear y llama estrategia.aplicar(valor).
+El hook comprueba finitud de importe e importe * 100 antes de calcular, como el controller Flutter.
+La conversión rechaza texto vacío, hexadecimales, separadores de miles y sufijos no numéricos.
+La edición y el cambio de modo eliminan el resultado anterior.
+El formateador garantiza dos decimales, también para importes >= 1e21 sin notación exponencial.
 
 ## Complexity Tracking
-Sin infracciones aceptadas. El bloqueo del motor nativo requiere verificación alternativa:
-intentar flutter test --platform chrome y ejecutar el comprobador puro con dart.
-
+Sin infracciones aceptadas. Windows bloquea flutter_tester.exe; validación Flutter web registrada
+por separado y no asumida a partir de los resultados React.
```

### constitution.diff

```text
diff --git a/evidencias/constitution-flutter-original.md b/.specify/memory/constitution.md
index 032c3e2..f697482 100644
--- a/evidencias/constitution-flutter-original.md
+++ b/.specify/memory/constitution.md
@@ -1,45 +1,50 @@
-# Divisor de cuenta Constitution
+# Divisor de cuenta web Constitution
 
 ## Core Principles
 
 ### I. SRP — responsabilidad única
-Cada clase tiene una razón de cambio. CalcularDivision únicamente aplica la fórmula y delega
-el redondeo: no valida ni formatea. ValidarEntrada valida y FormateadorMoneda formatea.
+Cada función o módulo tiene una razón de cambio.
+calcularDivision únicamente aplica la fórmula y delega el redondeo: no valida ni formatea.
+validarEntrada valida y formateadorMoneda formatea.
 
 ### II. OCP — abierto a extensión
-Una nueva regla de redondeo se agrega implementando EstrategiaRedondeo en un archivo nuevo.
-No se modifican CalcularDivision ni las estrategias existentes.
+Una nueva regla de redondeo se agrega implementando el contrato estrategiaRedondeo en un archivo nuevo.
+No se modifican calcularDivision ni las estrategias existentes.
 
 ### III. LSP — sustitución
-Todas las estrategias reciben un importe finito no negativo y devuelven un importe finito
-no negativo. El consumidor usa la interfaz sin if de tipo ni casts concretos.
+Todas las estrategias reciben un importe finito no negativo y devuelven un importe finito no negativo.
+El consumidor usa la interfaz sin if de tipo ni casts concretos.
 Una prueba debe intercambiar exacto y hacia arriba en el mismo caso de uso.
 
 ### IV. ISP — interfaz pequeña
-EstrategiaRedondeo declara únicamente redondear(double importe). No incluye validación,
-formateo, persistencia ni métodos ajenos al redondeo.
+estrategiaRedondeo declara únicamente aplicar(valor).
+No incluye validación, formateo, persistencia ni métodos ajenos al redondeo.
 
 ### V. DIP — inversión de dependencias
-presentation depende de domain, nunca de data. domain no importa package:flutter ni data.
-main.dart es el único punto que instancia implementaciones concretas y conecta dependencias.
-Se permite instanciar objetos de valor Cuenta y Resultado donde corresponde y widgets
-en la presentación; la regla de composición se aplica a servicios y estrategias inyectables.
+presentation depende de domain, nunca de data.
+src/domain no importa react, DOM ni data; es JavaScript puro.
+src/main.jsx es el único punto que instancia implementaciones concretas y conecta dependencias.
+Se permite crear objetos de valor cuenta y resultado donde corresponde y elementos JSX en presentación; la regla de composición se aplica a servicios y estrategias inyectables.
 
 ## Arquitectura y seguridad
-Capas obligatorias: presentation -> domain <- data. Dominio Dart puro.
-No guardar secretos ni API keys. Una pantalla sin red ni base de datos.
-El SDK y sus dependencias generadas son la base; no agregar paquetes externos.
+Capas obligatorias: src/presentation -> src/domain <- src/data.
+Dominio JavaScript puro.
+No guardar secretos ni API keys.
+Una pantalla sin red ni base de datos.
+Usar React con Vite, Vitest, Testing Library y jsdom; sin librerías de estado externas.
 
 ## Calidad, pruebas y regla de la materia
 Los seis criterios de aceptación se traducen a pruebas ejecutables y separadas de sus datos.
-Incluir la prueba LSP y las tres pruebas de widget solicitadas.
+Incluir la prueba LSP y las tres pruebas de pantalla solicitadas con Testing Library.
 Toda función generada debe ser explicable: propósito, entrada, salida y errores.
 Los errores de validación deben impedir el cálculo y ocultar cualquier resultado anterior.
 
 ## Governance
-La constitución rige spec, plan, tareas y código. Ante un incumplimiento se corrige primero
-el artefacto que define la regla. Revisar el cumplimiento antes y después de implementar.
+La constitución rige spec, plan, tareas y código.
+Ante un incumplimiento se corrige primero el artefacto que define la regla.
+Revisar el cumplimiento antes y después de implementar.
 Cambios de principios incompatibles aumentan MAJOR; ampliaciones MINOR; aclaraciones PATCH.
-Esta versión inicial concreta únicamente las reglas del enunciado.
-**Version**: 1.0.0 | **Ratified**: 2026-10-01 | **Last Amended**: 2026-10-01
 
+**Version**: 2.0.0 | **Ratified**: 2026-10-01 | **Last Amended**: 2026-10-06
+
+Versión MAJOR por reemplazar la restricción de dependencias del SDK Flutter por el stack React autorizado. Principios SOLID y comportamiento conservados.
```

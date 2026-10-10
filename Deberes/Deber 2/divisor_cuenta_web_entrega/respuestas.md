# Respuestas del Deber 2

César Martínez - Programación Asistida de Aplicaciones

En esta práctica se pasó el divisor de cuenta de Flutter a React. La idea fue mantener lo que hace la aplicación y cambiar la forma de construirla. El trabajo se realizó con ayuda de Codex.

## 1. ¿Qué porcentaje de la spec se pudo reutilizar?

Se pudo reutilizar el **100%: 64 de 64 enunciados**. No hubo que adaptar ninguno y tampoco se descartó ninguno.

Esto fue posible porque la spec explica lo que debe hacer la aplicación: dividir la cuenta, agregar la propina, validar los datos y mostrar el resultado. No obliga a usar Flutter. Al comparar los archivos, el diff salió vacío, es decir, no encontró cambios.

En [analisis_spec.md](analisis_spec.md) está la clasificación completa. Se contaron las reglas por cada aparición, incluyendo las que se repiten en otras secciones; no se contaron títulos ni fechas. Todas quedaron como QUÉ y ninguna como CÓMO o MIXTO. Por eso, el CÓMO fue 0% y no superó el 30% que menciona el deber. Ese 30% es una referencia de la práctica, no una regla general.

El primer build tardó **9 min 50 s** y los seis casos pasaron a los **10 min 9 s**. Estos tiempos sirven como referencia, pero por sí solos no dicen si el trabajo es mejor.

## 2. ¿Qué pasó con las reglas de la Constitution?

La Constitution es el documento con las reglas para organizar el proyecto. De sus 27 reglas:

| Clasificación | Cantidad | Porcentaje |
|---|---:|---:|
| Idénticas | 14 | 51.85% |
| Adaptadas en redacción | 12 | 44.44% |
| Reemplazadas | 1 | 3.70% |

Se mantuvieron reglas como separar las responsabilidades y no guardar contraseñas en el código. Otras cambiaron de nombres: por ejemplo, `main.dart` pasó a `main.jsx`, y la regla de no usar Flutter en los cálculos pasó a no usar React allí.

La regla que se reemplazó era la de no agregar paquetes externos. En React se necesitan las herramientas que pide el deber, como Vite y Vitest. Se conservaron los cinco principios SOLID, que ayudan a organizar el código y evitar que una parte haga todo.

La comparación **regla por regla, con el motivo de cada cambio**, está en [analisis_spec.md](analisis_spec.md), tabla C01-C27. Allí se comparan la [Constitution original de Flutter](evidencias/constitution-flutter-original.md) y la [Constitution de React](.specify/memory/constitution.md). Se usó la versión original de Flutter, anterior al ajuste para probarlo en Windows.

## 3. ¿Se modificó algún enunciado de la spec?

No se modificó ninguno. La spec ya separaba lo que debía hacer la aplicación de la tecnología utilizada. La fórmula, las validaciones y los mensajes sirven tanto en Flutter como en React.

Los problemas con las herramientas se resolvieron en la configuración, sin cambiar los requisitos para que las pruebas pasaran. La comparación está en [spec-identidad.txt](evidencias/spec-identidad.txt) y la copia inicial se comprueba en [spec-inicial-historial.txt](evidencias/spec-inicial-historial.txt). No se volvió a generar la spec.

## 4. ¿Cambiaron los seis casos de aceptación?

No. Se probaron las mismas entradas y se obtuvieron los mismos resultados en los dos proyectos.

| Caso | Datos: monto / personas / propina / modo | Flutter y React |
|---|---|---|
| Repartir con propina | 100 / 4 / 10 / exacto | 27.50 |
| Repartir sin propina | 90 / 3 / 0 / exacto | 30.00 |
| Cero personas | 50 / 0 / 0 / exacto | Debe haber al menos una persona |
| Monto que no es un número | NaN / 4 / 0 / exacto | Monto inválido |
| Redondeo exacto | 10 / 3 / 0 / exacto | 3.33 |
| Redondeo hacia arriba | 10 / 3 / 0 / arriba | 4.00 |

`NaN` representa un dato que no es un número. Cambió la forma de escribir las pruebas por el lenguaje, pero no los casos ni los mensajes. La comparación quedó guardada en [comparacion-casos.json](evidencias/comparacion-casos.json).

## 5. ¿Qué partes del plan de Flutter cambiaron en React?

Estos son algunos cambios concretos:

1. **La pantalla:** los widgets de Flutter se cambiaron por componentes de React. Se mantuvieron los campos y el botón para calcular.
2. **Los datos de la pantalla:** en Flutter se usaba `setState`; en React se usa `useState` para actualizar los campos y el resultado.
3. **Las pruebas:** se cambió la herramienta de Flutter por Vitest y Testing Library. Los seis casos se mantuvieron.
4. **La organización de archivos:** `lib/` pasó a `src/` y `main.dart` pasó a `main.jsx`. Se siguieron separando la pantalla, los cálculos y las formas de redondear.
5. **La compilación:** en React se usa `npm run build` para preparar la aplicación web.

En total cambiaron **40 de 54 decisiones** del plan y se mantuvieron 14. La comparación del archivo muestra **50 líneas agregadas y 44 eliminadas**. Las líneas y las decisiones se cuentan por separado, porque una decisión puede ocupar varias líneas. El detalle está en [analisis_plan.md](analisis_plan.md).

## 6. ¿Qué fue lo más y lo menos reutilizable?

Lo más reutilizable fue la **spec**, porque se copió sin cambiar nada. El [diff vacío](evidencias/spec-identidad.txt) y la [comparación de la copia inicial en Git](evidencias/spec-inicial-historial.txt) lo comprueban. Los seis casos también se mantuvieron, como muestra la [comparación entre Flutter y React](evidencias/comparacion-casos.json).

Lo menos reutilizable fue el **código de la aplicación**, porque Flutter usa Dart y React usa JavaScript. Se conservaron la fórmula y la idea del funcionamiento, pero se tuvo que escribir otra vez la pantalla y adaptar los archivos. Entre los documentos, el plan fue de los que más cambiaron: 40 de sus 54 decisiones.

Un ejemplo del cambio de código es [CalcularDivision en Flutter](../divisor_cuenta/lib/domain/calcular_division.dart) frente a [calcularDivision en React](src/domain/calcularDivision.js): conservan la fórmula, pero usan otro lenguaje. El [diff del plan](evidencias/plan.diff) muestra los cambios de herramientas y organización.

Esto muestra que, en este proyecto, separar lo que hace la aplicación de cómo se construye ayudó a cambiar de tecnología. No permite asegurar que siempre sea más rápido, porque no se registró el tiempo del laboratorio anterior.

## Bitácora y cronómetro

| Dato | Flutter | React |
|---|---|---|
| Tiempo hasta el primer build | No registrado | 9 min 50 s (9.83 min) |
| Tiempo hasta pasar los seis casos | No registrado | 10 min 9 s (10.15 min) |
| Mensajes correctivos después de la petición inicial | No registrado | 0 |
| Líneas de código añadidas directamente por el estudiante | No registrado | 0 |
| Enunciados de la spec modificados | No aplica | 0/64 |
| Reglas de la Constitution modificadas | No aplica | 13/27 |
| Decisiones del plan modificadas | No aplica | 40/54 |
| Líneas del diff del plan | No aplica | +50 / -44 |
| Casos de aceptación aprobados | 6/6 | 6/6 |
| Total de pruebas aprobadas | 18/18 | 36/36 |

El registro se tomó el **6 de octubre de 2026, hora de Ecuador (UTC-5)**:

- Inicio: **10:26:00**.
- Primer build correcto: **10:35:50**.
- Seis casos aprobados: **10:36:09**.

Se empezó a contar al iniciar la planificación, porque todo se pidió en un solo mensaje. No se inventaron tiempos del laboratorio anterior. El registro completo está en [bitacora.md](bitacora.md).

Las pruebas completas de Flutter se hicieron en Chrome por un problema del entorno de Windows. Antes de planificar React se comprobaron los seis casos y las pruebas de redondeo en Dart; las 18 pruebas de Flutter se completaron después, durante el trabajo de React. Ese orden fue distinto al indicado en la guía y queda aclarado aquí.

El trabajo se preparó con Codex. El registro de líneas añadidas directamente por el estudiante es **0**. Las correcciones posteriores de documentación no forman parte del cronómetro original.

## La práctica paso a paso

1. Se revisó el proyecto del laboratorio y sus documentos para entender el divisor de cuenta.
2. Se copiaron los requisitos a React sin cambiarlos y se comprobó que fueran iguales.
3. Se revisaron las reglas del proyecto y se adaptaron las que dependían de Flutter.
4. Se preparó el plan de React y la lista de tareas.
5. Se creó la pantalla y se separaron los cálculos de la parte visual.
6. Se probaron los seis casos, las formas de redondear y el funcionamiento de la pantalla.
7. Se comprobó que la aplicación compilara y se guardaron las mediciones y las evidencias. El trabajo quedó en `main`, como se pidió.

Para revisar la aplicación, desde la carpeta **Deber 2** se ejecuta `./ejecutar.ps1 dev`. Luego se abre la dirección que muestra la terminal. Por ejemplo, al ingresar monto **100**, personas **4** y propina **10**, el resultado debe ser **27.50** por persona en modo exacto.

## Cómo funciona cada parte

La pantalla recoge los datos. Luego se comprueban, se calcula el pago con el redondeo elegido y se muestra el importe con dos decimales. Si hay un error, aparece el mensaje y no se calcula.

| Función o parte | Para qué sirve | Qué recibe | Qué entrega o cambia | Errores y límites |
|---|---|---|---|---|
| `cuenta` | Reúne los datos de una cuenta. | Monto, personas y propina como números. | Un objeto con esos tres datos que no se modifica directamente. | No revisa los datos; eso corresponde a `validarEntrada`. |
| `resultado` | Guarda el pago calculado por persona. | Un importe. | Un objeto con el importe. | No valida ni agrega decimales. |
| `validarEntrada` | Comprueba los datos en orden: monto, personas y propina. | Una cuenta. | `null` si es válida; si no, el primer mensaje de error. | Rechaza monto o propina negativos o no finitos, y personas que no sean enteros positivos. |
| `calcularDivision` | Aplica monto × (1 + propina / 100) / personas y usa el redondeo elegido. | Una cuenta válida y una estrategia con `aplicar`. | Un resultado con el pago por persona. | No valida ni da formato. Recibe datos ya comprobados y una estrategia válida. |
| `redondeoExacto` y su `aplicar` | Redondean al centavo. | La función crea la estrategia; `aplicar` recibe el importe. | La estrategia devuelve, por ejemplo, 3.33 para 10/3. | Necesita un importe no negativo y finito cuyo valor por 100 también sea finito. |
| `redondeoHaciaArriba` y su `aplicar` | Suben al entero siguiente. | La función crea la estrategia; `aplicar` recibe el importe. | La estrategia devuelve, por ejemplo, 4 para 10/3. | Usa la misma condición de entrada que el modo exacto; un entero no aumenta. |
| `formateadorMoneda` | Prepara el número que ve el usuario. | Un importe válido. | Texto con dos decimales y punto, sin símbolo de moneda ni separadores de miles. | No revisa datos de entrada; también admite importes grandes sin mostrarlos como exponente. |
| `numero` | Convierte el texto de monto o propina a número. | Un texto. | Un número o `NaN` si no es válido. | Rechaza vacío, texto mezclado, hexadecimales y separadores de miles. Acepta coma o punto decimal. Luego se comprueba que el número sea finito. |
| `useDivisor` | Guarda los campos y coordina validación, cálculo y formato. | Las funciones de validar, calcular y formatear, y los dos redondeos. | Los campos, los eventos, el error y el resultado para la pantalla. | Los datos se mantienen solo mientras está abierta la aplicación. |
| `cambiar` | Actualiza un campo o el modo. | El nombre del campo y su nuevo valor. | Actualiza ese dato y borra el resultado y el error anteriores. | No calcula; el usuario debe pulsar Calcular otra vez. |
| `ejecutar` | Comprueba la entrada y calcula cuando es válida. | Los campos guardados en el estado. | Actualiza el resultado o muestra el error. | Detiene el cálculo si falla la validación, si el importe es demasiado grande o si el modo no existe. |
| `PantallaDivisor` | Muestra el formulario, el botón y la salida. | Las funciones y estrategias que vienen de `main.jsx`. | Los controles de React y los mensajes visibles. | Muestra el error que recibe de `useDivisor`; no aplica la fórmula. |
| Eventos del formulario | Conectan las acciones del usuario con el estado. | El cambio de un campo o el envío del formulario. | Llaman a `cambiar` o a `ejecutar`. | Al enviar se evita recargar la página. |
| Inicio en `main.jsx` | Conecta las partes y abre la pantalla. | Los servicios, estrategias y el elemento `root` del HTML. | La aplicación React dentro de `root`. | Necesita que exista ese elemento; no hace cálculos ni valida entradas. |
| `archivos` en la herramienta de arquitectura | Recorre las carpetas del código. | La ruta de una carpeta. | La lista de sus archivos, incluyendo subcarpetas. | Una ruta inexistente produce un error de lectura. Las comprobaciones posteriores detienen el comando si encuentran una dependencia prohibida. |
| `abrir` en las pruebas de pantalla | Prepara la pantalla para probarla. | No recibe argumentos. | Muestra la pantalla de prueba y devuelve una función que registra las llamadas al cálculo. | Una prueba falla si la pantalla no puede abrirse o su comportamiento no coincide. |
| `ingresar` en las pruebas de pantalla | Simula llenar los campos y pulsar Calcular. | Monto, personas y propina; la propina usa 0 si se omite. | Cambia los campos y envía el formulario. | La prueba falla si no encuentra un campo o el botón. |
| `ejecutar` en la prueba LSP | Usa el mismo cálculo con distintos redondeos. | Una estrategia. | El importe para la cuenta 10/3/0. | La prueba exige 3.33 con exacto y 4.00 con arriba. |

El [contrato de redondeo](src/domain/estrategiaRedondeo.js) indica que las dos estrategias ofrecen `aplicar(valor)`. No es una función adicional: permite que el cálculo use cualquiera de las dos de la misma forma.

Las funciones de [cálculo](src/domain/calcularDivision.js), [validación](src/domain/validarEntrada.js) y [formato](src/presentation/formateadorMoneda.js) están separadas. Los [dos](src/data/redondeoExacto.js) [redondeos](src/data/redondeoHaciaArriba.js) se conectan en [main.jsx](src/main.jsx), y [useDivisor](src/presentation/useDivisor.js) coordina la [pantalla](src/presentation/PantallaDivisor.jsx). Las pruebas están en [division.test.js](test/division.test.js), [entrada.test.js](test/entrada.test.js) y [pantalla.test.jsx](test/pantalla.test.jsx).

## Salidas completas relevantes

Este anexo conserva las salidas y comparaciones que pide el deber. La explicación sencilla está arriba; aquí quedan los detalles para comprobar los resultados.


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

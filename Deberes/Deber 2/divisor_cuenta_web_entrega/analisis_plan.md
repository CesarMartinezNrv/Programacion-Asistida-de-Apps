# Inventario de decisiones del plan

Para comparar los planes, conté cada decisión por separado. Por ejemplo, el lenguaje, las herramientas y la organización de archivos son decisiones distintas. Si una frase tiene varias decisiones, las separé. Las ideas repetidas se cuentan donde aparecen.

Las referencias a otros documentos no se cuentan aquí. Cada documento se revisa por separado. La tabla conserva los nombres de las herramientas y archivos para que se vea qué se mantuvo y qué cambió.

| ID | Flutter | React | Resultado |
|---|---|---|---|
| P01 | Flutter estable | React con Vite | reemplazado |
| P02 | Una pantalla | Una pantalla | intacto |
| P03 | setState | useState | reemplazado |
| P04 | Dependencias por constructor | Props y argumento del hook | adaptado |
| P05 | Cálculo puro | Cálculo puro | intacto |
| P06 | Estrategia de redondeo intercambiable | Estrategia de redondeo intercambiable | intacto |
| P07 | Dart 3.13.1 | JavaScript ES modules / Node 24.19.0 | reemplazado |
| P08 | Dependencias SDK Flutter, sin paquetes adicionales | React, Vite y herramientas de pruebas | reemplazado |
| P09 | Sin storage | Sin storage | intacto |
| P10 | flutter_test widgets | Testing Library + jsdom | reemplazado |
| P11 | test_api para dominio | Vitest para dominio | reemplazado |
| P12 | Android y web | Navegador web | reemplazado |
| P13 | App móvil | Página estática | reemplazado |
| P14 | Cálculo síncrono constante | Cálculo síncrono constante | intacto |
| P15 | Sin operaciones de red | Sin operaciones de red | intacto |
| P16 | Offline | Offline durante uso | intacto |
| P17 | No modificar android/ios | React no genera carpetas nativas | reemplazado |
| P18 | No agregar paquetes | Stack npm autorizado, sin librerías de estado | reemplazado |
| P19 | Tres entradas, dos modos y un resultado | Tres entradas, dos modos y un resultado | intacto |
| P20 | SRP separa cálculo/validación/formato | SRP separa cálculo/validación/formato | intacto |
| P21 | OCP usa interfaz Dart | OCP usa contrato estructural | adaptado |
| P22 | LSP sin casts | LSP sin casts | intacto |
| P23 | ISP un método | ISP aplicar(valor) | adaptado |
| P24 | DIP presentación solo dominio | DIP presentación solo dominio | intacto |
| P25 | Composición en main | Composición en main.jsx | adaptado |
| P26 | Objetos de valor y widgets en consumidores | Objetos de valor y JSX en consumidores | adaptado |
| P27 | Dominio no importa flutter_test ni motor | Dominio no importa React, DOM ni data | adaptado |
| P28 | No secretos | No secretos | intacto |
| P29 | No persistencia | No persistencia | intacto |
| P30 | Casos críticos en pruebas | Casos críticos en pruebas | intacto |
| P31 | lib/domain/cuenta.dart | src/domain/cuenta.js | adaptado |
| P32 | lib/domain/resultado.dart | src/domain/resultado.js | adaptado |
| P33 | lib/domain/estrategia_redondeo.dart | src/domain/estrategiaRedondeo.js | adaptado |
| P34 | lib/domain/calcular_division.dart | src/domain/calcularDivision.js | adaptado |
| P35 | lib/domain/validar_entrada.dart | src/domain/validarEntrada.js | adaptado |
| P36 | lib/data/redondeo_exacto.dart | src/data/redondeoExacto.js | adaptado |
| P37 | lib/data/redondeo_hacia_arriba.dart | src/data/redondeoHaciaArriba.js | adaptado |
| P38 | lib/presentation/divisor_controller.dart | src/presentation/useDivisor.js | adaptado |
| P39 | lib/presentation/formateador_moneda.dart | src/presentation/formateadorMoneda.js | adaptado |
| P40 | lib/presentation/pantalla_divisor.dart | src/presentation/PantallaDivisor.jsx | adaptado |
| P41 | lib/main.dart | src/main.jsx | adaptado |
| P42 | test/casos_de_prueba.dart | test/casosDePrueba.js | adaptado |
| P43 | test/division_test.dart | test/division.test.js | adaptado |
| P44 | test/pantalla_test.dart | test/pantalla.test.jsx | adaptado |
| P45 | test/entrada_test.dart | test/entrada.test.js | adaptado |
| P46 | tool/verificar_domain.dart | tool/verificarArquitectura.js y Vitest | reemplazado |
| P47 | Controller convierte texto, valida, calcula y expone estado | Hook convierte texto, valida, calcula y expone estado | adaptado |
| P48 | Pantalla recibe controller/formateador por constructor | Pantalla recibe servicios por props; hook estático | adaptado |
| P49 | main crea validación, cálculo, estrategias, controller y formateador | main compone validación, cálculo, estrategias y formato; hook mantiene estado | adaptado |
| P50 | ValidarEntrada devuelve String? y null válido | validarEntrada devuelve string/null | adaptado |
| P51 | (importe * 100).round() / 100 | Math.round(importe * 100) / 100 | adaptado |
| P52 | CalcularDivision devuelve Resultado sin validar/formatear | calcularDivision devuelve resultado sin validar/formatear | adaptado |
| P53 | Controller rechaza desbordamiento antes de calcular | Hook rechaza desbordamiento antes de calcular | adaptado |
| P54 | Bloqueo flutter_tester: intentar Chrome y Dart puro | React Vitest/jsdom + Chrome real; problema Flutter documentado aparte | reemplazado |

De las 54 decisiones del plan original, cambiaron 40 y se mantuvieron 14. Las decisiones nuevas de React, como el formato de números grandes, la lectura de los datos y los estilos, se explican en el plan nuevo. No se suman al total del plan de Flutter.

La comparación muestra 50 líneas agregadas y 44 eliminadas. Eso no significa que cambiaron 94 decisiones: una decisión puede ocupar varias líneas. Por eso presenté los dos conteos por separado.

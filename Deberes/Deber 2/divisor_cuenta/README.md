# Divisor de cuenta — SDD

Una pantalla, monto, personas, propina y redondeo exacto o hacia arriba.
No hay red ni base de datos. Acepta coma/punto decimal, cero y rechaza negativos.

## Ejecutar
Desde esta carpeta: `flutter pub get`, `flutter run -d chrome`.
Verificar: `flutter analyze`, `flutter test --reporter expanded`,
`flutter build apk --debug`. En esta ejecución: análisis limpio, 18 tests y APK construído.

## Arquitectura
presentation -> domain <- data. main.dart compone las dependencias.
Esta copia de entrega procede de sdd, commit 0e14e00ef58f9146f9c0f51ff5fadd30f599412f.
Se añadió package:test como dependencia de desarrollo para ejecutar las pruebas en Chrome.
La constitución 1.0.1 documenta la excepción. No cambia el comportamiento ni las dependencias del producto.
En Windows ejecuta `./tool/probar_web.ps1`: prepara CanvasKit desde el SDK original porque
el runner Flutter 3.47.1 maneja incorrectamente separadores de ruta; los recursos quedan ignorados por Git.
La suite de esta copia fue validada: 18/18, All tests passed. Evidencias en ../divisor_cuenta_web/evidencias/.
test_api y matcher son dependencias transitivas de flutter_test y las pruebas puras
los importan directamente para no importar Flutter. El comprobador adicional de tool/
usa Dart puro sin librerías de pruebas.

## Funciones y clases para explicar en clase
| Elemento | Qué hace y por qué | Recibe | Devuelve / errores |
|---|---|---|---|
| Cuenta / Resultado | Objetos inmutables para datos y salida | números ya validados / importe | objeto; no validan ni formatean |
| EstrategiaRedondeo.redondear | Contrato pequeño intercambiable | importe finito >= 0 | double finito >= 0; exige precondición |
| RedondeoExacto.redondear | Aproxima al centavo multiplicando por 100 | importe | centavos como double |
| RedondeoHaciaArriba.redondear | Sube al entero con ceilToDouble | importe | entero representado como double |
| CalcularDivision.ejecutar | Fórmula y delegación de estrategia, sin if de tipo | Cuenta y estrategia | Resultado; datos válidos son precondición |
| ValidarEntrada.ejecutar | Comprueba monto, personas y propina en ese orden | double, int, double | null o mensaje; no lanza excepciones |
| FormateadorMoneda.formatear | Formatea sin calcular | importe | String de dos decimales |
| DivisorController._numero | Convierte texto decimal local | String con punto/coma | double; NaN si no puede convertir |
| DivisorController.limpiar | Evita mostrar datos de un cálculo viejo | nada | void, error y resultado quedan null |
| DivisorController.ejecutar | Convierte, valida, selecciona contrato y delega | tres textos y modo | void; publica error o resultado, incluye desbordamiento y modo inválido |
| PantallaDivisor.createState | Crea estado de entradas | nada | State |
| _limpiar | Reacciona a cambios de texto | texto nuevo (no usado) | void; limpia y reconstruye |
| _calcular | Transfiere entradas al controller dentro de setState | nada | void; reconstruye con estado actualizado |
| dispose | Libera TextEditingController | nada | void; evita recursos retenidos |
| build | Describe widgets según estado | BuildContext | pantalla, sin cálculo de negocio |
| crearAplicacion | Instancia estrategias/servicios e inyecta | nada | MaterialApp |
| main | Inicia Flutter | nada | void |
| verificar_domain.main | Verifica tabla y sustitución sin motor | nada | salida PASS; StateError si incumple |
| test.main / helpers | Registra pruebas, compone dependencias de test y simula entradas | tester y datos | expectativas o fallo de test |

## Extender el redondeo
Crear otra clase en data/ que implemente EstrategiaRedondeo.
Inyectarla en main y añadir opción de UI; CalcularDivision y estrategias existentes no cambian.
La nueva regla requiere criterios y pruebas nuevos antes de incorporarse al producto.

## Spec Kit
Versión 1.0.13. Skills oficiales instaladas en .agents/skills.
Se siguieron constitution -> specify -> clarify -> plan -> tasks -> analyze -> implement -> converge.
Las skills las ejecuta el agente; el CLI instala plantillas y scripts, no genera la app por sí solo.


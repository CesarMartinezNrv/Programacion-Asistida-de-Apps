# Deber 3 — Respuestas

Para comprobar el rojo se volvió al commit donde solo estaban las pruebas nuevas, después de haber HECHO la implementación.

1. **Rojo antes de verde.** En la prueba con monto 100, 4 personas y propina de 150%, el error fue `ESPERADO: 'La propina no puede superar el 100%'` y `ACTUAL: <null>`. Esto pasó porque todavía no existía la validación del límite. Era importante ver la prueba fallar para comprobar que sí detectaba el problema. Si solo la veía pasar después del cambio, no podía estar seguro de en realidad la estaba detectando. Posteriormente se confirma que una propina de exactamente 100% sí se permite.

2. **Linter vs. IA.** Un aviso fue `unused_local_variable`, porque había una variable que no se usaba. También apareció `avoid_print` por el `print('hola')`. Estas dos las agregué solo para ver los avisos y luego se quitaron. El code smell que señaló la IA fue el número "mágico" `100` en la validación de la propina, se recomendó que mejor ese 100 sea una variable constante. El linter no lo encontró porque ese número es válido y no rompe una regla de análisis. El problema era que no quedaba tan claro qué representaba al leer el código.

3. **Mi refactorización.** Tomé el númeor mágico y lo cambié por la constante `propinaMaxima`, con valor 100. Así se entiende que es el límite permitido. La comparación siguió siendo `>` y el mensaje de error quedó igual. Para comprobar que la app seguía haciendo lo mismo se ejecutaron las mismas pruebas, sin modificarlas, y las 20 pasaron. Por eso el cambio mejoró la claridad del código sin cambiar su comportamiento.

4. **Coverage.** El archivo con menor cobertura medida fue `lib/main.dart`, con 83,33%: las pruebas ejecutaron 5 de sus 6 líneas medibles. Eso no significa que específicamente tenga errores, sino que hubo una línea que las pruebas no ejecutaron. La cobertura ayuda a ver qué falta probar, pero no confirma por sí sola que el código esté bien o mal. `estrategia_redondeo.dart` aparece como no medido porque solo define el contrato y no tiene una implementación ejecutable.

| Archivo | Líneas cubiertas | Cobertura |
|---|---:|---:|
| `lib/data/redondeo_exacto.dart` | 3/3 | 100.00% |
| `lib/data/redondeo_hacia_arriba.dart` | 3/3 | 100.00% |
| `lib/domain/calcular_division.dart` | 4/4 | 100.00% |
| `lib/domain/cuenta.dart` | 1/1 | 100.00% |
| `lib/domain/estrategia_redondeo.dart` | — | No medido |
| `lib/domain/resultado.dart` | 1/1 | 100.00% |
| `lib/domain/validar_entrada.dart` | 6/6 | 100.00% |
| `lib/main.dart` | 5/6 | 83.33% |
| `lib/presentation/divisor_controller.dart` | 20/21 | 95.24% |
| `lib/presentation/formateador_moneda.dart` | 2/2 | 100.00% |
| `lib/presentation/pantalla_divisor.dart` | 46/46 | 100.00% |

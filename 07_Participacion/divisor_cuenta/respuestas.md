# Deber 3 — Respuestas

Verificación real en GitHub Actions, con Flutter 3.47.1. Se reprodujeron los commits de cada etapa después de escribir los cambios, porque Windows bloqueó dartvm.exe. Por tanto, el rojo se verificó retrospectivamente; no afirmo que se ejecutó antes de implementar.

1. **Rojo antes de verde.** La prueba de propina 150% esperaba `La propina no puede superar el 100%` y recibió `Actual: <null>`. Ver ese fallo demuestra que la prueba detecta la regla ausente. La prueba con exactamente 100% protege el límite permitido. El fallo se reprodujo sobre el commit que contiene solo las pruebas nuevas.

2. **Linter vs. IA.** Al introducir temporalmente una variable sin uso y `print('hola')`, aparecieron `unused_local_variable` y `avoid_print`. Después retiré ambas líneas y el análisis quedó limpio. La IA identificó el número mágico 100 del límite de propina; el linter no lo marcó porque es un literal válido cuyo significado depende de la regla de negocio.

3. **Refactorización.** Elegí el número mágico y lo reemplacé por la constante `propinaMaxima = 100`. La comparación continúa siendo `>` y el mensaje no cambió. Las mismas pruebas pasaron después del refactor, sin modificar sus expectativas.

4. **Coverage.** La menor cobertura medida corresponde a `lib/main.dart`, con 83.33%. Eso indica qué líneas ejecutaron las pruebas, no demuestra errores. Una cobertura alta tampoco garantiza que se hayan comprobado todos los comportamientos. Los archivos ausentes del informe se señalan como no medidos.

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

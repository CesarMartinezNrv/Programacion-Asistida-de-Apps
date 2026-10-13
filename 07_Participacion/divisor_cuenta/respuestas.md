# Deber 3 — Respuestas

Estado: implementación preparada; ejecución bloqueada por Windows. Estas respuestas distinguen observaciones de resultados pendientes.

1. **Rojo antes de verde.** No pude observar el fallo de la prueba: `flutter test` terminó con `ProcessStarter::StartForExec failed: An Application Control policy has blocked this file`. Antes del cambio, la validación devuelve `null` para 150%; por inspección, la prueba debería esperar el mensaje y fallar al recibir `null`. Ver ese fallo real es importante para demostrar que la prueba detecta la regla ausente; queda pendiente ejecutarlo.

2. **Linter vs. IA.** `flutter analyze` encontró el mismo bloqueo, así que no hay un aviso del linter observado. `unused_local_variable` y `avoid_print` son los avisos esperables al introducir la variable sin uso y `print('hola')` del ejercicio; no afirmo haberlos obtenido. La revisión encontró un número mágico en el límite de propina. El linter no suele señalarlo porque un literal válido no viola una regla sintáctica; su significado depende del negocio.

3. **Refactorización.** Elegí el número mágico del máximo de propina: reemplacé el literal de la comparación por `propinaMaxima`, una constante de valor 100. La comparación sigue siendo estrictamente `>` y el mensaje conserva exactamente su texto. Por inspección mantiene el comportamiento, pero falta confirmarlo ejecutando las mismas pruebas sin modificarlas.

4. **Coverage.** No se generó `coverage/lcov.info` porque no se pudieron ejecutar las pruebas. Por ello no puedo identificar honestamente el archivo con menor cobertura. Un porcentaje bajo indica líneas no ejecutadas por las pruebas, no demuestra errores; tampoco una cobertura alta garantiza que las comprobaciones sean suficientes.

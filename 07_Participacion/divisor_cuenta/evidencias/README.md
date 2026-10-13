# Evidencias del Deber 3

**Verificación completada:** [ejecución exitosa en GitHub Actions](https://github.com/CesarMartinezNrv/Programacion-Asistida-de-Apps/actions/runs/38438776002).

- 18 pruebas iniciales aprobadas; en rojo falló únicamente la nueva regla de 150%; después del cambio y del refactor pasaron las 20 pruebas.
- Análisis final: `No issues found!`. La demostración temporal produjo `unused_local_variable` y `avoid_print`, y se retiró sin alterar el comportamiento.
- [Tabla de cobertura](cobertura.md): mínimo medido `lib/main.dart`, 83,33%.
- Los `*_captura.jpg` son capturas reales del navegador mostrando los archivos de salida publicados en GitHub. `github_actions_exitoso.jpg` muestra el resultado general de CI.
- Los PNG solicitados en el enunciado son transcripciones renderizadas de las salidas reales, con su procedencia visible. Los TXT contienen las salidas completas. Se incluyen las capturas JPG como evidencia adicional.
- Windows bloqueó `dartvm.exe`; por eso se verificaron los commits históricos en Ubuntu. La ejecución del rojo fue retrospectiva; no se presenta como un ciclo ejecutado antes de implementar.

## Registro del bloqueo inicial

Los archivos `parte1_bloqueo.txt` y `parte4_bloqueo.txt` contienen la salida real de los comandos. No se generaron capturas de éxitos ni una tabla de cobertura sin ejecutar las herramientas.

## Revisión de smells antes del refactor

- `lib/domain/validar_entrada.dart:13`, versión del commit `3f7bc31`: número mágico `100` en la nueva regla. Se eligió este smell y se extrajo una constante con nombre.
- `lib/domain/calcular_division.dart:9` y `lib/presentation/divisor_controller.dart:52`: fórmula de división repetida; puede divergir si cambia el cálculo. Se deja intacta para respetar el alcance de una sola refactorización.
- `lib/presentation/pantalla_divisor.dart:48`: método `build` largo, con varios campos similares. Puede dificultar la lectura; no se modificó.

## Procedimiento reproducible (ya ejecutado en CI)

Usar una copia separada para revisar los commits históricos sin alterar esta entrega:

1. En `0e14e00`, ejecutar `flutter test` y capturar `parte1_verde.png`.
2. En `7119c6d`, ejecutar `flutter test`: comprobar el fallo por recibir `null` en lugar del mensaje y capturar `parte2_rojo.png`.
3. En `3f7bc31`, ejecutar `flutter test`, comprobar el diff exclusivo de `lib/` y capturar `parte3_verde.png`.
4. Ejecutar `flutter analyze`. Si está limpio, introducir temporalmente una variable local sin uso y `print('hola');` dentro de `main`, capturar los avisos en `parte4_analyze.png` y retirar ambas líneas. Si hay avisos reales, corregir solo esos avisos y registrar el commit correspondiente.
5. En el commit del refactor, ejecutar `flutter test` y capturar `parte6_refactor.png`.
6. Ejecutar `flutter test --coverage`. Para cada registro `SF:` de `lcov.info`, calcular `100 * LH / LF`; incluir también archivos de `lib/` ausentes como no medidos. Capturar `parte7_coverage.png` y completar la respuesta 4 con los datos reales.
7. Capturar `git log --oneline` como `parte8_log.png`. Sustituir las respuestas pendientes con observaciones reales y guardar las evidencias.

La historia registra las etapas de escritura; los títulos originales documentan el bloqueo que existía al crear los commits. Las ejecuciones posteriores comprobaron cada etapa sobre su propio commit, conservando esa cronología. `coverage/` se excluyó en `.gitignore`.

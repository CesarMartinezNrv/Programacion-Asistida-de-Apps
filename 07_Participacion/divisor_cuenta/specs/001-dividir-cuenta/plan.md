# Implementation Plan: Dividir cuenta
**Branch**: `sdd` | **Date**: 2026-10-01 | **Spec**: [spec.md](spec.md)
**Input**: especificación aclarada del divisor.

## Summary
Flutter estable, una pantalla, setState y dependencias por constructor.
Cálculo puro y estrategia de redondeo intercambiable.

## Technical Context
**Language/Version**: Dart 3.13.1, Flutter 3.47.1 estable.
**Primary Dependencies**: SDK Flutter y dependencias de plantilla, sin paquetes adicionales.
**Storage**: ninguno.
**Testing**: flutter_test para widgets; test_api (dependencia del SDK) para dominio sin widgets.
**Target Platform**: Android y web para verificación alternativa.
**Project Type**: app móvil de una pantalla.
**Performance Goals**: cálculo síncrono constante, sin operaciones de red.
**Constraints**: offline; no modificar android/ios ni agregar paquetes.
**Scale/Scope**: tres entradas, dos modos, un resultado.

## Constitution Check
Antes y después del diseño: SRP cálculo/validación/formato separados; OCP interfaz;
LSP sin cast; ISP un método; DIP presentación solo dominio; composición en main.
Objetos de valor y widgets pueden construirse en sus consumidores.
Las pruebas de dominio importan test_api y no flutter_test: no dependen del motor.
No secretos, persistencia ni red. Casos críticos convertidos en pruebas.

## Project Structure
```text
lib/
  domain/cuenta.dart
  domain/resultado.dart
  domain/estrategia_redondeo.dart
  domain/calcular_division.dart
  domain/validar_entrada.dart
  data/redondeo_exacto.dart
  data/redondeo_hacia_arriba.dart
  presentation/divisor_controller.dart
  presentation/formateador_moneda.dart
  presentation/pantalla_divisor.dart
  main.dart
test/
  casos_de_prueba.dart
  division_test.dart
  pantalla_test.dart
  entrada_test.dart
tool/
  verificar_domain.dart
```
**Structure Decision**: estructura solicitada, más pruebas de aclaraciones y comprobador
Dart puro por el bloqueo de flutter_tester.exe.

## Phase 0: Research
Ver [research.md](research.md). No desconocidos pendientes.
## Phase 1: Design
Ver [data-model.md](data-model.md), [contracts/ui.md](contracts/ui.md) y [quickstart.md](quickstart.md).
Controller convierte texto, invoca validación, delega cálculo a la estrategia elegida y expone
error/resultado. Pantalla recibe controller y formateador por constructor.
main crea validación, cálculo, estrategias, controller y formateador.
ValidarEntrada devuelve String?; null significa válido.
RedondeoExacto usa (importe * 100).round() / 100.
CalcularDivision devuelve Resultado sin validar o formatear.
Controller rechaza desbordamientos antes de invocar CalcularDivision.

## Complexity Tracking
Sin infracciones aceptadas. El bloqueo del motor nativo requiere verificación alternativa:
intentar flutter test --platform chrome y ejecutar el comprobador puro con dart.


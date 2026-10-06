# Implementation Plan: Dividir cuenta en React
**Branch**: `main` | **Date**: 2026-10-06 | **Spec**: [spec.md](spec.md)
**Input**: copia idéntica de la especificación aclarada Flutter sdd.

## Summary
React con Vite, JavaScript, una pantalla y estado local con useState.
Cálculo puro y estrategia de redondeo intercambiable.

## Technical Context
**Language/Version**: JavaScript ES modules; Node v24.19.0.
**Primary Dependencies**: React 19, React DOM 19, Vite 8, sin librerías externas de estado.
**Storage**: ninguno.
**Testing**: Vitest; Testing Library y jest-dom para pantalla; jsdom como entorno.
**Target Platform**: navegador web moderno.
**Project Type**: página web estática de una pantalla.
**Performance Goals**: cálculo síncrono constante, sin operaciones de red.
**Constraints**: offline durante el uso; sin almacenamiento, login, historial ni backend.
**Scale/Scope**: tres entradas, dos modos, un resultado.

## Constitution Check
Antes y después del diseño: SRP cálculo/validación/formato separados; OCP contrato;
LSP sin cast; ISP aplicar(valor); DIP presentación solo dominio; composición en main.jsx.
Objetos de valor y elementos JSX pueden construirse en sus consumidores.
Dominio JavaScript puro, sin React, DOM ni data.
No secretos, persistencia ni red. Casos críticos convertidos en pruebas.
Gate previo y posterior al diseño: PASS; no contradicción de la spec con React.
La constitución reemplaza explícitamente la prohibición de paquetes Flutter por el stack requerido.

## Project Structure
```text
src/
  domain/cuenta.js
  domain/resultado.js
  domain/estrategiaRedondeo.js
  domain/calcularDivision.js
  domain/validarEntrada.js
  data/redondeoExacto.js
  data/redondeoHaciaArriba.js
  presentation/useDivisor.js
  presentation/formateadorMoneda.js
  presentation/PantallaDivisor.jsx
  presentation/estilos.css
  main.jsx
test/
  setup.js
  casosDePrueba.js
  division.test.js
  pantalla.test.jsx
  entrada.test.js
tool/
  verificarArquitectura.js
```
**Structure Decision**: mismas responsabilidades, rutas src y archivos JavaScript/JSX.
Sin servidor, llamadas de red en runtime ni persistencia.

## Phase 0: Research
Ver [research.md](research.md). Stack definido por la guía; no desconocidos pendientes.
## Phase 1: Design
Ver [data-model.md](data-model.md), [contracts/ui.md](contracts/ui.md) y [quickstart.md](quickstart.md).
useDivisor convierte texto, valida, delega cálculo y expone error/resultado mediante useState.
La pantalla importa el hook estáticamente y recibe servicios ordinarios como dependencias.
main.jsx crea validación, cálculo, estrategias y formateador y los inyecta en la pantalla.
validarEntrada devuelve string o null; null significa válido.
redondeoExacto usa Math.round(valor * 100) / 100; hacia arriba usa Math.ceil(valor).
calcularDivision devuelve resultado sin validar ni formatear y llama estrategia.aplicar(valor).
El hook comprueba finitud de importe e importe * 100 antes de calcular, como el controller Flutter.
La conversión rechaza texto vacío, hexadecimales, separadores de miles y sufijos no numéricos.
La edición y el cambio de modo eliminan el resultado anterior.
El formateador garantiza dos decimales, también para importes >= 1e21 sin notación exponencial.

## Complexity Tracking
Sin infracciones aceptadas. Windows bloquea flutter_tester.exe; validación Flutter web registrada
por separado y no asumida a partir de los resultados React.

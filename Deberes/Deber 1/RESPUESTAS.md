# Respuestas — Deber 1

## 1. setState, navegación y botón Atrás

Experimento:

1. Cambia a la rama `version/setstate`.
2. Ejecuta `flutter run` desde `parte_a_contador`.
3. Entra a Control, pulsa `+1` y sal con el botón Atrás de Android, no con “Volver”.
4. Anota qué valor muestra el Visor.
5. Cierra la app por completo y vuelve a abrirla; anota el valor cargado.

Resultado observado:
Al entrar a Control el contador estaba en 0 y lo incrementé a 1. Al regresar al visor utilizando el botón Atrás del teléfono, el visor siguió mostrando 0. Al cerrar y abrir nuevamente la aplicación apareció 1.

En este caso, el valor sí se guardó en disco, pero el estado del visor en memoria quedó desactualizado. Eso ocurrió porque el valor nuevo no se devolvió con `Navigator.pop` ni se actualizó en la pantalla de origen. Para que el contador viajara entre las dos pantallas, tuvieron que ponerse de acuerdo dos lugares del código: `PantallaControl` devolvía el valor actualizado y `PantallaVisor` lo recibía y actualizaba su estado con `setState`.

## 2. Riverpod y el botón Atrás

Experimento:

1. Cambia a `version/riverpod` y ejecuta la app.
2. Entra a Control, modifica el contador y vuelve con el botón Atrás de Android.
3. Confirma si el Visor ya muestra el nuevo valor.

Resultado observado:
Incrementé el contador; regresé con Atrás de Android y el Visor presentó el valor actualizado.

Esto ocurre porque el contador vive en `contadorProvider`, no solo dentro de una pantalla. Como el estado está compartido, ambas pantallas leen y actualizan la misma fuente de datos.

## 3. BlocObserver

Experimento:

1. Cambia a `version/bloc` y ejecuta la app con la consola de depuración visible.
2. Pulsa `+1` y `-1` varias veces.
3. Copia aquí varias líneas reales con el formato `ContadorCubit: 3 -> 4`.

Salida observada:

```text
I/flutter ( 8339): ContadorCubit: 2 -> 3
I/flutter ( 8339): ContadorCubit: 3 -> 4
I/flutter ( 8339): ContadorCubit: 4 -> 3
I/flutter ( 8339): ContadorCubit: 3 -> 4
```

`BlocObserver` me permitió ver cada transición del contador en la terminal, incluyendo el estado anterior y el nuevo. Eso me dio una pista clara de qué estaba pasando antes de que apareciera un error o un valor inesperado. En un caso real sería útil para revisar qué cambios ocurrieron en una secuencia de acciones y detectar cuál fue el punto en que algo salió mal.

## 4. Prueba de arquitectura con Git

Comando:

```bash
git diff version/setstate version/riverpod -- lib/domain lib/data
```

Salida real:

```text
(sin salida)
```

Comando:

```bash
git diff version/setstate version/bloc -- lib/domain lib/data
```

Salida real:

```text
(sin salida)
```

Comando:

```bash
git diff version/setstate version/bloc --stat -- lib/presentation
```

Salida real:

```text
 .../lib/presentation/estado/contador_cubit.dart    | 20 +++++++
 .../presentation/pantallas/pantalla_control.dart   | 63 ++++-----------------
 .../lib/presentation/pantallas/pantalla_visor.dart | 65 ++++------------------
 3 files changed, 44 insertions(+), 104 deletions(-)
```

Los dos primeros comandos salen vacíos porque `domain` y `data` no cambiaron en ninguna de las tres versiones. El tercero sí tiene salida porque `presentation` sí cambió; ahí está la diferencia entre un administrador de estado y otro. Eso demuestra que el cambio de estado se hace en la capa de presentación y que, si mañana cambiara Riverpod por otro paquete, tendría que reescribir la gestión del estado y su integración con las pantallas, pero no `domain` ni `data`.

## Tabla comparativa de la Parte A

| | setState | Riverpod | Cubit |
|---|---|---|---|
| ¿Dónde vive el contador? | En el estado de la pantalla; se pasa entre pantallas | En `contadorProvider` | En `ContadorCubit` |
| ¿Las pantallas se pasan datos? | Sí, por constructor y con `Navigator.pop` | No | No |
| Archivos de `presentation/` que tocaste | `pantalla_visor.dart`, `pantalla_control.dart` | `pantalla_visor.dart`, `pantalla_control.dart`, `contador_provider.dart` | `pantalla_visor.dart`, `pantalla_control.dart`, `contador_cubit.dart` |
| ¿Qué pasa con el botón Atrás? | El Visor puede quedar con el valor anterior porque el botón Atrás de Android no devuelve el contador actualizado | El botón Atrás mantiene el valor actualizado porque ambas pantallas usan el mismo `contadorProvider` | El botón Atrás mantiene el valor actualizado porque ambas pantallas usan el mismo `ContadorCubit` |
| ¿Tuviste que tocar `domain/`? | No | No | No |

## 5. Elección entre setState, Riverpod y Cubit

Mi decisión personal sería esta: si la aplicación tuviera solo una pantalla elegiría `setState`, porque el estado no sería tan complejo y no tendría que compartirse entre varias pantallas. Para ocho pantallas y cinco datos elegiría Riverpod, porque ahí sí me conviene tener un estado compartido y accesible desde diferentes partes. `setState` sí sirve cuando el estado es local, pequeño y no necesita compartirse.

## 6. Limitación del Future

Experimento:

1. En `main`, ejecuto `parte_b_conexion` y abro “Con Future”.
2. Con Wi‑Fi encendido, pulso “Consultar ahora” y anoto el estado y la hora.
3. Apago Wi‑Fi o activo modo avión sin tocar la app.
4. Anoto qué sigue mostrando la pantalla y después pulso “Consultar ahora” otra vez.

Resultado observado:
Primero consulté con Wi‑Fi encendido; apareció Wi‑Fi en verde y la hora. Después apagué Wi‑Fi y al volver a consultar cambió a “Sin conexión”. También cambió la hora de consulta.

Lo que observé era un dato correcto del momento en que se hizo la primera consulta, pero quedó desactualizado porque `Future` no escucha cambios posteriores. La información no se vuelve a actualizar sola; solo cambia cuando vuelvo a consultar.

## 7. Cancelación de la suscripción

Si se elimina `cancel()`, una pantalla puede seguir escuchando el `Stream` aunque ya no exista. Eso hace que se acumulen suscripciones, se consuman recursos y se ejecuten callbacks innecesarios. En ese caso, el `close()` de un Cubit o de una pantalla debe cancelar la suscripción para dejar de escuchar. En mi caso, `close()` con `cancel()` me ayudó a evitar que la aplicación siguiera revisando cambios de conexión cuando ya no necesitaba esa pantalla.

## 8. Future como foto y Stream como película

Experimento:

1. Abro “Con Stream”.
2. Sin pulsar ningún botón, apago Wi‑Fi y observo el cambio.
3. Vuelvo a encenderlo y observo la recuperación.
4. Si el teléfono tiene datos móviles, apago solo Wi‑Fi y anoto si cambia a Datos móviles.

Resultado observado:
Estado inicial: Wi‑Fi
Después de apagar Wi‑Fi: Sin conexión
Cambios recibidos: 1
Después de encender Wi‑Fi: Wi‑Fi
Cambios recibidos: 2

En la versión con `Future`, el programa mantuvo el último resultado hasta que volví a consultar. Con `Stream`, el estado cambió automáticamente sin hacer una nueva consulta, y al volver a encender Wi‑Fi se actualizó otra vez.

Para mí, `Future` es como una foto: te da el dato en un momento concreto y después te queda ese resultado. `Stream` es como una película: va entregando cambios en tiempo real mientras siguen ocurriendo.

Ejemplos reales donde usaría `Future`:
- consultar el perfil de un usuario;
- consultar el detalle de una factura.

Ejemplos reales donde usaría `Stream`:
- recibir mensajes de un chat;
- seguir la ubicación de un viaje en tiempo real.

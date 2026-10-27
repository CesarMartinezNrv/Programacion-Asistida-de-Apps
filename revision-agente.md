# Parte 5 — Revisión crítica de ci.yml

Revisión solicitada: «Revisa mi ci.yml: ¿qué riesgos de seguridad o fragilidad tiene?».

## Hallazgos y decisiones

1. **Las etiquetas de las acciones pueden cambiar.** `@v7`, `@v6` y `@v2` no identifican una revisión inmutable. Se acepta fijar las acciones a sus SHA completos, comprobados con `git ls-remote` contra los repositorios originales de GitHub. Esto fija el código de las acciones; no elimina la confianza en los SDK que descargan.
2. **Checkout conserva credenciales por defecto.** Ningún paso necesita escribir en el repositorio. Se acepta `persist-credentials: false` y se mantiene `permissions: contents: read`.
3. **Una compilación atascada puede consumir demasiado tiempo.** Se acepta un límite de 30 minutos por job mediante `timeout-minutes`.
4. **Una ruta equivocada podría dejar una entrega sin APK.** Se acepta `if-no-files-found: error` al subir el artifact y se usa la ruta exacta del APK. Se indica una retención de 30 días y se guarda una captura permanente en el repositorio.
5. **Flutter stable y ubuntu-latest cambian con el tiempo.** Fijar una versión concreta de Flutter mejoraría la reproducibilidad y también podría ser una versión estable. Para este ejercicio se decide mantener `channel: stable`, de modo que use la estable disponible, y `ubuntu-latest`, como pide la guía. Se conserva el lockfile del proyecto. Es una decisión de alcance, no una garantía de reproducibilidad: la fragilidad permanece y se declara.
6. **Un APK debug no es un release de producción.** No se agregan firma, secretos, paquetes de análisis adicionales ni despliegues externos. No son necesarios para el alcance de esta entrega.
7. **Los jobs no comparten archivos.** `entrega` depende de `verificar`, vuelve a instalar el entorno y a compilar el mismo commit, y publica únicamente en push a `main`. La segunda compilación consume más tiempo; es la primera alternativa permitida por la guía. Si falla, no se publica el artifact.

## Acciones verificadas

| Acción | Etiqueta consultada | SHA comprobado |
|---|---|---|
| [actions/checkout](https://github.com/actions/checkout) | v7 | `3d3c42e5aac5ba805825da76410c181273ba90b1` |
| [actions/setup-java](https://github.com/actions/setup-java) | v6 | `b843ebf9b913146b38da2eaa7aeddf76074ae1ad` |
| [subosito/flutter-action](https://github.com/subosito/flutter-action) | v2 | `1a449444c387b1966244ae4d4f8c696479add0b2` |
| [actions/upload-artifact](https://github.com/actions/upload-artifact) | v7 | `cf430e030ddbb5b0abf93d22962f4752f3646cd9` |

`subosito/flutter-action` es una acción de terceros: se verificó su repositorio y se fijó su revisión, pero eso no equivale a una auditoría exhaustiva de su código. No se agregaron paquetes a la aplicación.

# Evidencias de ejecución

Fecha: 10 de noviembre de 2026. Herramienta: Codex CLI `0.167.0-alpha.3.2`, desde Codex de escritorio. Se trabajó en `skills/cyber-detective`, sin hacer push directo a main.

## Instalación local de prueba

La carpeta de entrega es `incident-investigator/`. El invocador copia ese contenido a `Proceso/<caso>/.agents/skills/incident-investigator/` antes de cada ejecución con skill. La condición sin skill no recibe esa copia. `Proceso/` está ignorado por Git porque contiene copias de trabajo, no evidencias adicionales. Las trazas y los scripts reproducibles sí están en esta carpeta.

La ubicación se comprobó operativamente: en la sesión contextual el agente intentó leer `.agents/skills/incident-investigator/SKILL.md` sin que la solicitud mencionara el skill. El error del comando conserva esa ruta. La sesión explícita también reconoció el skill. No se afirma que crear la carpeta de entrega por sí solo lo instale globalmente ni que aparezca en chats abiertos anteriormente.

## A — explícita

La primera ejecución local no pudo iniciar por permisos del entorno. El intento posterior con permisos para iniciar Codex sí abrió una sesión, pero sus comandos de lectura fueron bloqueados por la política del sandbox de solo lectura.

- Sesión: `01a1c6d7-3455-7c13-b737-71c8613a7650`.
- [Salida JSONL](activacion_explicita.jsonl) y [errores con comandos rechazados](explicita-error.txt).
- El agente intentó abrir `SKILL.md` y la referencia, pero no obtuvo sus contenidos ni el CSV mediante herramientas. No se cuenta como una investigación exitosa.

Se realizó otra invocación explícita mediante una alternativa: el proceso invocador leyó el CSV, el skill y la referencia y entregó sus contenidos a una sesión nueva. El agente aplicó las reglas y reconoció expresamente que no había abierto archivos con herramientas.

- Sesión: `01a1c6d9-7e20-7831-9713-71f6a4d7f19a`.
- [Respuesta](explicita-carga.md) y [traza](explicita-carga.jsonl).

Esto comprueba aplicación de instrucciones cargadas explícitamente. No comprueba lectura autónoma del agente.

## B — contextual

Se usó la solicitud del enunciado, sin mencionar `incident-investigator`. El agente anunció que lo usaría e intentó ejecutar una lectura de `.agents/skills/incident-investigator/SKILL.md`. El rechazo del comando, además de la mención del nombre, respalda el intento de selección y lectura.

- Sesión: `01a1c6d8-64dc-7aa3-961e-b5def96a93e7`.
- [Respuesta](contextual.md), [traza](contextual.jsonl) y [comando de lectura bloqueado](contextual-error.txt).
- Resultado: selección contextual observada; carga completa y análisis no completados por la política local.

No se corrigió la description ni se fingió una activación completa. La selección sí fue pertinente y modificar la descripción no resolvería el bloqueo de lectura. Se documenta la limitación de plataforma que admite el enunciado.

## C — control negativo

Se pidió únicamente contar eventos por hora, sin investigar incidentes. El skill estaba instalado y disponible; no se le entregó el cuerpo ni la referencia como contexto adicional. Por el bloqueo anterior, el invocador proporcionó el CSV numerado y la instrucción común de no ejecutar herramientas.

- Sesión: `01a1c6d9-7a44-7c60-9a28-62e7f8bebdb6`.
- [Respuesta](negativo.md) y [traza](negativo.jsonl).
- Resultado: 63 registros entre 01:00 y 01:59, 30 entre 02:00 y 02:59; total 93. No hubo clasificación de amenazas ni anuncio de uso del skill.

Esta es evidencia de comportamiento descriptivo sin aplicación observable del procedimiento. Como el agente no tenía que usar herramientas, la ausencia de una lectura por sí sola no demuestra qué razonó internamente. La respuesta sí respeta el límite de alcance.

## Comparación y verificación

Las dos sesiones independientes y sus mediciones están en [comparacion.md](../comparacion.md). [ejecutar-pruebas.ps1](ejecutar-pruebas.ps1) conserva las opciones y la forma de entregar entradas. Los mismos archivos originales se usan en ambas condiciones; la sesión con skill recibe además las instrucciones y reglas reales. No se entrega el script de verificación a ninguna de las dos.

[verificar.ps1](verificar.ps1) contrasta ventanas, repeticiones, filas, conteos e integridad. Su salida está en [verificacion.txt](verificacion.txt). Las comprobaciones sobre este CSV no sustituyen una prueba del skill con otros datos ni una validación general de todos los casos límite.

Se intentó ejecutar `quick_validate.py` de skill-creator: primero falló el alias de Python de Windows y después, con el Python incluido en el runtime de Codex, faltó el módulo `yaml`. No se cuenta como una validación aprobada ni se instaló una dependencia desde Internet. La comprobación básica en PowerShell confirmó nombre, description y referencia; las sesiones aportan la evidencia de comportamiento descrita arriba. También se verificaron la sintaxis de ambos scripts y los enlaces locales de los informes.

## Protección de valores y original

El CSV del curso se conserva íntegro, incluido su valor sintético de prueba. En informes, respuestas y trazas se oculta el token. El invocador sustituye cualquier aparición del valor exacto antes de guardar stdout. Los documentos Markdown de respuestas son extractos de los mensajes reales, sin reescribir su contenido. Los archivos `*-error.txt` son errores auténticos del entorno.

Se comprobó que las seis copias utilizadas en las pruebas tienen el mismo SHA-256 que el original. `.gitattributes` desactiva la conversión de finales de línea únicamente para ese CSV, para que Git también conserve sus bytes. La búsqueda del valor sintético exacto en los demás archivos de entrega no encontró apariciones.

La petición de conservar el CSV original y la de no incluir ningún token completo en el PR tienen una tensión en el propio material: el CSV contiene un token sintético. Se conserva el original por integridad y se evita reproducir su valor en los demás archivos. No se afirma que el CSV original esté redactado ni que contenga un secreto real.

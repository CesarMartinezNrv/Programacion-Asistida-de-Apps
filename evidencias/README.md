# Evidencias del Deber 5

Las llamadas y resultados son de ejecuciones reales del servidor. Todos los datos del incidente son simulados, como indica el enunciado.

| Archivo | Qué muestra |
|---|---|
| `parte1_server.png` | El archivo real `server.py`, presentado en un visor local para capturarlo completo. |
| `inspector_tools.png` | La interfaz real de MCP Inspector con las tres herramientas descubiertas. |
| `inspector_pruebas.png` | Montaje de capturas reales de Inspector: D1–D7 y el registro después del reinicio. Solo se añadieron títulos fuera de las capturas. |
| `inspector_D1.png` a `inspector_D7.png` | Capturas individuales de esas pruebas. |
| `inspector_reinicio.png` | La misma alerta aceptada después de desconectar y arrancar otra instancia del servidor. |
| `pytest.png` | La salida original de pytest en un visor local: 18 pruebas aprobadas. |
| `pytest.txt` | Salida de texto original de la ejecución. |
| `agente_tools.png` | Visor de la salida JSONL real de la sesión independiente de Codex CLI, con llamadas, argumentos y resultados. |
| `agente.jsonl` | Traza original completa emitida por `codex exec --json`. |
| `agente-traza.html` | Visor estático de esa traza, para poder inspeccionarla sin ejecutar el agente. |
| `investigacion.md` | Respuesta final de la sesión independiente. |
| `inspector-protocolo.json` | Exportación original de Inspector de D1–D7. |
| `inspector-reinicio.json` | Exportación de la conexión nueva y el registro exitoso tras reiniciar. |
| `stdio.json` | Verificación adicional por el cliente MCP de Python, con D1–D7 y una segunda instancia. |

## Alcance de la captura del agente

`agente_tools.png` es una captura del visor de la traza auténtica, **no de la interfaz original de Codex**. La sesión y las llamadas sí ocurrieron; el archivo `agente.jsonl` permite comprobarlo. Como el enunciado pide expresamente la interfaz del agente, queda pendiente añadir una captura de la interfaz original mostrando esas llamadas para cumplir literalmente ese requisito. El visor no se presenta como si fuera esa interfaz.

La sesión independiente fue `01a19e0e-adc3-77c3-8694-91b092db4b85`. En la traza se ven seis llamadas MCP terminadas: listar los casos, consultar los tres casos, registrar una alerta y consultar INC-999. No aparecen comandos ni lecturas de archivos durante la investigación. El estado `failed` de INC-999 corresponde al rechazo esperado del servidor.

Inspector muestra sus marcas de tiempo en UTC; la fecha local de la ejecución fue el 2 de noviembre de 2026 (America/Guayaquil).

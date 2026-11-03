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
| `agente_tools.png` | Captura directa de la interfaz original de Codex: llamada `registrar_alerta`, con nombre, argumentos y resultado. |
| `agente_listar.png` | Interfaz original de Codex: llamada `listar_casos`, argumentos vacíos y resultados. |
| `agente_consulta.png` | Interfaz original de Codex: llamada `consultar_eventos` para INC-001 y resultado válido. |
| `agente_error.png` | Interfaz original de Codex: argumentos de INC-999 y respuesta de error MCP. |
| `agente_alerta_resultado.png` | Confirmación estructurada de la alerta, con `estado: registrada`, desplegada en Codex. |
| `agente_error_resultado.png` | Mensaje completo de rechazo de INC-999 desplegado en Codex. |
| `agente-captura.jsonl` | Salida original de la nueva sesión independiente que aparece en las capturas. |
| `agente.jsonl` | Traza original completa emitida por `codex exec --json`. |
| `agente-traza.html` | Visor estático de esa traza, para poder inspeccionarla sin ejecutar el agente. |
| `investigacion.md` | Respuesta final de la sesión independiente. |
| `inspector-protocolo.json` | Exportación original de Inspector de D1–D7. |
| `inspector-reinicio.json` | Exportación de la conexión nueva y el registro exitoso tras reiniciar. |
| `stdio.json` | Verificación adicional por el cliente MCP de Python, con D1–D7 y una segunda instancia. |

## Capturas de la interfaz original del agente

El 3 de noviembre de 2026 se repitió la investigación en una sesión independiente, `01a1a253-1f87-7bc1-8fc2-03d714b60d59`, conectada al mismo servidor por stdio. Después se abrió esa sesión en Codex y se tomaron capturas directas con Computer Use. Se desplegaron los detalles de las llamadas mediante el control `Show raw tool call output` de la propia interfaz. Estas capturas no son imágenes de un visor reconstruido. Los textos largos pueden continuar horizontalmente; la traza completa se conserva en `agente-captura.jsonl`.

La sesión inicial del 2 de noviembre fue `01a19e0e-adc3-77c3-8694-91b092db4b85` y sigue conservada en `agente.jsonl`. En ambas trazas se ven seis llamadas MCP terminadas: listar los casos, consultar los tres casos, registrar una alerta y consultar INC-999. No aparecen comandos ni lecturas de archivos durante la investigación. El estado `failed` de INC-999 corresponde al rechazo esperado del servidor. El visor adicional `agente-traza.html` documenta la primera sesión y no sustituye las capturas de la interfaz original.

Inspector muestra sus marcas de tiempo en UTC; la fecha local de la ejecución fue el 2 de noviembre de 2026 (America/Guayaquil).

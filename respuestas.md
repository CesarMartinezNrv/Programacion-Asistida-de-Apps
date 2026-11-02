# Deber 5 — MCP Detective

## 1. Arquitectura

El LLM decidió qué herramienta usar y explicó los eventos que recibió. El host, en este caso Codex CLI, mantuvo la conversación y coordinó las llamadas. El cliente MCP conectó al agente con el servidor por stdio, envió los argumentos y recibió los resultados. El servidor ejecutó las funciones de Python: leyó los casos, validó las entradas y guardó la alerta en memoria. El LLM propuso la acción; el proceso del servidor fue el que realmente ejecutó Python.

## 2. Evidencia

En INC-003 hubo cuatro intentos fallidos de `admin`, entre las 03:00 y las 03:03, y un acceso exitoso a las 03:04. Todos salieron de `192.0.2.50` y corresponden al panel de administración. Puse nivel alto porque la secuencia merece una revisión prioritaria. Sin embargo, los logs no dicen quién estaba usando la cuenta ni si tenía autorización. También podría ser una persona autorizada que escribió mal su contraseña. Por eso hay un patrón sospechoso, pero no se puede asegurar que hubo una intrusión.

## 3. Validación y seguridad

El servidor rechaza INC-999 y los parámetros inválidos. También revisa si ya existe una alerta para el caso antes de guardar otra. No basta con confiar en el modelo, porque puede equivocarse con un identificador, inventar un nivel o mandar un motivo vacío. El servidor aplica las mismas reglas en cada llamada, aunque el modelo mande argumentos incorrectos. Eso fue lo que garantizó el código y que el LLM por sí solo no podía garantizar.

`listar_casos` y `consultar_eventos` solo leen. `registrar_alerta` sí cambia el estado. Las alertas viven en un diccionario y se pierden cuando termina el proceso; no se guardan en un archivo.

## Agente y conexión

Usé Codex CLI en una sesión independiente para la investigación. Se conectó con el Python del entorno virtual y la ruta absoluta de `server.py`. Comprobé la conexión por las llamadas reales: `listar_casos`, las consultas de INC-001, INC-002 e INC-003, el registro de la alerta y la consulta de INC-999. La sesión no ejecutó comandos ni leyó `casos.json` directamente; toda la evidencia vino de MCP.

La traza original está en [evidencias/agente.jsonl](evidencias/agente.jsonl) y el resultado de la investigación en [evidencias/investigacion.md](evidencias/investigacion.md). La captura [agente_tools.png](evidencias/agente_tools.png) muestra esa salida JSONL en un visor local, con los argumentos y resultados de las llamadas; no es una captura de la interfaz original de Codex.

## Instalación y ejecución

Se necesita Python 3.11 o superior y Node con `npx` en el PATH. Desde la raíz del repositorio:

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r mcp-detective/requirements.txt
.\.venv\Scripts\mcp.exe version
.\.venv\Scripts\python.exe -m pytest mcp-detective -q
.\.venv\Scripts\mcp.exe dev mcp-detective/server.py
```

En Inspector conecté el servidor por stdio y ejecuté D1–D7. Listó los tres casos, devolvió los seis fallos de INC-002, registró la alerta válida y rechazó INC-999, el duplicado, el nivel `critico` y el motivo en blanco. Después desconecté el servidor y lo conecté de nuevo: la misma alerta de INC-003 volvió a aceptarse. La comprobación adicional se puede repetir con:

```powershell
.\.venv\Scripts\python.exe mcp-detective/verificar_stdio.py
```

Para conectar Codex, se reemplaza `C:/ruta/al/repositorio` por la ruta absoluta de la copia local:

```powershell
codex mcp add detective -- "C:/ruta/al/repositorio/.venv/Scripts/python.exe" "C:/ruta/al/repositorio/mcp-detective/server.py"
```

Luego se inicia una sesión nueva y se pide listar y consultar los casos mediante MCP. No hace falta ningún token para este servidor local. La configuración de stdio sigue la [documentación oficial de OpenAI](https://learn.chatgpt.com/docs/extend/mcp).

## Verificación del código

Las tres herramientas están registradas con `@mcp.tool` y tienen tipos y docstrings en español. La ruta de `casos.json` se resuelve desde `__file__`. La lógica está separada en `Centinela`, y las pruebas crean una instancia nueva para no compartir alertas entre ellas. Pasaron **18 pruebas** con Python 3.12.16, MCP 2.3.0 y pytest 9.2.0.

MCP 2.3.0 oculta el mensaje de un `ValueError` común. Por eso usé `ErrorValidacion`, que hereda de `ValueError` y de `ToolError`: sigue cumpliendo las pruebas con `pytest.raises(ValueError)` y permite que el cliente reciba el motivo del rechazo. Este comportamiento está documentado en el [manejo de errores del SDK](https://py.sdk.modelcontextprotocol.io/servers/handling-errors/).

Las capturas y los archivos originales de las ejecuciones están en [evidencias/](evidencias/README.md).

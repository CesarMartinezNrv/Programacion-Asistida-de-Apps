"""Verificación adicional real por stdio; no sustituye las capturas de Inspector."""

import asyncio
import json
import sys
from pathlib import Path

from mcp import Client
from mcp.client.stdio import StdioServerParameters


async def main() -> None:
    ruta = Path(__file__).resolve().with_name("server.py")
    parametros = StdioServerParameters(command=sys.executable, args=[str(ruta)], cwd=str(ruta.parent.parent))
    traza = []

    async def llamada(cliente, nombre, argumentos, error=False):
        resultado = await cliente.call_tool(nombre, argumentos)
        registro = {"tool": nombre, "argumentos": argumentos, "resultado": resultado.model_dump(mode="json", by_alias=True)}
        traza.append(registro)
        assert bool(resultado.is_error) == error, registro
        if error:
            texto = " ".join(item.text for item in resultado.content if item.type == "text")
            assert any(mensaje in texto for mensaje in ("no existe", "duplicados", "bajo, medio o alto", "motivo")), texto
        return resultado

    argumentos = {"caso_id": "INC-003", "nivel": "alto", "motivo": "Cuatro fallos y un acceso exitoso desde la misma IP; requiere investigación"}
    async with Client(parametros) as cliente:
        tools = await cliente.list_tools()
        assert {tool.name for tool in tools.tools} == {"listar_casos", "consultar_eventos", "registrar_alerta"}
        traza.append({"discovery": tools.model_dump(mode="json", by_alias=True)})
        await llamada(cliente, "listar_casos", {})
        await llamada(cliente, "consultar_eventos", {"caso_id": "INC-002"})
        await llamada(cliente, "consultar_eventos", {"caso_id": "INC-999"}, error=True)
        await llamada(cliente, "registrar_alerta", argumentos)
        await llamada(cliente, "registrar_alerta", argumentos, error=True)
        await llamada(cliente, "registrar_alerta", {"caso_id": "INC-002", "nivel": "critico", "motivo": "Intentos repetidos"}, error=True)
        await llamada(cliente, "registrar_alerta", {"caso_id": "INC-002", "nivel": "medio", "motivo": "   "}, error=True)
    async with Client(parametros) as cliente_nuevo:
        await llamada(cliente_nuevo, "registrar_alerta", argumentos)
        traza.append({"reinicio": "Nueva instancia: la misma alerta vuelve a aceptarse."})
    salida = ruta.parent.parent / "evidencias" / "stdio.json"
    salida.write_text(json.dumps(traza, ensure_ascii=False, indent=2), encoding="utf-8")
    print("Discovery: exactamente 3 tools. D1-D7 correctos por MCP stdio.")
    print("Duplicado rechazado en el mismo proceso; aceptado tras reiniciar el servidor.")


if __name__ == "__main__":
    asyncio.run(main())

"""Servidor local de Centinela: consulta datos y registra alertas en memoria."""

import json
from pathlib import Path

from mcp.server import MCPServer
from mcp.server.mcpserver.exceptions import ToolError
from mcp.types import ToolAnnotations


class ErrorValidacion(ValueError, ToolError):
    """Es ValueError y permite que MCP v2 comunique el motivo al cliente."""


class Centinela:
    """Mantiene los casos y las alertas de una instancia del servidor."""

    def __init__(self) -> None:
        ruta = Path(__file__).resolve().with_name("casos.json")
        self._casos = json.loads(ruta.read_text(encoding="utf-8"))
        self._alertas: dict[str, dict] = {}

    def _validar_caso(self, caso_id: str) -> None:
        if not isinstance(caso_id, str) or caso_id not in self._casos:
            raise ErrorValidacion(f"El caso {caso_id!r} no existe.")

    def listar_casos(self) -> list[dict]:
        """Devuelve identificadores, sistemas y cantidades, sin interpretarlos."""
        return [
            {"id": clave, "sistema": caso["sistema"], "cantidad_eventos": len(caso["eventos"])}
            for clave, caso in self._casos.items()
        ]

    def consultar_eventos(self, caso_id: str) -> list[dict]:
        """Devuelve copias de los eventos exactos o rechaza un caso inexistente."""
        self._validar_caso(caso_id)
        return [dict(evento) for evento in self._casos[caso_id]["eventos"]]

    def registrar_alerta(self, caso_id: str, nivel: str, motivo: str) -> dict:
        """Valida los argumentos y guarda una sola alerta por caso en memoria."""
        self._validar_caso(caso_id)
        if not isinstance(nivel, str) or nivel not in ("bajo", "medio", "alto"):
            raise ErrorValidacion("El nivel debe ser bajo, medio o alto.")
        if not isinstance(motivo, str) or not motivo.strip():
            raise ErrorValidacion("El motivo debe ser texto y no puede estar vacío ni contener solo espacios.")
        if caso_id in self._alertas:
            raise ErrorValidacion(f"Ya existe una alerta para {caso_id}; no se permiten duplicados.")
        alerta = {"caso_id": caso_id, "nivel": nivel, "motivo": motivo, "estado": "registrada"}
        self._alertas[caso_id] = alerta
        return dict(alerta)


mcp = MCPServer("MCP Detective")
centinela = Centinela()


@mcp.tool(annotations=ToolAnnotations(read_only_hint=True, open_world_hint=False))
def listar_casos() -> list[dict]:
    """Lista el id, sistema y cantidad de eventos de cada caso, sin conclusiones."""
    return centinela.listar_casos()


@mcp.tool(annotations=ToolAnnotations(read_only_hint=True, open_world_hint=False))
def consultar_eventos(caso_id: str) -> list[dict]:
    """Consulta los eventos exactos de un caso; falla si el identificador no existe."""
    return centinela.consultar_eventos(caso_id)


@mcp.tool(annotations=ToolAnnotations(read_only_hint=False, destructive_hint=False, open_world_hint=False))
def registrar_alerta(caso_id: str, nivel: str, motivo: str) -> dict:
    """Registra una alerta en memoria, validando caso, nivel, motivo y duplicados."""
    return centinela.registrar_alerta(caso_id, nivel, motivo)


if __name__ == "__main__":
    mcp.run(transport="stdio")

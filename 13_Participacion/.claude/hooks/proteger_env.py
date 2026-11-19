"""Filtro de eventos JSON y puerta local explícita; no es un hook nativo de Codex.

stdin: {tool_name, tool_input}; salida 0 permite, 2 bloquea.
--ejecutar RAIZ: valida y despacha una operación dentro del laboratorio.
Sin ese argumento solo clasifica; nunca ejecuta el comando recibido.
"""
import json
from pathlib import Path
import re
import subprocess
import sys


def cadenas(valor):
    if isinstance(valor, str):
        yield valor
    elif isinstance(valor, dict):
        for clave, dato in valor.items():
            yield str(clave)
            yield from cadenas(dato)
    elif isinstance(valor, list):
        for dato in valor:
            yield from cadenas(dato)


def validar(evento):
    if not isinstance(evento, dict):
        raise ValueError("evento no es un objeto")
    if evento.get("tool_name") not in {
        "Read", "Edit", "Write", "Bash", "PowerShell", "exec_command"
    }:
        raise ValueError("herramienta no autorizada")
    datos = evento.get("tool_input")
    if not isinstance(datos, dict) or not datos:
        raise ValueError("tool_input inválido")
    for cadena in cadenas(datos):
        normal = cadena.casefold().replace("\\", "/")
        if re.search(r"\.env(?![\w])|verificar_entorno\.py", normal):
            raise ValueError("recurso protegido; operación bloqueada antes del acceso")
    return datos


def ejecutar(evento, datos, raiz):
    raiz = Path(raiz).resolve(strict=True)
    herramienta = evento["tool_name"]
    if herramienta in {"Bash", "PowerShell", "exec_command"}:
        comando = datos.get("command", datos.get("cmd"))
        if comando not in {"python -m unittest", "python -m unittest discover"}:
            raise ValueError("comando fuera de la lista permitida")
        print("PERMITIDO: unittest; shell=False", flush=True)
        return subprocess.run(
            [sys.executable, "-m", "unittest", "discover"], cwd=raiz, check=False
        ).returncode
    nombre = datos.get("file_path")
    if nombre not in {"calculadora.py", "test_calculadora.py", "README.md"}:
        raise ValueError("archivo fuera de la lista permitida")
    ruta = (raiz / nombre).resolve(strict=True)
    if ruta.parent != raiz:
        raise ValueError("ruta fuera del laboratorio")
    if herramienta == "Read":
        print(ruta.read_text(encoding="utf-8"))
    elif herramienta == "Write":
        ruta.write_text(datos["content"], encoding="utf-8")
    elif herramienta == "Edit":
        texto = ruta.read_text(encoding="utf-8")
        anterior, nuevo = datos["old_string"], datos["new_string"]
        if not anterior or texto.count(anterior) != 1:
            raise ValueError("edición debe tener una coincidencia exacta")
        ruta.write_text(texto.replace(anterior, nuevo, 1), encoding="utf-8")
    print("PERMITIDO: " + herramienta + " " + nombre)
    return 0


def main():
    try:
        evento = json.load(sys.stdin)
        datos = validar(evento)
        if len(sys.argv) == 1:
            return 0
        if len(sys.argv) != 3 or sys.argv[1] != "--ejecutar":
            raise ValueError("uso: proteger_env.py [--ejecutar RAIZ]")
        return ejecutar(evento, datos, sys.argv[2])
    except (ValueError, OSError, KeyError, TypeError) as error:
        print("BLOQUEADO: " + str(error), file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())

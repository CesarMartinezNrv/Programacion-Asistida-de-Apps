# Configuración del guardrail — Participación 13

Autor: César Martínez. Fecha: 19 de noviembre de 2026.

## Control utilizado y alcance

La conexión automática está registrada en **`.claude/settings.json`**:

- Evento: `PreToolUse`, antes de ejecutar la herramienta.
- Matcher: `Read|Edit|Write|Bash|PowerShell`.
- Handler: `type: command`, `shell: powershell`, ejecución síncrona, timeout de 10 s.
- Script: `.claude/hooks/proteger_env.py`, referenciado mediante
  `$env:CLAUDE_PROJECT_DIR` para admitir espacios en la ruta y cambios de directorio.
- Se invoca sin `--ejecutar`: recibe el evento JSON por stdin, valida y devuelve 0
  para continuar o 2 para bloquear. Claude despacha la operación; el hook no la duplica.

El comando usa la ruta absoluta al Python disponible en esta computadora porque el
comando `python` del PATH apunta a un alias de Windows que no funciona aquí. En otra
computadora se debe ajustar esa ruta al intérprete instalado. No contiene credenciales.
No se modificaron ajustes globales ni se desactivaron permisos o aprobaciones.

## Cómo cargar y verificar la conexión automática

1. Inicia Claude Code desde `C:\Programacion de apps\13_Participacion`.
2. Inicia sesión si Claude lo solicita y revisa la configuración del proyecto.
3. Abre `/hooks` y comprueba que PreToolUse enumera el handler registrado.
4. Prueba una lectura de `calculadora.py` y un intento sobre un `.env` ficticio de
   laboratorio: el primero debe continuar y el segundo debe recibir el bloqueo.

Se detectó Claude Code **2.1.259**. `claude doctor`, ejecutado desde esta carpeta,
terminó con código 0 y `No installation issues found`, pero informó que no hay una
sesión de claude.ai iniciada. Por ello **no se ha observado todavía el disparo del
hook en una conversación autenticada de Claude**; el registro está escrito y su
comando exacto se probó localmente con nueve eventos. No se afirma que doctor pruebe
la ejecución del hook ni que una sesión de Codex cargue esta configuración.

Fuentes oficiales revisadas:
[Hooks](https://code.claude.com/docs/en/hooks) y
[Settings](https://code.claude.com/docs/en/settings).

CLAUDE.md contiene instrucciones; settings.json registra el handler; proteger_env.py
aplica la política. El modo manual `--ejecutar RAIZ` se conserva para reproducir las
pruebas anteriores fuera de Claude.

## Evento y herramientas

```json
{"tool_name":"Read","tool_input":{"file_path":".env"}}
```

Acepta `Read`, `Edit`, `Write`, `Bash`, `PowerShell` y `exec_command`.
Recorre los campos de `tool_input`, incluidas listas y objetos anidados, con comparación
sin distinción de mayúsculas. Bloquea menciones literales de `.env` y
`verificar_entorno.py`. Entrada inválida o herramienta desconocida: código 2.
Sin argumentos solo clasifica: 0 permite, 2 bloquea; **no ejecuta el evento**.
El campo `hook_event_name: PreToolUse` del banco docente es metadato compatible con
la entrada de este filtro. En la conexión automática es el evento de Claude; en
las pruebas manuales es un evento de ejemplo, no un evento emitido por Codex.

En modo `--ejecutar`, además:

- Solo admite los archivos `calculadora.py`, `test_calculadora.py` y `README.md`,
  directamente dentro de la raíz resuelta. Rechaza rutas que resuelven fuera de ella.
- La edición exige una única coincidencia del texto anterior.
- Solo permite los comandos exactos `python -m unittest` y
  `python -m unittest discover`. Los traduce a una lista de argumentos usando el
  intérprete actual y `shell=False`. Nunca invoca Bash ni PowerShell.

## Reproducción desde esta entrega

Se requiere Python 3.9 o superior. En PowerShell, desde `13_Participacion`, preparar
una copia temporal del repositorio docente; estos archivos temporales no son entregables:

```powershell
git clone https://github.com/jdVegaS24/calculadora-seguridad-agentic-s13.git _laboratorio
git -C _laboratorio checkout 3dcac890e6cedc285e6655a151979053557b0ac6
Copy-Item _laboratorio/env_falso.txt _laboratorio/.env
git -C _laboratorio check-ignore .env

Push-Location _laboratorio
python -m unittest discover
python .claude/hooks/probar_hook.py .claude/hooks/proteger_env_plantilla.py
python .claude/hooks/probar_hook.py ../.claude/hooks/proteger_env.py
python variantes/auditar_unicode.py INSTALAR.md variantes/README_unicode_demo.md
Pop-Location
```

Los dos primeros bancos sobre el original fallan como se documenta en `evidencias.md`.
Para comprobar la puerta, el bloqueo y la operación permitida:

```powershell
'{"tool_name":"Read","tool_input":{"file_path":".env"}}' | python .claude/hooks/proteger_env.py --ejecutar _laboratorio
# exit 2; no llega a abrir el archivo
'{"tool_name":"Read","tool_input":{"file_path":"calculadora.py"}}' | python .claude/hooks/proteger_env.py --ejecutar _laboratorio
# exit 0
Copy-Item calculadora.py _laboratorio/calculadora.py
'{"tool_name":"exec_command","tool_input":{"cmd":"python -m unittest discover"}}' | python .claude/hooks/proteger_env.py --ejecutar _laboratorio
# exit 0; ocho tests pasan
```

Durante la sesión original la reparación se hizo con `Edit` a través de la puerta,
reemplazando la línea con divisor `len(numeros) + 1` por `len(numeros)`.
La copia anterior solo facilita reproducir el resultado desde los entregables finales.

## Aprobación y límites

Se mantuvieron los permisos del entorno; la descarga del repositorio requirió la vía
de aprobación del sandbox. No se autorizaron accesos a secretos ni acciones del README.
Se revisó el script antes de usarlo. La aprobación automática de una descarga no
equivale a una aprobación humana manual del guardrail; no se inventa ese paso.

La puerta no es un sandbox de procesos: los tests permitidos son código y pueden
crear subprocesos. Se revisaron los tests docentes antes de permitirlos. En particular,
uno ejecuta una copia del simulador en un directorio temporal con un canario ficticio;
esto es una prueba legítima del docente, no una ejecución ordenada por el README.
El control no media esa llamada interna. Para código arbitrario se necesita aislamiento
del sistema operativo y revisión de los archivos que se vayan a ejecutar.

## Límites de la conexión automática

La configuración cubre las cinco herramientas del matcher, no todas las herramientas
posibles (por ejemplo, Grep o herramientas MCP). El filtro sigue siendo literal y no
inspecciona los subprocesos de un comando permitido. El modo automático usa el filtro;
la lista estricta de comandos pertenece únicamente al modo manual `--ejecutar`.

La documentación actual ofrece `onFailure: block` desde la versión 2.1.295, superior a
la 2.1.259 instalada. No se añadió ese campo incompatible. No se garantiza bloqueo si
el intérprete no arranca, el hook falla o agota su tiempo: no equivale a un sandbox.

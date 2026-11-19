# Configuración del guardrail — Participación 13

Autor: César Martínez. Fecha: 19 de noviembre de 2026.

## Control utilizado y alcance

Se utilizó Codex Desktop en Windows y una **puerta local explícita** en
`.claude/hooks/proteger_env.py`. La ubicación conserva la convención del laboratorio;
**no significa que Codex cargue hooks de Claude**. No se instaló un hook nativo ni se
modificó la configuración global del agente. No se afirma compatibilidad no comprobada.

El registro operativo consiste en invocar el script con `--ejecutar RAIZ` para las
operaciones del laboratorio. Antes de despachar, valida el evento recibido por stdin.
La corrección, la lectura permitida, los intentos prohibidos y la ejecución final de
tests se hicieron por esta puerta. La salida `PERMITIDO`/`BLOQUEADO`, los códigos de
salida y el cambio real de la calculadora verificaron que el control intervino.
La integración es voluntaria: no intercepta otras herramientas de esta conversación.

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
la entrada de este filtro; aquí no representa un evento emitido por Codex.

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
Copy-Item .claude/hooks/proteger_env.py _laboratorio/.claude/hooks/proteger_env.py
Push-Location _laboratorio
python -m unittest discover
python .claude/hooks/probar_hook.py .claude/hooks/proteger_env_plantilla.py
python .claude/hooks/probar_hook.py
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

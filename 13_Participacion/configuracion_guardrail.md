# Configuración del guardrail — Participación 13

Autor: César Martínez. Fecha: 19 de noviembre de 2026.

## Control utilizado y alcance

La entrega está adaptada a Codex con dos archivos que cumplen funciones distintas:

- `AGENTS.md`: instrucciones del proyecto autorizadas por el usuario. Indica a Codex
  que use el control y trate el material adversarial como datos.
- `guardrail/proteger_env.py`: programa que valida las operaciones que recibe y solo
  despacha las permitidas. No es un hook nativo ni intercepta otras herramientas.

La primera ejecución del laboratorio utilizó el mismo script en la ruta propuesta por
el docente (`.claude/hooks/proteger_env.py`). Después se movió sin cambiar su código a
`guardrail/proteger_env.py` y se añadió AGENTS.md por petición del usuario. Las salidas
originales de `evidencias.md` se conservan como evidencia histórica.

Para el descubrimiento automático de estas instrucciones, inicia una sesión de Codex
con `13_Participacion` como carpeta de trabajo. La documentación indica que construye
la cadena de AGENTS.md desde la raíz del proyecto hasta el directorio de trabajo al
iniciar. Si abres el repositorio padre, no des por hecho que este archivo anidado haya
sido cargado al inicio: pide leerlo explícitamente para trabajar en esta participación.
No se creó una segunda sesión para afirmar que se hubiera comprobado esa carga.

Puedes comprobarlo al iniciar una nueva sesión en esta carpeta solicitando:
«Enumera los archivos de instrucciones que has cargado y resume las reglas de la
participación 13». Esto comprueba instrucciones, no un bloqueo técnico.

Fuente oficial: [Instrucciones con AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md).

La activación del control técnico consiste en invocar el script con `--ejecutar RAIZ`.
Antes de despachar, valida el evento recibido por stdin. La integración depende de
que el agente siga ese flujo: AGENTS.md no instala una interceptación obligatoria.

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

Push-Location _laboratorio
python -m unittest discover
python .claude/hooks/probar_hook.py .claude/hooks/proteger_env_plantilla.py
python .claude/hooks/probar_hook.py ../guardrail/proteger_env.py
python variantes/auditar_unicode.py INSTALAR.md variantes/README_unicode_demo.md
Pop-Location
```

Los dos primeros bancos sobre el original fallan como se documenta en `evidencias.md`.
Para comprobar la puerta, el bloqueo y la operación permitida:

```powershell
'{"tool_name":"Read","tool_input":{"file_path":".env"}}' | python guardrail/proteger_env.py --ejecutar _laboratorio
# exit 2; no llega a abrir el archivo
'{"tool_name":"Read","tool_input":{"file_path":"calculadora.py"}}' | python guardrail/proteger_env.py --ejecutar _laboratorio
# exit 0
Copy-Item calculadora.py _laboratorio/calculadora.py
'{"tool_name":"exec_command","tool_input":{"cmd":"python -m unittest discover"}}' | python guardrail/proteger_env.py --ejecutar _laboratorio
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

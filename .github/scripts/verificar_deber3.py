"""Ejecuta commits históricos y conserva transcripciones reales de CI."""
from pathlib import Path
import os
import subprocess
import tempfile
import textwrap
from PIL import Image, ImageDraw, ImageFont

ROOT = Path.cwd()
PROJECT = ROOT / '07_Participacion/divisor_cuenta'
OUT = PROJECT / 'evidencias'

def run(args, cwd=PROJECT, expected=0):
    p = subprocess.run(args, cwd=cwd, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    print(p.stdout, flush=True)
    if p.returncode != expected:
        raise RuntimeError(f'{args}: salida {p.returncode}, esperada {expected}')
    return '$ ' + ' '.join(args) + '\n' + p.stdout

def evidence(name, text):
    (OUT / (name + '.txt')).write_text(text, encoding='utf-8')
    # Imagen de transcripción, identificada como tal; no simula una terminal local.
    lines = ['TRANSCRIPCIÓN REAL — GitHub Actions (Ubuntu)', '']
    for line in text.splitlines():
        lines.extend(textwrap.wrap(line, 125, replace_whitespace=False) or [''])
    font = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf', 14)
    im = Image.new('RGB', (1120, max(120, 24 + 20 * len(lines))), '#101820')
    draw = ImageDraw.Draw(im)
    for i, line in enumerate(lines):
        draw.text((16, 12 + 20 * i), line, font=font, fill='#e8f1f5')
    im.save(OUT / (name + '.png'))

for commit, name, expected in [
    ('0e14e00', 'parte1_verde', 0),
    ('7119c6d', 'parte2_rojo', 1),
    ('3f7bc31', 'parte3_verde', 0),
]:
    with tempfile.TemporaryDirectory() as tmp:
        run(['git', 'worktree', 'add', '--detach', tmp, commit], ROOT)
        path = Path(tmp) / '07_Participacion/divisor_cuenta'
        try:
            run(['flutter', 'pub', 'get'], path)
            output = run(['flutter', 'test', '--reporter', 'expanded'], path, expected)
            if expected:
                assert 'La propina no puede superar el 100%' in output and 'Actual: <null>' in output
            evidence(name, output)
        finally:
            run(['git', 'worktree', 'remove', '--force', tmp], ROOT)

run(['flutter', 'pub', 'get'])
clean = run(['flutter', 'analyze'])
main = PROJECT / 'lib/main.dart'
original = main.read_text()
try:
    main.write_text(original.replace('void main() => runApp(crearAplicacion());', "void main() {\n  final variableSinUso = 1;\n  print('hola');\n  runApp(crearAplicacion());\n}"))
    p = subprocess.run(['flutter', 'analyze'], cwd=PROJECT, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    assert p.returncode != 0 and 'unused_local_variable' in p.stdout and 'avoid_print' in p.stdout
    evidence('parte4_analyze', '$ flutter analyze\n' + p.stdout)
finally:
    main.write_text(original)
evidence('parte4_limpio', run(['flutter', 'analyze']))
evidence('parte6_refactor', run(['git', 'diff', '3f7bc31', '971c62d', '--', 'lib/']) + run(['flutter', 'test', '--reporter', 'expanded']))
output = run(['flutter', 'test', '--coverage', '--reporter', 'expanded'])
records = {}
for record in (PROJECT / 'coverage/lcov.info').read_text().split('end_of_record'):
    fields = dict(line.split(':', 1) for line in record.splitlines() if line.startswith(('SF:', 'LF:', 'LH:')))
    if 'SF' in fields:
        records[fields['SF'].replace('\\', '/')] = (int(fields['LH']), int(fields['LF']))
rows = []
measured = []
for path in sorted((PROJECT / 'lib').rglob('*.dart')):
    key = path.relative_to(PROJECT).as_posix()
    values = next((v for k, v in records.items() if k == key or k.endswith('/' + key)), None)
    if values:
        hit, total = values
        pct = 100 * hit / total if total else 100
        rows.append(f'| `{key}` | {hit}/{total} | {pct:.2f}% |')
        measured.append((pct, key))
    else:
        rows.append(f'| `{key}` | — | No medido |')
table = '| Archivo | Líneas cubiertas | Cobertura |\n|---|---:|---:|\n' + '\n'.join(rows)
(OUT / 'cobertura.md').write_text(table + '\n')
evidence('parte7_coverage', output + '\n' + table)
evidence('parte8_log', run(['git', 'log', '--oneline', '-8'], ROOT))
lowest = min(p for p, _ in measured)
names = ', '.join('`' + key + '`' for pct, key in measured if pct == lowest)
(PROJECT / 'respuestas.md').write_text(f'''# Deber 3 — Respuestas

Verificación real en GitHub Actions, con Flutter 3.47.1. Se reprodujeron los commits de cada etapa después de escribir los cambios, porque Windows bloqueó dartvm.exe. Por tanto, el rojo se verificó retrospectivamente; no afirmo que se ejecutó antes de implementar.

1. **Rojo antes de verde.** La prueba de propina 150% esperaba `La propina no puede superar el 100%` y recibió `Actual: <null>`. Ver ese fallo demuestra que la prueba detecta la regla ausente. La prueba con exactamente 100% protege el límite permitido. El fallo se reprodujo sobre el commit que contiene solo las pruebas nuevas.

2. **Linter vs. IA.** Al introducir temporalmente una variable sin uso y `print('hola')`, aparecieron `unused_local_variable` y `avoid_print`. Después retiré ambas líneas y el análisis quedó limpio. La IA identificó el número mágico 100 del límite de propina; el linter no lo marcó porque es un literal válido cuyo significado depende de la regla de negocio.

3. **Refactorización.** Elegí el número mágico y lo reemplacé por la constante `propinaMaxima = 100`. La comparación continúa siendo `>` y el mensaje no cambió. Las mismas pruebas pasaron después del refactor, sin modificar sus expectativas.

4. **Coverage.** La menor cobertura medida corresponde a {names}, con {lowest:.2f}%. Eso indica qué líneas ejecutaron las pruebas, no demuestra errores. Una cobertura alta tampoco garantiza que se hayan comprobado todos los comportamientos. Los archivos ausentes del informe se señalan como no medidos.

{table}
''', encoding='utf-8')
(OUT / 'RESULTADOS.md').write_text('''# Verificación completada

Las partes 1, 2 y 3 se ejecutaron sobre sus commits históricos. El rojo fue reproducido retrospectivamente, tras el bloqueo local de Windows. La ejecución final incluye análisis limpio, pruebas y cobertura.

Los PNG son imágenes de las transcripciones reales de GitHub Actions, generadas sin modificar su salida; no son capturas de una terminal local. Se conservan también los TXT para revisar el contenido completo. El README anterior documenta el bloqueo original; sus pasos pendientes quedan sustituidos por estos resultados.

No se necesitó un commit de correcciones de linter: los avisos se introdujeron y retiraron temporalmente para la demostración.
''')

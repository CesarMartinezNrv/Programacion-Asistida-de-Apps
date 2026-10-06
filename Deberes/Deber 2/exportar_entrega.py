from pathlib import Path
import subprocess, shutil, hashlib, json

base=Path(__file__).parent.resolve()
web=base/'divisor_cuenta_web'
destino=base/'divisor_cuenta_web_entrega'
archivos=subprocess.run(['git','ls-files','--cached','--others','--exclude-standard','-z'],cwd=web,capture_output=True,check=True).stdout.decode('utf8').split('\0')
copiados=[]
for nombre in sorted(set(archivos)):
    if not nombre: continue
    relativa=Path(nombre)
    assert not relativa.is_absolute() and '..' not in relativa.parts and '.git' not in relativa.parts
    origen=web/relativa
    if not origen.is_file(): continue
    salida=destino/relativa
    salida.parent.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(origen,salida)
    assert hashlib.sha256(origen.read_bytes()).digest()==hashlib.sha256(salida.read_bytes()).digest()
    copiados.append(nombre)
(base/'entrega').mkdir(exist_ok=True)
(base/'entrega/exportacion.json').write_text(json.dumps({'origen':'divisor_cuenta_web','destino':'divisor_cuenta_web_entrega','archivos':copiados,'todos_hashes_identicos':True},ensure_ascii=False,indent=2),encoding='utf8')
print(f'Exportación exacta: {len(copiados)} archivos; sin node_modules, dist ni .git')

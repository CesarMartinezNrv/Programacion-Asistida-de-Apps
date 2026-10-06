from pathlib import Path
from datetime import datetime
import subprocess, json, hashlib, re, math

base=Path(__file__).parent
web=base/'divisor_cuenta_web'
flutter=base/'divisor_cuenta'
feature=web/'specs/001-dividir-cuenta'
evidencia=web/'evidencias'
def guardar(ruta,texto):
    ruta.parent.mkdir(parents=True,exist_ok=True)
    ruta.write_text(texto.rstrip()+'\n',encoding='utf8')
def leer(ruta): return ruta.read_text(encoding='utf-8-sig')
def hora(nombre): return datetime.fromisoformat(leer(evidencia/nombre).strip())
inicio=hora('inicio-react.txt'); primero=hora('primera-compilacion.txt'); fin=hora('fin-seis-casos.txt')
minbuild=(primero-inicio).total_seconds()/60
mincasos=(fin-inicio).total_seconds()/60
inv=json.loads(leer(evidencia/'inventario.json'))
cantidad=len(inv['spec']); consttotal=len(inv['constitution']); modificadas=consttotal-inv['counts']['idéntica']

# Comparación efectiva; el diff original también se comprobó antes de planificar.
for nombre in ['spec-inicial.diff','spec-final.diff']:
    salida=subprocess.run(['git','diff','--no-index','--',str(flutter/'specs/001-dividir-cuenta/spec.md'),str(feature/'spec.md')],capture_output=True)
    assert salida.returncode==0 and not salida.stdout
    (evidencia/nombre).write_bytes(salida.stdout)
hashes={str(p.relative_to(base)):hashlib.sha256(p.read_bytes()).hexdigest() for p in [flutter/'specs/001-dividir-cuenta/spec.md',feature/'spec.md']}
assert len(set(hashes.values()))==1
guardar(evidencia/'spec-identidad.txt','Comando: git diff --no-index -- <Flutter>/specs/001-dividir-cuenta/spec.md <React>/specs/001-dividir-cuenta/spec.md\nExit code: 0\nstdout: vacío (0 bytes)\n\nSHA256:\n'+'\n'.join(f'{k}: {v}' for k,v in hashes.items()))
original=subprocess.run(['git','show','sdd:07_Participacion/divisor_cuenta/specs/001-dividir-cuenta/spec.md'],cwd=base,capture_output=True,check=True).stdout
inicial=subprocess.run(['git','show','6cce762:specs/001-dividir-cuenta/spec.md'],cwd=web,capture_output=True,check=True).stdout
assert original==inicial
guardar(evidencia/'spec-inicial-historial.txt','Comparación de objetos Git: sdd:07_Participacion/divisor_cuenta/specs/001-dividir-cuenta/spec.md y React 6cce762:specs/001-dividir-cuenta/spec.md\nResultado: contenido idéntico. No se regeneró la spec.\nSHA256 Git normalizado: '+hashlib.sha256(original).hexdigest())

# Un inventario explícito evita confundir líneas físicas con decisiones del plan.
plan=[
('Flutter estable','React con Vite','reemplazado'),('Una pantalla','Una pantalla','intacto'),
('setState','useState','reemplazado'),('Dependencias por constructor','Props y argumento del hook','adaptado'),
('Cálculo puro','Cálculo puro','intacto'),('Estrategia de redondeo intercambiable','Estrategia de redondeo intercambiable','intacto'),
('Dart 3.13.1','JavaScript ES modules / Node 24.19.0','reemplazado'),
('Dependencias SDK Flutter, sin paquetes adicionales','React, Vite y herramientas de pruebas','reemplazado'),
('Sin storage','Sin storage','intacto'),('flutter_test widgets','Testing Library + jsdom','reemplazado'),
('test_api para dominio','Vitest para dominio','reemplazado'),('Android y web','Navegador web','reemplazado'),
('App móvil','Página estática','reemplazado'),('Cálculo síncrono constante','Cálculo síncrono constante','intacto'),
('Sin operaciones de red','Sin operaciones de red','intacto'),('Offline','Offline durante uso','intacto'),
('No modificar android/ios','React no genera carpetas nativas','reemplazado'),
('No agregar paquetes','Stack npm autorizado, sin librerías de estado','reemplazado'),
('Tres entradas, dos modos y un resultado','Tres entradas, dos modos y un resultado','intacto'),
('SRP separa cálculo/validación/formato','SRP separa cálculo/validación/formato','intacto'),
('OCP usa interfaz Dart','OCP usa contrato estructural','adaptado'),('LSP sin casts','LSP sin casts','intacto'),
('ISP un método','ISP aplicar(valor)','adaptado'),('DIP presentación solo dominio','DIP presentación solo dominio','intacto'),
('Composición en main','Composición en main.jsx','adaptado'),
('Objetos de valor y widgets en consumidores','Objetos de valor y JSX en consumidores','adaptado'),
('Dominio no importa flutter_test ni motor','Dominio no importa React, DOM ni data','adaptado'),
('No secretos','No secretos','intacto'),('No persistencia','No persistencia','intacto'),
('Casos críticos en pruebas','Casos críticos en pruebas','intacto'),
('lib/domain/cuenta.dart','src/domain/cuenta.js','adaptado'),('lib/domain/resultado.dart','src/domain/resultado.js','adaptado'),
('lib/domain/estrategia_redondeo.dart','src/domain/estrategiaRedondeo.js','adaptado'),
('lib/domain/calcular_division.dart','src/domain/calcularDivision.js','adaptado'),
('lib/domain/validar_entrada.dart','src/domain/validarEntrada.js','adaptado'),
('lib/data/redondeo_exacto.dart','src/data/redondeoExacto.js','adaptado'),
('lib/data/redondeo_hacia_arriba.dart','src/data/redondeoHaciaArriba.js','adaptado'),
('lib/presentation/divisor_controller.dart','src/presentation/useDivisor.js','adaptado'),
('lib/presentation/formateador_moneda.dart','src/presentation/formateadorMoneda.js','adaptado'),
('lib/presentation/pantalla_divisor.dart','src/presentation/PantallaDivisor.jsx','adaptado'),
('lib/main.dart','src/main.jsx','adaptado'),
('test/casos_de_prueba.dart','test/casosDePrueba.js','adaptado'),('test/division_test.dart','test/division.test.js','adaptado'),
('test/pantalla_test.dart','test/pantalla.test.jsx','adaptado'),('test/entrada_test.dart','test/entrada.test.js','adaptado'),
('tool/verificar_domain.dart','tool/verificarArquitectura.js y Vitest','reemplazado'),
('Controller convierte texto, valida, calcula y expone estado','Hook convierte texto, valida, calcula y expone estado','adaptado'),
('Pantalla recibe controller/formateador por constructor','Pantalla recibe servicios por props; hook estático','adaptado'),
('main crea validación, cálculo, estrategias, controller y formateador','main compone validación, cálculo, estrategias y formato; hook mantiene estado','adaptado'),
('ValidarEntrada devuelve String? y null válido','validarEntrada devuelve string/null','adaptado'),
('(importe * 100).round() / 100','Math.round(importe * 100) / 100','adaptado'),
('CalcularDivision devuelve Resultado sin validar/formatear','calcularDivision devuelve resultado sin validar/formatear','adaptado'),
('Controller rechaza desbordamiento antes de calcular','Hook rechaza desbordamiento antes de calcular','adaptado'),
('Bloqueo flutter_tester: intentar Chrome y Dart puro','React Vitest/jsdom + Chrome real; problema Flutter documentado aparte','reemplazado')]
planmod=sum(x[2]!='intacto' for x in plan)
pdiff=subprocess.run(['git','diff','--no-index','--numstat','--',str(evidencia/'plan-flutter.md'),str(feature/'plan.md')],capture_output=True,text=True)
linea=pdiff.stdout.strip().split('\t'); anadidas=int(linea[0]); eliminadas=int(linea[1])
tabla='# Inventario de decisiones del plan\n\nSe cuenta cada decisión independiente del plan original, incluidos archivos concretos como decisiones de estructura. Se separan frases con varias decisiones. Las referencias a otros documentos no se cuentan; su contenido se evalúa en su artefacto. Las rutas agrupadas y exclusiones son decisiones distintas. El cálculo no deduplica ideas repetidas en resumen y diseño.\n\n| ID | Flutter | React | Resultado |\n|---|---|---|---|\n'
for i,(a,b,c) in enumerate(plan,1): tabla+=f'| P{i:02d} | {a} | {b} | {c} |\n'
tabla+=f'\nTotal: {len(plan)} enunciados; modificados/adaptados: {planmod}; intactos: {len(plan)-planmod}. No se agregan como originales las nuevas decisiones React de formato grande, parseo estricto o CSS; se describen en el plan nuevo y se justifican por FR-004, entradas inválidas y presentación.\n\nDiff físico: {anadidas} líneas añadidas y {eliminadas} eliminadas ({anadidas+eliminadas} operaciones de línea); NO equivale a {anadidas+eliminadas} decisiones ni a un número único de líneas reemplazadas. La guía alterna ambas métricas; se reportan separadas.\n'
guardar(web/'analisis_plan.md',tabla)

# Verificación independiente de igualdad semántica de los seis escenarios.
dart=leer(evidencia/'casos-flutter.dart')
originales=[]
for bloque in re.findall(r'CasoDivision\(\s*nombre:(.*?)\n\s*\)',dart,re.S):
    d={}
    for clave,valor in re.findall(r"(nombre|monto|personas|propina|modo|esperado|errorEsperado):\s*([^\n]+),", 'nombre:'+bloque):
        valor=valor.strip()
        d[clave]=valor[1:-1] if valor.startswith("'") else ('NaN' if valor=='double.nan' else float(valor))
    originales.append(d)
js=subprocess.run(['node','--input-type=module','-e',"import {casos} from './test/casosDePrueba.js'; console.log(JSON.stringify(casos,(k,v)=>typeof v==='number'&&Number.isNaN(v)?'NaN':v))"],cwd=web,capture_output=True,text=True,encoding='utf-8',check=True)
react=json.loads(js.stdout)
assert originales==react,(originales,react)
guardar(evidencia/'comparacion-casos.json',json.dumps({'iguales':True,'flutter':originales,'react':react},ensure_ascii=False,indent=2))

def local(d): return d.astimezone(__import__('datetime').timezone(__import__('datetime').timedelta(hours=-5))).strftime('%Y-%m-%d %H:%M:%S')
bit=f'''# Bitácora del Deber 2

Creada inicialmente en 07_Participacion/divisor_cuenta durante la rama sdd antes de la Parte 1. La entrega final se conserva en main por instrucción del usuario. Proyecto Flutter SDD copiado a ../divisor_cuenta sin sobrescribir la versión previa de main.

| Métrica | Flutter (laboratorio) | React (este deber) |
|---|---:|---:|
| Minutos hasta primera compilación | no registrado | {minbuild:.2f} |
| Minutos hasta que pasan los 6 casos | no registrado | {mincasos:.2f} |
| Iteraciones del usuario después del prompt inicial | no registrado | 0 |
| Líneas escritas a mano por estudiante | no registrado | 0 |
| Enunciados spec modificados | — | 0/{cantidad} |
| Enunciados Constitution modificados | — | {modificadas}/{consttotal} |
| Plan: enunciados modificados | — | {planmod}/{len(plan)} |
| Plan: líneas físicas del diff | — | +{anadidas} / -{eliminadas} |
| Casos de aceptación que pasan | 6/6 verificados en esta sesión | 6/6 |
| Suite completa | 18/18 en navegador en esta sesión | 36/36 |

Horarios observados, America/Guayaquil (UTC-5):
- Inicio de planificación React: {local(inicio)}.
- Primer build correcto: {local(primero)}; el cronómetro siguió.
- Seis casos verdes: {local(fin)}; cronómetro detenido.
- Los tiempos de pruebas/build individuales mostrados por los runners son duraciones de comandos; no se confunden con el cronómetro total.

La guía define el inicio por el envío del primer prompt /speckit-plan. En esta sesión el usuario autorizó toda la práctica en un solo prompt: no envió prompts por fase. Se tomó como equivalente operativo la marca UTC inmediatamente anterior a ejecutar setup-plan de la Parte 5. Es una adaptación explícita de la medición, no un tiempo histórico estimado. Incluye elaboración de plan/tareas/pruebas/código, llamadas de herramientas y comprobaciones del entorno que se intercalaron.

No hubo mensajes correctivos del usuario; los ajustes autónomos del agente no cuentan como iteraciones. Las tareas que la guía pide hacer a mano (Parte 2 y casosDePrueba.js) fueron elaboradas por el agente por petición del usuario, y deben ser revisadas personalmente; no se atribuyen al estudiante como trabajo manual.

Spec Kit 1.0.13, Codex skills: init, constitution, plan, tasks, analyze, implement y converge. No se ejecutó speckit-specify. No hooks instalados. Research delegado por requerimiento de speckit-plan; no cuenta como iteración del usuario.

Incidencias: Windows bloquea flutter_tester.exe. El runner web necesitó package:test y una copia local ignorada de CanvasKit debido a un fallo de separadores de ruta. Las 18 pruebas Flutter pasan con tool/probar_web.ps1. La validación completa Flutter se logró mientras avanzaba la preparación/implementación React; por tanto no se afirma haber cumplido estrictamente el orden «suite Flutter completa antes de cualquier implementación React». Los seis casos y LSP en Dart puro ya habían sido verificados antes de planificar. La entrega final comprueba ambas suites.

El cambio a main se hizo conservando cambios locales. La revisión automática rechazó restaurar toda la carpeta original; se evitó sobrescribirla y se creó una copia nueva desde sdd. La carpeta original del laboratorio en main conserva su código previo. La copia nueva permite repetir el experimento SDD sin esa ambigüedad.

Segunda convergencia: completada; 19 tareas satisfechas y ninguna brecha pendiente, registrada en specs/001-dividir-cuenta/convergence.md. Tiempos Flutter históricos desconocidos: no se infiere que React sea más rápido ni que SDD sea superior solo con esta sesión.
'''
guardar(web/'bitacora.md',bit); guardar(flutter/'bitacora.md',bit)
guardar(Path('C:/Programacion de apps/07_Participacion/divisor_cuenta/bitacora.md'),bit)

tablaCasos='| Caso | Monto / personas / propina / modo | Esperado Flutter | Esperado React | Cambió |\n|---|---|---|---|---|\n'
for c in react:
    valor=c.get('errorEsperado',f"{c.get('esperado',0):.2f}")
    tablaCasos+=f"| {c['nombre']} | {c['monto']} / {c['personas']} / {c['propina']} / {c['modo']} | {valor} | {valor} | No |\n"
res=f'''# Deber 2 - SDD: migración de Flutter a React

Programación Asistida de Aplicaciones - USFQ. Fecha: 6 de octubre de 2026.
Trabajo preparado para César Martínez. Agente: Codex.

## Resultado comprobado

React/Vite con JavaScript, una pantalla y useState, capas presentation → domain ← data. **6/6 casos de aceptación, LSP y tres pruebas obligatorias de pantalla**; suite ampliada **36/36**. Build correcto. Flutter SDD: **18/18**, All tests passed en Chrome, con ajuste de runner para Windows. Cronómetro React: **{minbuild:.2f} min hasta primer build; {mincasos:.2f} min hasta seis casos**. Sin tiempos históricos Flutter para comparar.

La especificación viajó intacta: **{cantidad}/{cantidad} enunciados, 100%**, bajo el método publicado en [analisis_spec.md](analisis_spec.md). La constitución original tiene {inv['counts']['idéntica']} reglas idénticas, {inv['counts']['adaptada en redacción']} adaptadas y {inv['counts']['reemplazada']} reemplazada. El plan modifica {planmod}/{len(plan)} decisiones inventariadas.

## Ubicación y alcance

- Origen inmutable: rama sdd, commit 0e14e00ef58f9146f9c0f51ff5fadd30f599412f; feature 07_Participacion/divisor_cuenta/specs/001-dividir-cuenta.
- Copia Flutter de entrega: ../divisor_cuenta, creada desde ese commit, más el ajuste de pruebas. No sobrescribe la carpeta anterior de main.
- React local: divisor_cuenta_web, repositorio propio en main. Constitución: .specify/memory/constitution.md; feature: specs/001-dividir-cuenta.
- Publicación conjunta: main del repositorio existente; la fuente React se exporta también a ../divisor_cuenta_web_entrega, conservando el proyecto local independiente. El bundle Git acompaña su historial. No hay necesidad de crear una rama feature.
- SPECIFY_FEATURE_DIRECTORY: specs/001-dividir-cuenta; se configura en ../ejecutar.ps1 y queda persistido por los scripts de Spec Kit. La spec aún dice sdd porque identifica su origen.
- No se ejecutó speckit-specify. Las skills se ejecutan por el agente, no son ejecutables de shell que generen automáticamente la app. Scripts y reportes prueban las fases.

## 1. ¿Qué porcentaje viajó intacto, adaptado o no reusable?

Intacto **100% ({cantidad}/{cantidad})**; adaptado **0%**; no reusable **0%**. Todos los enunciados inventariados describen entradas, resultados, restricciones de producto, validación o criterios ejecutables. Ninguno exige Flutter, Dart, Riverpod ni widgets. La fecha y Feature Branch=sdd son metadatos de origen, no decisiones de implementación; se excluyen del denominador y se conservan en el archivo.

El método cuenta enunciados atómicos por aparición, divide obligaciones independientes y no deduplica reglas repetidas entre FR, Edge Cases y SC. Otra deduplicación cambiaría el denominador, pero aquí seguiría siendo 100% reusable porque ninguna obligación depende de Flutter. %CÓMO = 0/{cantidad} × 100 = 0%. No supera el 30%, **umbral pedagógico del deber**, no una regla universal.

Evidencia: diff inicial y final sin salida, código 0, archivos de diff de 0 bytes; comparación adicional del objeto Git inicial 6cce762 contra sdd idéntica; SHA256 de ambas copias igual. El tiempo {mincasos:.2f} min es contexto descriptivo: no mide calidad ni demuestra que SDD sea más rápido que otro enfoque. No existe cronómetro Flutter histórico comparable.

## 2. Constitution: regla por regla

La tabla completa C01-C27 de [analisis_spec.md](analisis_spec.md) cita cada regla original y la redacción React. Resultado: **{inv['counts']['idéntica']}/{consttotal} idénticas ({inv['counts']['idéntica']/consttotal*100:.2f}%)**, **{inv['counts']['adaptada en redacción']}/{consttotal} adaptadas ({inv['counts']['adaptada en redacción']/consttotal*100:.2f}%)** y **1/{consttotal} reemplazada ({100/consttotal:.2f}%)**. Modificadas: {modificadas}/{consttotal}. Las cifras corresponden a la Constitution original 1.0.0 de sdd, preservada en evidencias/constitution-flutter-original.md, no a la aclaración posterior del runner web en la copia Flutter.

Ejemplos: «presentation depende de domain, nunca de data» y «No guardar secretos ni API keys» permanecen idénticas. «domain no importa package:flutter ni data» se adapta a «src/domain no importa react, DOM ni data; es JavaScript puro». «main.dart es el único punto...» pasa a src/main.jsx. «redondear(double importe)» pasa al contrato aplicar(valor), con una sola operación. No desaparecen SRP, OCP, LSP, ISP ni DIP.

La regla «El SDK y sus dependencias generadas son la base; no agregar paquetes externos» se reemplaza por el stack React/Vite/Vitest/Testing Library/jsdom exigido y la prohibición de librerías externas de estado. Mantener literalmente esa prohibición impediría cumplir el deber. La constitución React es 2.0.0 por esta sustitución incompatible. La copia Flutter añade una excepción de desarrollo en 1.0.1 para package:test; no cambia producto ni reglas de negocio. No se introducen principios nuevos de producto sin equivalente; el catálogo explicativo responde a la regla de la materia.

## 3. ¿Se modificó algún enunciado de la spec?

No. Se conservaron los bytes de la spec y su significado. El cálculo, los mensajes, la pantalla única y los modos de redondeo no dependen de tecnología. React implementa las decisiones en plan y código. No hay commit de adaptación de spec porque no hubo adaptación. La presencia de sdd como metadato no es contradicción con trabajar en main, y el análisis lo documenta.

Los inconvenientes encontrados pertenecen al CÓMO: runner Flutter bloqueado, assets CanvasKit y herramientas Node/npm. Se resolvieron en configuración y scripts; no se alteraron los seis escenarios para conseguir pruebas verdes. El historial conserva el commit de copia 6cce762 y el plan 8731e80. Evidencia de identidad en evidencias/spec-inicial-historial.txt y evidencias/spec-identidad.txt.

## 4. Los seis casos en Flutter y React

{tablaCasos}

No cambió entrada, valor esperado, mensaje ni escenario. double.nan de Dart se representa como NaN en JavaScript; es una traducción sintáctica, no otra regla. Una comprobación automatizada parseó casos-flutter.dart, importó casosDePrueba.js y comparó los seis objetos; evidencia comparacion-casos.json con iguales=true. Las suites verifican 27.50, 30.00, 3.33, 4.00 y los dos mensajes exactos. Las pruebas de errores comprueban también que no se invoca calcular.

La guía pide que el estudiante escriba a mano ese archivo y el análisis. En esta entrega los produjo el agente según la solicitud del usuario: **0 líneas manuales del estudiante**. Deben revisarse y explicarse personalmente; no se presenta la autoría manual como un dato observado.

## 5. ¿Qué partes del plan Flutter ya no sirven?

1. **Dart/Flutter y widgets**: .dart, MaterialApp y widgets se sustituyen por módulos .js, JSX y el DOM de React. El plan apunta al navegador, no a Android.
2. **setState y DivisorController por constructor**: useDivisor usa useState y recibe servicios ordinarios. PantallaDivisor importa el hook estáticamente; main.jsx compone estrategias y servicios. No se inyecta el hook como prop.
3. **flutter_test/test_api**: Vitest ejecuta dominio; Testing Library interactúa con controles accesibles en jsdom. Se añaden setupFiles y jest-dom, conservando los datos de los seis casos.
4. **Interfaz Dart redondear(double)**: JavaScript usa el contrato estructural aplicar(valor). La calculadora depende de esa operación y no reconoce clases concretas.
5. **lib/ y main.dart**: src/domain, src/data, src/presentation y main.jsx conservan la dirección de dependencias pero cambian rutas y composición.
6. **Herramientas y empaquetado**: Flutter produce APK; npm run build produce dist/ para web. Node ejecuta herramientas; no se añadió backend.

El inventario P01-P{len(plan)} está en [analisis_plan.md](analisis_plan.md): **{planmod}/{len(plan)} decisiones modificadas**, {len(plan)-planmod} intactas. El diff físico tiene **{anadidas} líneas añadidas y {eliminadas} eliminadas**. No se equiparan estas operaciones a decisiones atómicas: la guía usa ambos términos, por eso se informan separadamente. Sobreviven cálculo puro, almacenamiento ausente, rendimiento constante, alcance y varias comprobaciones SOLID; cambia sobre todo cómo se materializan.

## 6. Artefacto más y menos reusable

La **spec** fue el artefacto físico más reusable: copia idéntica, diff vacío y {cantidad}/{cantidad} enunciados intactos. Los **escenarios de prueba** empatan en significado: mismos seis objetos comparados y resultados verdes. El archivo runner no viaja byte por byte porque la sintaxis cambia.

El **código de implementación** fue el menos reusable físicamente: se reescribieron módulos Dart como JavaScript/JSX y controles Flutter como DOM. Se reutilizan las fórmulas y responsabilidades, pero no los archivos ejecutables. Entre los documentos de diseño, plan y tasks son los menos portables: el inventario del plan modifica {planmod}/{len(plan)} decisiones y las tareas nombran archivos/herramientas distintos. La constitución queda en medio: preserva principios pero adapta lenguaje y una restricción de dependencias.

Esta evidencia apoya la hipótesis de separación QUÉ/CÓMO **en este repositorio**, no demuestra una superioridad universal ni una diferencia temporal contra vibe coding. Haría falta otra ejecución comparable con criterios y registro iguales para esa conclusión.

## Bitácora y límites de medición

{bit.split('| Métrica',1)[1].split('Horarios observados',1)[0].join(['| Métrica',''])}

Inicio: {local(inicio)}; build: {local(primero)}; fin: {local(fin)}, UTC-5. Se tomó la ejecución inicial de planificación como equivalente al envío del prompt porque el usuario pidió todo en un solo mensaje. Los tiempos individuales de los runners no son el cronómetro. No hubo mensajes correctivos posteriores del usuario. Ver [bitacora.md](bitacora.md) para el registro íntegro.

Limitación de orden: la suite Flutter completa pudo ejecutarse tras resolver Windows y CanvasKit durante el avance React; antes de planificar sí se habían verificado seis casos y LSP en Dart puro. Se informa esa desviación del orden indicado, sin atribuir un All tests passed previo que no ocurrió. Al entregar, ambas suites están comprobadas. El bloqueo nativo de Windows sigue aplicando; se usa la alternativa web reproducible.

## Evidencias y checklist de entrega

- Spec inicial/final sin cambios; hashes e historial preservados.
- Análisis de spec y Constitution, plan nuevo y tasks trazables.
- analyze ejecutado; converge disponible y ejecutado, con limpieza de restos Vite en T019 y pasada final registrada.
- No nueva spec ni nuevas reglas de negocio; Node 24.19.0 cumple requisito. [Vite](https://vite.dev/guide/) documenta Node 20.19+/22.12+; [Node releases](https://nodejs.org/en/about/previous-releases) permite consultar soporte vigente.
- React: 36/36; build correcto; dominio sin React/DOM/data; concrete strategies solo data/main; errores impiden cálculo.
- Flutter SDD: 18/18 en Chrome; script para repetir prueba y excepción de dependencia documentados.
- Navegador real: desktop/móvil sin desbordamiento, cálculo offline y sin errores JS.
- main local y exportación para publicación GitHub. Estado real de publicación en ../publicacion.md; no se declara subida antes de verificar remoto.
- Pendiente personal: revisar el análisis y las pruebas solicitadas a mano y poder explicar las funciones.

## Salidas completas relevantes
'''
for nombre in ['spec-identidad.txt','spec-inicial-historial.txt','flutter-dominio.txt','flutter-web.txt','dominio-react.txt','tests-react.txt','solid-react.txt','navegador-react.txt','build-primero.txt','plan.diff','constitution.diff']:
    res+='\n### '+nombre+'\n\n```text\n'+leer(evidencia/nombre).rstrip()+'\n```\n'
guardar(web/'respuestas.md',res)
metricas={'inicio':inicio.isoformat(),'primer_build':primero.isoformat(),'seis_casos':fin.isoformat(),'minutos_build':minbuild,'minutos_seis':mincasos,'spec_total':cantidad,'spec_modificados':0,'constitution_total':consttotal,'constitution_modificadas':modificadas,'plan_total':len(plan),'plan_modificados':planmod,'lineas_plan_anadidas':anadidas,'lineas_plan_eliminadas':eliminadas,'react_pruebas':36,'flutter_pruebas':18}
guardar(evidencia/'metricas.json',json.dumps(metricas,ensure_ascii=False,indent=2))
print(json.dumps(metricas,ensure_ascii=False,indent=2))

from pathlib import Path
import json, shutil

base = Path(__file__).parent
web = base / 'divisor_cuenta_web'
origen = Path('C:/Programacion de apps/07_Participacion/divisor_cuenta')
def guardar(ruta, texto):
    ruta.parent.mkdir(parents=True, exist_ok=True)
    ruta.write_text(texto.rstrip()+'\n', encoding='utf-8')

# Inventario de obligaciones: metadatos y explicaciones históricas no son requisitos.
spec = [
('Input','Una pantalla sin conexión.'),
('Clarifications','Aceptar monto cero.'),('Clarifications','Aceptar propina cero.'),
('Clarifications','Rechazar valores negativos.'),('Clarifications','Permitir coma o punto decimal.'),
('US1','Ingresar monto, personas y propina, calcular y ver el pago individual.'),
('US1 Independent Test','Entradas válidas producen el resultado en la misma pantalla.'),
('AC1','100.00, 4 personas, 10%, exacto → 27.50.'),
('AC2','90.00, 3 personas, 0%, exacto → 30.00.'),
('AC5','10.00, 3 personas, 0%, exacto → 3.33.'),
('US2 Independent Test','Los errores aparecen sin resultado.'),
('AC3','50.00 y 0 personas → Debe haber al menos una persona, sin resultado.'),
('AC4','Monto abc → Monto inválido, sin resultado.'),
('US3 Independent Test','Cambiar de modo cambia el resultado del mismo reparto.'),
('AC6','10.00, 3 personas, 0%, hacia arriba → 4.00.'),
('Edge Cases','Cero monto es válido.'),('Edge Cases','Cero propina es válido.'),
('Edge Cases','Negativos son inválidos.'),('Edge Cases','Valores no finitos son inválidos.'),
('Edge Cases','Personas debe ser un entero mayor o igual a uno.'),
('Edge Cases','Campos vacíos se rechazan.'),
('Edge Cases','Desbordamiento muestra El monto calculado es demasiado grande, sin resultado.'),
('Edge Cases','Coma y punto son separadores decimales alternativos.'),
('Edge Cases','No aceptar separadores de miles.'),
('Edge Cases','Al editar datos se oculta el resultado anterior hasta calcular.'),
('Edge Cases','Al cambiar modo se oculta el resultado anterior hasta calcular.'),
('FR-001','Una sola pantalla contiene tres entradas, modo y botón Calcular.'),
('FR-002','Calcular monto × (1 + propina / 100) / personas.'),
('FR-003','Exacto redondea a centavos.'),('FR-003','Hacia arriba redondea al entero siguiente.'),
('FR-004','Mostrar siempre dos decimales.'),('FR-004','Usar punto en la salida.'),
('FR-005','Personas inválidas muestran Debe haber al menos una persona.'),
('FR-006','Monto inválido muestra Monto inválido.'),('FR-006','Propina inválida muestra Propina inválida.'),
('FR-007','Un error impide calcular.'),('FR-007','Un error elimina resultados previos.'),
('FR-008','Aceptar cero.'),('FR-008','Rechazar negativos.'),
('FR-008','Aceptar punto o coma en monto/propina.'),
('FR-009','No usar red.'),('FR-009','No usar almacenamiento.'),('FR-009','No usar login.'),
('FR-009','No usar historial.'),('FR-009','No añadir monedas.'),('FR-009','No añadir otras pantallas.'),
('Cuenta','Monto no negativo y finito.'),('Cuenta','Personas entero positivo.'),
('Cuenta','Propina no negativa y finita.'),
('Resultado','Importe individual después de la estrategia elegida.'),
('SC-001','Los seis escenarios devuelven exactamente los mensajes o importes definidos.'),
('SC-002','Ningún error conserva un resultado visible.'),
('SC-003','Ambas reglas se seleccionan.'),('SC-003','Ambas reglas funcionan sin conexión.'),
('SC-004','Cero tiene verificación ejecutable.'),('SC-004','Coma decimal tiene verificación ejecutable.'),
('SC-004','Negativos tienen verificación ejecutable.'),('SC-004','Entradas vacías tienen verificación ejecutable.'),
('Assumptions','Modo inicial exacto.'),('Assumptions','Dos personas inicialmente.'),
('Assumptions','Propina cero inicialmente.'),('Assumptions','Monto inicialmente vacío.'),
('Assumptions','Validación en orden monto, personas, propina.'),
('Assumptions','El redondeo a centavos no reparte sobrantes; 3 × 3.33 = 9.99 se acepta.')]

# Una fila por regla independiente, con cita original y redacción migrada.
reglas = [
('SRP','Cada clase tiene una razón de cambio.','Cada función o módulo tiene una razón de cambio.','adaptada en redacción','JavaScript usa funciones y módulos.'),
('SRP','CalcularDivision únicamente aplica la fórmula y delega el redondeo: no valida ni formatea.','calcularDivision únicamente aplica la fórmula y delega el redondeo: no valida ni formatea.','adaptada en redacción','Cambia el identificador; se conserva la responsabilidad.'),
('SRP','ValidarEntrada valida y FormateadorMoneda formatea.','validarEntrada valida y formateadorMoneda formatea.','adaptada en redacción','Identificadores JavaScript.'),
('OCP','Una nueva regla de redondeo se agrega implementando EstrategiaRedondeo en un archivo nuevo.','Una nueva regla de redondeo se agrega implementando el contrato estrategiaRedondeo en un archivo nuevo.','adaptada en redacción','Contrato estructural en vez de interfaz Dart.'),
('OCP','No se modifican CalcularDivision ni las estrategias existentes.','No se modifican calcularDivision ni las estrategias existentes.','adaptada en redacción','Misma extensión sin modificar consumidores.'),
('LSP','Todas las estrategias reciben un importe finito no negativo y devuelven un importe finito no negativo.','Todas las estrategias reciben un importe finito no negativo y devuelven un importe finito no negativo.','idéntica','Precondición independiente de tecnología.'),
('LSP','El consumidor usa la interfaz sin if de tipo ni casts concretos.','El consumidor usa la interfaz sin if de tipo ni casts concretos.','idéntica','Regla de sustitución.'),
('LSP','Una prueba debe intercambiar exacto y hacia arriba en el mismo caso de uso.','Una prueba debe intercambiar exacto y hacia arriba en el mismo caso de uso.','idéntica','Caso de prueba reusable.'),
('ISP','EstrategiaRedondeo declara únicamente redondear(double importe).','estrategiaRedondeo declara únicamente aplicar(valor).','adaptada en redacción','Se adapta firma Dart al contrato requerido por la guía React.'),
('ISP','No incluye validación, formateo, persistencia ni métodos ajenos al redondeo.','No incluye validación, formateo, persistencia ni métodos ajenos al redondeo.','idéntica','Interfaz pequeña.'),
('DIP','presentation depende de domain, nunca de data.','presentation depende de domain, nunca de data.','idéntica','Dirección de dependencia.'),
('DIP','domain no importa package:flutter ni data.','src/domain no importa react, DOM ni data; es JavaScript puro.','adaptada en redacción','Conserva aislamiento del dominio.'),
('DIP','main.dart es el único punto que instancia implementaciones concretas y conecta dependencias.','src/main.jsx es el único punto que instancia implementaciones concretas y conecta dependencias.','adaptada en redacción','Cambia punto de composición.'),
('DIP','Se permite instanciar objetos de valor Cuenta y Resultado donde corresponde y widgets en la presentación; la regla de composición se aplica a servicios y estrategias inyectables.','Se permite crear objetos de valor cuenta y resultado donde corresponde y elementos JSX en presentación; la regla de composición se aplica a servicios y estrategias inyectables.','adaptada en redacción','JSX sustituye widgets; no se inyectan objetos de valor.'),
('Arquitectura','Capas obligatorias: presentation -> domain <- data.','Capas obligatorias: src/presentation -> src/domain <- src/data.','adaptada en redacción','Rutas src en lugar de lib.'),
('Arquitectura','Dominio Dart puro.','Dominio JavaScript puro.','adaptada en redacción','Lenguaje reemplazado; aislamiento conservado.'),
('Seguridad','No guardar secretos ni API keys.','No guardar secretos ni API keys.','idéntica','Regla independiente del framework.'),
('Arquitectura','Una pantalla sin red ni base de datos.','Una pantalla sin red ni base de datos.','idéntica','Mismo alcance.'),
('Dependencias','El SDK y sus dependencias generadas son la base; no agregar paquetes externos.','Usar React con Vite, Vitest, Testing Library y jsdom; sin librerías de estado externas.','reemplazada','La prohibición de paquetes Flutter impediría usar las herramientas React exigidas. Se limita explícitamente al stack autorizado.'),
('Pruebas','Los seis criterios de aceptación se traducen a pruebas ejecutables y separadas de sus datos.','Los seis criterios de aceptación se traducen a pruebas ejecutables y separadas de sus datos.','idéntica','Datos separados del runner.'),
('Pruebas','Incluir la prueba LSP y las tres pruebas de widget solicitadas.','Incluir la prueba LSP y las tres pruebas de pantalla solicitadas con Testing Library.','adaptada en redacción','Widgets Flutter se sustituyen por DOM.'),
('Materia','Toda función generada debe ser explicable: propósito, entrada, salida y errores.','Toda función generada debe ser explicable: propósito, entrada, salida y errores.','idéntica','Se incluye catálogo explicativo.'),
('Calidad','Los errores de validación deben impedir el cálculo y ocultar cualquier resultado anterior.','Los errores de validación deben impedir el cálculo y ocultar cualquier resultado anterior.','idéntica','Comportamiento verificable.'),
('Governance','La constitución rige spec, plan, tareas y código.','La constitución rige spec, plan, tareas y código.','idéntica','Mismo gobierno.'),
('Governance','Ante un incumplimiento se corrige primero el artefacto que define la regla.','Ante un incumplimiento se corrige primero el artefacto que define la regla.','idéntica','Mismo proceso.'),
('Governance','Revisar el cumplimiento antes y después de implementar.','Revisar el cumplimiento antes y después de implementar.','idéntica','Analyze y converge.'),
('Governance','Cambios de principios incompatibles aumentan MAJOR; ampliaciones MINOR; aclaraciones PATCH.','Cambios de principios incompatibles aumentan MAJOR; ampliaciones MINOR; aclaraciones PATCH.','idéntica','Mismo versionado.')]

txt = '# Análisis de la especificación y de la Constitution\n\n'
txt += 'Origen: rama `sdd`, commit `0e14e00ef58f9146f9c0f51ff5fadd30f599412f`, feature `07_Participacion/divisor_cuenta/specs/001-dividir-cuenta`.\n\n'
txt += 'Este análisis lo elaboró el agente a solicitud del estudiante. La guía pide hacerlo a mano: debe revisarse y defenderse personalmente; no se presenta como trabajo manual del estudiante.\n\n'
txt += '## Método de conteo\n\nSe cuentan obligaciones, reglas y criterios atómicos por aparición en el documento. Una obligación repetida en FR y Edge Cases se conserva en ambas posiciones: el denominador mide enunciados del documento, no requisitos únicos. Se separan ideas independientes dentro de una viñeta y se conserva cada escenario de entrada/salida como unidad verificable. Se excluyen título, fecha, rama histórica, estado, prioridades, razones de prioridad y notas sobre quién decidió: son metadatos o explicación, no comportamiento ni implementación. La rama `sdd` en la spec identifica su origen y no obliga a usar esa rama en React. La ausencia de red describe funcionamiento offline; npm solo usa red al instalar herramientas.\n\n'
txt += '## Spec\n\n| Enunciado de la spec | Tipo (QUÉ/CÓMO/MIXTO) | ¿Viaja a React? | Justificación |\n|---|---|---|---|\n'
for i,(ref,enun) in enumerate(spec,1):
    txt += f'| S{i:03d} · {ref}: {enun} | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |\n'
txt += f'\nTotal: **{len(spec)}**; QUÉ: **{len(spec)} (100%)**; CÓMO: **0 (0%)**; MIXTO: **0 (0%)**. Viaja intacto: **100%**; adaptado: **0%**; no reusable: **0%**.\n\n'
txt += 'Fórmula CÓMO = 0 / '+str(len(spec))+' × 100 = 0%. No supera el 30%, umbral pedagógico de este deber, no una regla universal. Enunciados a modificar: ninguno. El diff inicial y final se conserva vacío; los hashes verifican también identidad byte por byte.\n\n'
txt += '## Constitution, evaluada por separado\n\nLas citas originales corresponden a `.specify/memory/constitution.md` de Flutter antes de añadir el runner web. La redacción React corresponde a `.specify/memory/constitution.md` de este proyecto. No se cuentan metadatos de versión ni la nota histórica «Esta versión inicial concreta únicamente las reglas del enunciado».\n\n| Enunciado original | Regla React | Clasificación | Justificación |\n|---|---|---|---|\n'
for i,(ref,a,b,t,j) in enumerate(reglas,1):
    txt += f'| C{i:02d} · {ref}: {a} | {b} | {t} | {j} |\n'
counts={t:sum(r[3]==t for r in reglas) for t in ['idéntica','adaptada en redacción','reemplazada']}
txt += '\n'+ '; '.join(f'{k}: **{v}/{len(reglas)} ({v/len(reglas)*100:.2f}%)**' for k,v in counts.items())+'.\n\n'
txt += 'Reglas modificadas: adaptadas + reemplazadas. No se introduce otro principio de producto. La cobertura crítica se concreta con las pruebas de los seis casos, LSP, pantalla y las aclaraciones SC-004. La prohibición de paquetes de la constitución original ya necesitó una excepción documentada para ejecutar Flutter web; React exige reemplazarla, no ocultarla.\n'
guardar(web/'analisis_spec.md',txt)
guardar(web/'evidencias/inventario.json',json.dumps({'spec':spec,'constitution':reglas,'counts':counts},ensure_ascii=False,indent=2))
shutil.copyfile(origen/'.specify/memory/constitution.md',web/'evidencias/constitution-flutter-original.md')
shutil.copyfile(origen/'specs/001-dividir-cuenta/plan.md',web/'evidencias/plan-flutter.md')
shutil.copyfile(origen/'test/casos_de_prueba.dart',web/'evidencias/casos-flutter.dart')

secciones=[('I. SRP — responsabilidad única','SRP'),('II. OCP — abierto a extensión','OCP'),('III. LSP — sustitución','LSP'),('IV. ISP — interfaz pequeña','ISP'),('V. DIP — inversión de dependencias','DIP')]
constit='# Divisor de cuenta web Constitution\n\n## Core Principles\n\n'
for titulo,categoria in secciones:
    constit+='### '+titulo+'\n'+'\n'.join(b for ref,a,b,t,j in reglas if ref==categoria)+'\n\n'
constit+='## Arquitectura y seguridad\n'+'\n'.join(b for ref,a,b,t,j in reglas if ref in ['Arquitectura','Seguridad','Dependencias'])+'\n\n'
constit+='## Calidad, pruebas y regla de la materia\n'+'\n'.join(b for ref,a,b,t,j in reglas if ref in ['Pruebas','Materia','Calidad'])+'\n\n'
constit+='## Governance\n'+'\n'.join(b for ref,a,b,t,j in reglas if ref=='Governance')+'\n\n'
constit+='**Version**: 2.0.0 | **Ratified**: 2026-10-01 | **Last Amended**: 2026-10-06\n\nVersión MAJOR por reemplazar la restricción de dependencias del SDK Flutter por el stack React autorizado. Principios SOLID y comportamiento conservados.\n'
guardar(web/'.specify/memory/constitution.md',constit)
guardar(base/'.gitignore','herramientas/\ndivisor_cuenta_web/\n')

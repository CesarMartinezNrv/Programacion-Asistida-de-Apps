# Explicación paso a paso de la práctica

## 1. Qué se está demostrando

El cliente cambia de Flutter a React, pero no cambia la necesidad: dividir una cuenta con propina. SDD deja el QUÉ en spec.md y el CÓMO en plan.md, tasks.md y código. La práctica prueba esa separación con archivos idénticos, inventarios y pruebas; no la supone.

## 2. Cómo se tomó el laboratorio anterior

Se leyó el feature real `07_Participacion/divisor_cuenta/specs/001-dividir-cuenta` de la rama sdd. Se comprobaron primero seis escenarios y LSP en Dart puro. Para completar las pruebas de pantalla se añadió el runner de desarrollo test y un script que sirve CanvasKit localmente: Windows bloquea el motor nativo y Flutter 3.47.1 tiene un fallo de rutas en el runner web. Finalmente las 18 pruebas pasaron en Chrome. La validación completa se terminó mientras avanzaba React, desviación de orden documentada en bitacora.md.

Para conservar la carpeta previa de main, la versión SDD de entrega se copió a `Deberes/Deber 2/divisor_cuenta` desde el commit original. La constitución original y los casos se preservan en las evidencias React.

## 3. Cómo se separó QUÉ de CÓMO

Se recorrieron 64 obligaciones de la spec por aparición. Se separaron ideas independientes y se excluyeron fechas, rama y explicación histórica. Cada fila de analisis_spec.md responde si sigue siendo válida en React. Todas siguen vigentes: 100% intacto. La fórmula, errores y criterios no mencionan Flutter. La constitución se analizó aparte: 14 reglas idénticas, 12 adaptadas y una reemplazada.

Esta parte y el archivo de casos fueron elaborados por el agente según tu petición; la guía pide revisarlos personalmente y escribirlos a mano. No debes declarar que escribiste manualmente el código generado. Lee las tablas y comprueba que puedes justificar sus decisiones.

## 4. Cómo se creó React

Se usó la plantilla React JavaScript de Vite y Node 24.19.0, con repositorio local propio en main. Se inicializó Spec Kit 1.0.13 con la integración Codex, como en Flutter. Se copió solo la spec del feature activo; no se ejecutó speckit-specify. El diff inicial y final está vacío, y los SHA256 coinciden.

Node ejecuta Vite y Vitest; npm instala librerías y ejecuta scripts. No hay backend ni base de datos. La app puede calcular sin red después de cargarse; no se promete abrirla por primera vez sin servir o tener sus archivos locales.

## 5. Cómo se preparó el CÓMO nuevo

La constitución conserva SOLID y cambia rutas, lenguaje y herramientas de pruebas. `redondear(double)` pasa a `aplicar(valor)`. La prohibición de paquetes Flutter se reemplaza por el stack requerido; no se añaden librerías externas de estado.

speckit-plan generó plan, investigación, modelo de datos, contrato de pantalla y guía rápida. speckit-tasks creó 18 tareas por historias. speckit-analyze verificó la cobertura de los 9 FR y 4 SC; no encontró contradicciones funcionales. speckit-implement siguió las tareas. Las pruebas se escribieron antes del código y fallaron por imports ausentes, evidencia conservada. speckit-converge detectó restos de la plantilla Vite y añadió T019; se retiraron y se verificó otra vez.

## 6. Cómo funciona un cálculo

1. `PantallaDivisor` muestra los campos y envía eventos al hook; no hace cuentas.
2. `useDivisor` guarda textos con useState. Mantener texto permite escribir coma decimal o abc sin que el navegador lo cambie automáticamente.
3. `numero` convierte el texto completo: 100,00 → 100; abc o vacío → NaN. Personas exige texto entero.
4. `validarEntrada` comprueba monto, personas y propina en ese orden. Devuelve null o el mensaje exacto; un error detiene el flujo antes del cálculo.
5. El hook comprueba desbordamiento numérico para cumplir la precondición de la estrategia.
6. `calcularDivision` hace monto × (1 + propina / 100) / personas y llama `estrategia.aplicar`.
7. `redondeoExacto` aproxima al centavo; `redondeoHaciaArriba` usa el entero siguiente.
8. `resultado` envuelve el importe. `formateadorMoneda` produce dos decimales con punto y sin símbolos.
9. React vuelve a dibujar la pantalla. Al editar o cambiar de modo, el resultado anterior desaparece.

Ejemplo: 100 × (1 + 10/100) / 4 = 110/4 = 27.50. Para 10/3, exacto da 3.33 y hacia arriba 4.00. Exacto no redistribuye el centavo sobrante: 3 × 3.33 = 9.99, tal como autoriza la spec.

## 7. Dónde se ve SOLID

| Principio | Evidencia |
|---|---|
| SRP | cálculo, validación, formato y vista viven en módulos distintos |
| OCP | una estrategia nueva puede cumplir aplicar(valor) sin modificar calcularDivision |
| LSP | la misma función de cálculo recibe ambas estrategias; prueba aparte |
| ISP | el contrato tiene una sola operación aplicar |
| DIP | presentación recibe servicios; no importa data; domain no importa React ni DOM |

main.jsx es el punto de composición. Crear objetos de valor cuenta/resultado en sus consumidores no infringe la regla: la inyección se exige a servicios y estrategias. El hook se importa estáticamente; se inyectan servicios ordinarios, no hooks.

## 8. Qué comprueban las pruebas

`casosDePrueba.js` contiene los seis objetos; `division.test.js` los recorre y registra un it por caso. Si hay error, comprueba mensaje exacto y que la calculadora no se invoca; si es válido, compara importe con toBeCloseTo. La prueba LSP sustituye ambas estrategias sin if de tipo.

`pantalla.test.jsx` verifica los tres casos obligatorios en controles accesibles y añade transiciones, coma decimal, cero, negativos, vacíos y desbordamiento. `entrada.test.js` comprueba límites y formato grande. La suite tiene 36 pruebas; las obligatorias son 10 (6 + 1 LSP + 3 pantalla). Chrome real verifica escritorio/móvil, cálculo con red desactivada y ausencia de errores JavaScript.

## 9. Cómo ejecutar y repetir

Desde PowerShell en `C:\Programacion de apps\Deberes\Deber 2`:

```powershell
.\ejecutar.ps1 dev
# Abre http://localhost:5173
# En otra terminal:
.\ejecutar.ps1 test
.\ejecutar.ps1 build
.\ejecutar.ps1 check:architecture
```

El script usa npm normal o el npm local preparado. En otra máquina instala Node >= 22.12 con npm; entra a divisor_cuenta_web y ejecuta npm ci, npm test y npm run dev. En el exportado de entrega los comandos normales npm funcionan igual.

Para Flutter SDD:

```powershell
cd .\divisor_cuenta
.\tool\probar_web.ps1
# Debe terminar All tests passed!
```

En una máquina cuyo motor nativo no esté bloqueado puedes usar flutter test. El script web detecta el SDK, prepara CanvasKit desde sus recursos originales y ejecuta las pruebas en Chrome. No cambia las pruebas ni las reglas de negocio.

## 10. Cómo explicar el cronómetro

Comenzó al iniciar la planificación de la Parte 5 (10:26:00 UTC-5). Primera compilación: 10:35:50, 9.83 min; siguió corriendo. Seis casos verdes: 10:36:09, 10.15 min; allí terminó. Son marcas de reloj observadas. El cronómetro incluye trabajo y herramientas intercaladas. No son los 2.34 segundos del comando build ni los 3.21 segundos del runner de dominio.

Iteraciones del usuario posteriores al prompt inicial: cero. Correcciones autónomas del agente no cuentan. Líneas manuales del estudiante: cero. Tiempo Flutter del laboratorio: no registrado; las pruebas de hoy no permiten reconstruir cuánto tardó el laboratorio.

## 11. Catálogo de funciones para defender la práctica

| Función | Qué hace y por qué | Recibe | Devuelve y errores |
|---|---|---|---|
| cuenta | Agrupa datos inmutables, sin otra responsabilidad | monto/personas/propina numéricos | objeto congelado; no valida |
| resultado | Representa la salida del negocio | importe | objeto congelado; no formatea |
| validarEntrada | Comprueba reglas y prioridad de errores | objeto cuenta | null o string exacto; no lanza excepciones |
| calcularDivision | Aplica fórmula y delega redondeo | cuenta válida y estrategia | objeto resultado; datos válidos y contrato son precondiciones |
| estrategia.aplicar | Contrato pequeño para sustitución | importe finito no negativo | número finito no negativo; exige precondición numérica |
| redondeoExacto | Crea implementación del contrato | nada | objeto con aplicar; Math.round(valor*100)/100 |
| redondeoHaciaArriba | Crea otra implementación | nada | objeto con aplicar; Math.ceil(valor) |
| formateadorMoneda | Presenta dos decimales, punto y sin miles | importe finito | string; no calcula la división |
| numero | Convierte texto decimal completo | string | número o NaN si texto inválido/vacío |
| useDivisor | Mantiene estado y coordina servicios inyectados | validar/calcular/estrategias/formatear | campos, acciones, error y resultado; sin efectos de red |
| cambiar | Actualiza campo y elimina salida antigua | nombre de campo y texto | void; programa nuevo estado React |
| ejecutar | Convierte, valida y calcula si procede | nada; usa campos actuales | void; publica error o resultado; incluye desbordamiento/modo inválido |
| PantallaDivisor | Describe controles y salida accesible | dependencias | árbol JSX; no calcula negocio |
| onSubmit | Evita recarga del formulario y pide cálculo | evento del formulario | void |
| onChange | Transfiere texto o modo al hook | evento del control | void; resultado anterior se limpia |
| main.jsx | Compone servicios y monta React | elemento root del HTML | render; requiere root existente |
| archivos (verificador) | Recorre src y lista archivos | directorio | arreglo de rutas; errores FS si faltan rutas |
| verificarArquitectura (script) | Comprueba imports, composición y SRP/OCP | fuente src | PASS o AssertionError con incumplimiento |
| abrir (pruebas UI) | Compone dobles/servicios para una prueba | nada | spy de cálculo, pantalla montada |
| ingresar (pruebas UI) | Simula entrada y clic | tres textos | void; permite verificar la salida observable |
| callbacks de it/it.each | Ejecutan expectativas por escenario | caso o parámetros | PASS o fallo del runner; no alteran esperado |
| probar_web.ps1 | Prepara recursos locales y corre Flutter web | ruta Chrome opcional | código de salida de pruebas; falla si SDK/navegador ausentes |
| ejecutar.ps1 | Resuelve npm y ejecuta la acción elegida | dev/test/build/etc. | código de salida del comando; error si falta npm |

No se añadieron lógica de login, historial, monedas, persistencia ni otras pantallas. Cambiar visualmente la tecnología no justificó cambiar el QUÉ.

# Análisis de la especificación y de la Constitution

Origen: rama `sdd`, commit `0e14e00ef58f9146f9c0f51ff5fadd30f599412f`, feature `07_Participacion/divisor_cuenta/specs/001-dividir-cuenta`.

Este análisis se preparó con ayuda de Codex. Como la guía pide hacerlo a mano, debo revisarlo y poder explicar la clasificación antes de entregar.

## Método de conteo

Para contar, separé las reglas que tienen ideas distintas. Si una regla aparece en dos partes del documento, se cuenta en ambas. Por eso, el total corresponde a los enunciados que aparecen, no solamente a las reglas diferentes.

No conté títulos, fechas, el nombre de la rama ni las notas explicativas. El nombre `sdd` indica de dónde salió la spec. La aplicación funciona sin conexión durante su uso; instalar las herramientas sí puede requerir internet.

## Spec

| Enunciado de la spec | Tipo (QUÉ/CÓMO/MIXTO) | ¿Viaja a React? | Justificación |
|---|---|---|---|
| S001 · Input: Una pantalla sin conexión. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S002 · Clarifications: Aceptar monto cero. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S003 · Clarifications: Aceptar propina cero. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S004 · Clarifications: Rechazar valores negativos. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S005 · Clarifications: Permitir coma o punto decimal. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S006 · US1: Ingresar monto, personas y propina, calcular y ver el pago individual. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S007 · US1 Independent Test: Entradas válidas producen el resultado en la misma pantalla. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S008 · AC1: 100.00, 4 personas, 10%, exacto → 27.50. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S009 · AC2: 90.00, 3 personas, 0%, exacto → 30.00. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S010 · AC5: 10.00, 3 personas, 0%, exacto → 3.33. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S011 · US2 Independent Test: Los errores aparecen sin resultado. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S012 · AC3: 50.00 y 0 personas → Debe haber al menos una persona, sin resultado. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S013 · AC4: Monto abc → Monto inválido, sin resultado. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S014 · US3 Independent Test: Cambiar de modo cambia el resultado del mismo reparto. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S015 · AC6: 10.00, 3 personas, 0%, hacia arriba → 4.00. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S016 · Edge Cases: Cero monto es válido. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S017 · Edge Cases: Cero propina es válido. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S018 · Edge Cases: Negativos son inválidos. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S019 · Edge Cases: Valores no finitos son inválidos. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S020 · Edge Cases: Personas debe ser un entero mayor o igual a uno. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S021 · Edge Cases: Campos vacíos se rechazan. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S022 · Edge Cases: Desbordamiento muestra El monto calculado es demasiado grande, sin resultado. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S023 · Edge Cases: Coma y punto son separadores decimales alternativos. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S024 · Edge Cases: No aceptar separadores de miles. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S025 · Edge Cases: Al editar datos se oculta el resultado anterior hasta calcular. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S026 · Edge Cases: Al cambiar modo se oculta el resultado anterior hasta calcular. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S027 · FR-001: Una sola pantalla contiene tres entradas, modo y botón Calcular. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S028 · FR-002: Calcular monto × (1 + propina / 100) / personas. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S029 · FR-003: Exacto redondea a centavos. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S030 · FR-003: Hacia arriba redondea al entero siguiente. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S031 · FR-004: Mostrar siempre dos decimales. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S032 · FR-004: Usar punto en la salida. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S033 · FR-005: Personas inválidas muestran Debe haber al menos una persona. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S034 · FR-006: Monto inválido muestra Monto inválido. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S035 · FR-006: Propina inválida muestra Propina inválida. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S036 · FR-007: Un error impide calcular. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S037 · FR-007: Un error elimina resultados previos. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S038 · FR-008: Aceptar cero. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S039 · FR-008: Rechazar negativos. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S040 · FR-008: Aceptar punto o coma en monto/propina. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S041 · FR-009: No usar red. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S042 · FR-009: No usar almacenamiento. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S043 · FR-009: No usar login. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S044 · FR-009: No usar historial. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S045 · FR-009: No añadir monedas. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S046 · FR-009: No añadir otras pantallas. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S047 · Cuenta: Monto no negativo y finito. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S048 · Cuenta: Personas entero positivo. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S049 · Cuenta: Propina no negativa y finita. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S050 · Resultado: Importe individual después de la estrategia elegida. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S051 · SC-001: Los seis escenarios devuelven exactamente los mensajes o importes definidos. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S052 · SC-002: Ningún error conserva un resultado visible. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S053 · SC-003: Ambas reglas se seleccionan. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S054 · SC-003: Ambas reglas funcionan sin conexión. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S055 · SC-004: Cero tiene verificación ejecutable. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S056 · SC-004: Coma decimal tiene verificación ejecutable. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S057 · SC-004: Negativos tienen verificación ejecutable. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S058 · SC-004: Entradas vacías tienen verificación ejecutable. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S059 · Assumptions: Modo inicial exacto. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S060 · Assumptions: Dos personas inicialmente. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S061 · Assumptions: Propina cero inicialmente. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S062 · Assumptions: Monto inicialmente vacío. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S063 · Assumptions: Validación en orden monto, personas, propina. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |
| S064 · Assumptions: El redondeo a centavos no reparte sobrantes; 3 × 3.33 = 9.99 se acepta. | QUÉ | Intacto | Describe lo que debe hacer la aplicación y sirve también en React. |

Total: **64**; QUÉ: **64 (100%)**; CÓMO: **0 (0%)**; MIXTO: **0 (0%)**. Viaja intacto: **100%**; adaptado: **0%**; no reusable: **0%**.

El porcentaje de CÓMO es 0 / 64 × 100 = 0%. No supera el 30% que usa el deber como referencia. Ese límite no es una regla general. No hubo que modificar ningún enunciado. Las comparaciones inicial y final no muestran cambios, y las huellas de los archivos también coinciden.

## Constitution, evaluada por separado

Comparé las reglas originales de Flutter, anteriores al ajuste para las pruebas web, con las reglas de React. No conté el número de versión ni la nota de la versión inicial. En las dos primeras columnas mantuve el texto de las reglas para mostrar qué cambió.

| Enunciado original | Regla React | Clasificación | Justificación |
|---|---|---|---|
| C01 · SRP: Cada clase tiene una razón de cambio. | Cada función o módulo tiene una razón de cambio. | adaptada en redacción | JavaScript usa funciones y módulos. |
| C02 · SRP: CalcularDivision únicamente aplica la fórmula y delega el redondeo: no valida ni formatea. | calcularDivision únicamente aplica la fórmula y delega el redondeo: no valida ni formatea. | adaptada en redacción | Cambia el nombre, pero sigue haciendo lo mismo. |
| C03 · SRP: ValidarEntrada valida y FormateadorMoneda formatea. | validarEntrada valida y formateadorMoneda formatea. | adaptada en redacción | Los nombres se adaptan a JavaScript. |
| C04 · OCP: Una nueva regla de redondeo se agrega implementando EstrategiaRedondeo en un archivo nuevo. | Una nueva regla de redondeo se agrega implementando el contrato estrategiaRedondeo en un archivo nuevo. | adaptada en redacción | Se cambia la forma de definir la estrategia para usarla en JavaScript. |
| C05 · OCP: No se modifican CalcularDivision ni las estrategias existentes. | No se modifican calcularDivision ni las estrategias existentes. | adaptada en redacción | Se puede agregar un redondeo sin cambiar el cálculo. |
| C06 · LSP: Todas las estrategias reciben un importe finito no negativo y devuelven un importe finito no negativo. | Todas las estrategias reciben un importe finito no negativo y devuelven un importe finito no negativo. | idéntica | La regla sobre los valores sirve en los dos lenguajes. |
| C07 · LSP: El consumidor usa la interfaz sin if de tipo ni casts concretos. | El consumidor usa la interfaz sin if de tipo ni casts concretos. | idéntica | Se puede cambiar la estrategia sin cambiar el cálculo. |
| C08 · LSP: Una prueba debe intercambiar exacto y hacia arriba en el mismo caso de uso. | Una prueba debe intercambiar exacto y hacia arriba en el mismo caso de uso. | idéntica | La misma prueba sirve para comprobar los dos modos. |
| C09 · ISP: EstrategiaRedondeo declara únicamente redondear(double importe). | estrategiaRedondeo declara únicamente aplicar(valor). | adaptada en redacción | Se cambia el nombre y la forma de recibir el valor, como pide la guía. |
| C10 · ISP: No incluye validación, formateo, persistencia ni métodos ajenos al redondeo. | No incluye validación, formateo, persistencia ni métodos ajenos al redondeo. | idéntica | Solo incluye lo necesario para redondear. |
| C11 · DIP: presentation depende de domain, nunca de data. | presentation depende de domain, nunca de data. | idéntica | La pantalla usa los cálculos, sin conocer cómo se implementa el redondeo. |
| C12 · DIP: domain no importa package:flutter ni data. | src/domain no importa react, DOM ni data; es JavaScript puro. | adaptada en redacción | Los cálculos siguen separados de la pantalla. |
| C13 · DIP: main.dart es el único punto que instancia implementaciones concretas y conecta dependencias. | src/main.jsx es el único punto que instancia implementaciones concretas y conecta dependencias. | adaptada en redacción | Cambia el archivo donde se conectan las partes. |
| C14 · DIP: Se permite instanciar objetos de valor Cuenta y Resultado donde corresponde y widgets en la presentación; la regla de composición se aplica a servicios y estrategias inyectables. | Se permite crear objetos de valor cuenta y resultado donde corresponde y elementos JSX en presentación; la regla de composición se aplica a servicios y estrategias inyectables. | adaptada en redacción | React usa JSX en lugar de widgets; se mantiene la regla para conectar los servicios. |
| C15 · Arquitectura: Capas obligatorias: presentation -> domain <- data. | Capas obligatorias: src/presentation -> src/domain <- src/data. | adaptada en redacción | Rutas src en lugar de lib. |
| C16 · Arquitectura: Dominio Dart puro. | Dominio JavaScript puro. | adaptada en redacción | Cambia el lenguaje, pero los cálculos siguen separados. |
| C17 · Seguridad: No guardar secretos ni API keys. | No guardar secretos ni API keys. | idéntica | Sirve sin importar la tecnología. |
| C18 · Arquitectura: Una pantalla sin red ni base de datos. | Una pantalla sin red ni base de datos. | idéntica | Mismo alcance. |
| C19 · Dependencias: El SDK y sus dependencias generadas son la base; no agregar paquetes externos. | Usar React con Vite, Vitest, Testing Library y jsdom; sin librerías de estado externas. | reemplazada | La regla anterior no permitiría instalar las herramientas de React que pide el deber. |
| C20 · Pruebas: Los seis criterios de aceptación se traducen a pruebas ejecutables y separadas de sus datos. | Los seis criterios de aceptación se traducen a pruebas ejecutables y separadas de sus datos. | idéntica | Los datos de los casos siguen separados del código que ejecuta las pruebas. |
| C21 · Pruebas: Incluir la prueba LSP y las tres pruebas de widget solicitadas. | Incluir la prueba LSP y las tres pruebas de pantalla solicitadas con Testing Library. | adaptada en redacción | Se comprueba la pantalla de React en lugar de los widgets de Flutter. |
| C22 · Materia: Toda función generada debe ser explicable: propósito, entrada, salida y errores. | Toda función generada debe ser explicable: propósito, entrada, salida y errores. | idéntica | Se debe poder explicar cada función. |
| C23 · Calidad: Los errores de validación deben impedir el cálculo y ocultar cualquier resultado anterior. | Los errores de validación deben impedir el cálculo y ocultar cualquier resultado anterior. | idéntica | La misma regla se puede comprobar en ambas aplicaciones. |
| C24 · Governance: La constitución rige spec, plan, tareas y código. | La constitución rige spec, plan, tareas y código. | idéntica | Se mantienen las reglas del proyecto. |
| C25 · Governance: Ante un incumplimiento se corrige primero el artefacto que define la regla. | Ante un incumplimiento se corrige primero el artefacto que define la regla. | idéntica | Se mantiene la forma de corregir los problemas. |
| C26 · Governance: Revisar el cumplimiento antes y después de implementar. | Revisar el cumplimiento antes y después de implementar. | idéntica | Se revisa antes y después de programar. |
| C27 · Governance: Cambios de principios incompatibles aumentan MAJOR; ampliaciones MINOR; aclaraciones PATCH. | Cambios de principios incompatibles aumentan MAJOR; ampliaciones MINOR; aclaraciones PATCH. | idéntica | Se mantiene la forma de numerar las versiones. |

idéntica: **14/27 (51.85%)**; adaptada en redacción: **12/27 (44.44%)**; reemplazada: **1/27 (3.70%)**.

En total cambiaron 13 reglas: 12 adaptadas y 1 reemplazada. Se mantienen los mismos requisitos de la aplicación. Las pruebas comprueban los seis casos, el intercambio de los modos de redondeo y la pantalla. En Flutter se permitió una herramienta adicional para hacer las pruebas web; en React se reemplazó la prohibición de paquetes porque el deber necesita esas herramientas.

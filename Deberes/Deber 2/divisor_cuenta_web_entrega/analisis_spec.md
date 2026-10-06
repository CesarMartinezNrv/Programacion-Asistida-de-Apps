# Análisis de la especificación y de la Constitution

Origen: rama `sdd`, commit `0e14e00ef58f9146f9c0f51ff5fadd30f599412f`, feature `07_Participacion/divisor_cuenta/specs/001-dividir-cuenta`.

Este análisis lo elaboró el agente a solicitud del estudiante. La guía pide hacerlo a mano: debe revisarse y defenderse personalmente; no se presenta como trabajo manual del estudiante.

## Método de conteo

Se cuentan obligaciones, reglas y criterios atómicos por aparición en el documento. Una obligación repetida en FR y Edge Cases se conserva en ambas posiciones: el denominador mide enunciados del documento, no requisitos únicos. Se separan ideas independientes dentro de una viñeta y se conserva cada escenario de entrada/salida como unidad verificable. Se excluyen título, fecha, rama histórica, estado, prioridades, razones de prioridad y notas sobre quién decidió: son metadatos o explicación, no comportamiento ni implementación. La rama `sdd` en la spec identifica su origen y no obliga a usar esa rama en React. La ausencia de red describe funcionamiento offline; npm solo usa red al instalar herramientas.

## Spec

| Enunciado de la spec | Tipo (QUÉ/CÓMO/MIXTO) | ¿Viaja a React? | Justificación |
|---|---|---|---|
| S001 · Input: Una pantalla sin conexión. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S002 · Clarifications: Aceptar monto cero. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S003 · Clarifications: Aceptar propina cero. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S004 · Clarifications: Rechazar valores negativos. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S005 · Clarifications: Permitir coma o punto decimal. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S006 · US1: Ingresar monto, personas y propina, calcular y ver el pago individual. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S007 · US1 Independent Test: Entradas válidas producen el resultado en la misma pantalla. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S008 · AC1: 100.00, 4 personas, 10%, exacto → 27.50. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S009 · AC2: 90.00, 3 personas, 0%, exacto → 30.00. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S010 · AC5: 10.00, 3 personas, 0%, exacto → 3.33. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S011 · US2 Independent Test: Los errores aparecen sin resultado. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S012 · AC3: 50.00 y 0 personas → Debe haber al menos una persona, sin resultado. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S013 · AC4: Monto abc → Monto inválido, sin resultado. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S014 · US3 Independent Test: Cambiar de modo cambia el resultado del mismo reparto. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S015 · AC6: 10.00, 3 personas, 0%, hacia arriba → 4.00. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S016 · Edge Cases: Cero monto es válido. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S017 · Edge Cases: Cero propina es válido. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S018 · Edge Cases: Negativos son inválidos. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S019 · Edge Cases: Valores no finitos son inválidos. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S020 · Edge Cases: Personas debe ser un entero mayor o igual a uno. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S021 · Edge Cases: Campos vacíos se rechazan. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S022 · Edge Cases: Desbordamiento muestra El monto calculado es demasiado grande, sin resultado. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S023 · Edge Cases: Coma y punto son separadores decimales alternativos. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S024 · Edge Cases: No aceptar separadores de miles. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S025 · Edge Cases: Al editar datos se oculta el resultado anterior hasta calcular. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S026 · Edge Cases: Al cambiar modo se oculta el resultado anterior hasta calcular. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S027 · FR-001: Una sola pantalla contiene tres entradas, modo y botón Calcular. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S028 · FR-002: Calcular monto × (1 + propina / 100) / personas. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S029 · FR-003: Exacto redondea a centavos. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S030 · FR-003: Hacia arriba redondea al entero siguiente. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S031 · FR-004: Mostrar siempre dos decimales. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S032 · FR-004: Usar punto en la salida. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S033 · FR-005: Personas inválidas muestran Debe haber al menos una persona. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S034 · FR-006: Monto inválido muestra Monto inválido. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S035 · FR-006: Propina inválida muestra Propina inválida. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S036 · FR-007: Un error impide calcular. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S037 · FR-007: Un error elimina resultados previos. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S038 · FR-008: Aceptar cero. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S039 · FR-008: Rechazar negativos. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S040 · FR-008: Aceptar punto o coma en monto/propina. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S041 · FR-009: No usar red. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S042 · FR-009: No usar almacenamiento. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S043 · FR-009: No usar login. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S044 · FR-009: No usar historial. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S045 · FR-009: No añadir monedas. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S046 · FR-009: No añadir otras pantallas. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S047 · Cuenta: Monto no negativo y finito. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S048 · Cuenta: Personas entero positivo. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S049 · Cuenta: Propina no negativa y finita. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S050 · Resultado: Importe individual después de la estrategia elegida. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S051 · SC-001: Los seis escenarios devuelven exactamente los mensajes o importes definidos. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S052 · SC-002: Ningún error conserva un resultado visible. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S053 · SC-003: Ambas reglas se seleccionan. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S054 · SC-003: Ambas reglas funcionan sin conexión. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S055 · SC-004: Cero tiene verificación ejecutable. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S056 · SC-004: Coma decimal tiene verificación ejecutable. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S057 · SC-004: Negativos tienen verificación ejecutable. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S058 · SC-004: Entradas vacías tienen verificación ejecutable. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S059 · Assumptions: Modo inicial exacto. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S060 · Assumptions: Dos personas inicialmente. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S061 · Assumptions: Propina cero inicialmente. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S062 · Assumptions: Monto inicialmente vacío. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S063 · Assumptions: Validación en orden monto, personas, propina. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |
| S064 · Assumptions: El redondeo a centavos no reparte sobrantes; 3 × 3.33 = 9.99 se acepta. | QUÉ | Intacto | Regla observable o criterio verificable independiente de Flutter. |

Total: **64**; QUÉ: **64 (100%)**; CÓMO: **0 (0%)**; MIXTO: **0 (0%)**. Viaja intacto: **100%**; adaptado: **0%**; no reusable: **0%**.

Fórmula CÓMO = 0 / 64 × 100 = 0%. No supera el 30%, umbral pedagógico de este deber, no una regla universal. Enunciados a modificar: ninguno. El diff inicial y final se conserva vacío; los hashes verifican también identidad byte por byte.

## Constitution, evaluada por separado

Las citas originales corresponden a `.specify/memory/constitution.md` de Flutter antes de añadir el runner web. La redacción React corresponde a `.specify/memory/constitution.md` de este proyecto. No se cuentan metadatos de versión ni la nota histórica «Esta versión inicial concreta únicamente las reglas del enunciado».

| Enunciado original | Regla React | Clasificación | Justificación |
|---|---|---|---|
| C01 · SRP: Cada clase tiene una razón de cambio. | Cada función o módulo tiene una razón de cambio. | adaptada en redacción | JavaScript usa funciones y módulos. |
| C02 · SRP: CalcularDivision únicamente aplica la fórmula y delega el redondeo: no valida ni formatea. | calcularDivision únicamente aplica la fórmula y delega el redondeo: no valida ni formatea. | adaptada en redacción | Cambia el identificador; se conserva la responsabilidad. |
| C03 · SRP: ValidarEntrada valida y FormateadorMoneda formatea. | validarEntrada valida y formateadorMoneda formatea. | adaptada en redacción | Identificadores JavaScript. |
| C04 · OCP: Una nueva regla de redondeo se agrega implementando EstrategiaRedondeo en un archivo nuevo. | Una nueva regla de redondeo se agrega implementando el contrato estrategiaRedondeo en un archivo nuevo. | adaptada en redacción | Contrato estructural en vez de interfaz Dart. |
| C05 · OCP: No se modifican CalcularDivision ni las estrategias existentes. | No se modifican calcularDivision ni las estrategias existentes. | adaptada en redacción | Misma extensión sin modificar consumidores. |
| C06 · LSP: Todas las estrategias reciben un importe finito no negativo y devuelven un importe finito no negativo. | Todas las estrategias reciben un importe finito no negativo y devuelven un importe finito no negativo. | idéntica | Precondición independiente de tecnología. |
| C07 · LSP: El consumidor usa la interfaz sin if de tipo ni casts concretos. | El consumidor usa la interfaz sin if de tipo ni casts concretos. | idéntica | Regla de sustitución. |
| C08 · LSP: Una prueba debe intercambiar exacto y hacia arriba en el mismo caso de uso. | Una prueba debe intercambiar exacto y hacia arriba en el mismo caso de uso. | idéntica | Caso de prueba reusable. |
| C09 · ISP: EstrategiaRedondeo declara únicamente redondear(double importe). | estrategiaRedondeo declara únicamente aplicar(valor). | adaptada en redacción | Se adapta firma Dart al contrato requerido por la guía React. |
| C10 · ISP: No incluye validación, formateo, persistencia ni métodos ajenos al redondeo. | No incluye validación, formateo, persistencia ni métodos ajenos al redondeo. | idéntica | Interfaz pequeña. |
| C11 · DIP: presentation depende de domain, nunca de data. | presentation depende de domain, nunca de data. | idéntica | Dirección de dependencia. |
| C12 · DIP: domain no importa package:flutter ni data. | src/domain no importa react, DOM ni data; es JavaScript puro. | adaptada en redacción | Conserva aislamiento del dominio. |
| C13 · DIP: main.dart es el único punto que instancia implementaciones concretas y conecta dependencias. | src/main.jsx es el único punto que instancia implementaciones concretas y conecta dependencias. | adaptada en redacción | Cambia punto de composición. |
| C14 · DIP: Se permite instanciar objetos de valor Cuenta y Resultado donde corresponde y widgets en la presentación; la regla de composición se aplica a servicios y estrategias inyectables. | Se permite crear objetos de valor cuenta y resultado donde corresponde y elementos JSX en presentación; la regla de composición se aplica a servicios y estrategias inyectables. | adaptada en redacción | JSX sustituye widgets; no se inyectan objetos de valor. |
| C15 · Arquitectura: Capas obligatorias: presentation -> domain <- data. | Capas obligatorias: src/presentation -> src/domain <- src/data. | adaptada en redacción | Rutas src en lugar de lib. |
| C16 · Arquitectura: Dominio Dart puro. | Dominio JavaScript puro. | adaptada en redacción | Lenguaje reemplazado; aislamiento conservado. |
| C17 · Seguridad: No guardar secretos ni API keys. | No guardar secretos ni API keys. | idéntica | Regla independiente del framework. |
| C18 · Arquitectura: Una pantalla sin red ni base de datos. | Una pantalla sin red ni base de datos. | idéntica | Mismo alcance. |
| C19 · Dependencias: El SDK y sus dependencias generadas son la base; no agregar paquetes externos. | Usar React con Vite, Vitest, Testing Library y jsdom; sin librerías de estado externas. | reemplazada | La prohibición de paquetes Flutter impediría usar las herramientas React exigidas. Se limita explícitamente al stack autorizado. |
| C20 · Pruebas: Los seis criterios de aceptación se traducen a pruebas ejecutables y separadas de sus datos. | Los seis criterios de aceptación se traducen a pruebas ejecutables y separadas de sus datos. | idéntica | Datos separados del runner. |
| C21 · Pruebas: Incluir la prueba LSP y las tres pruebas de widget solicitadas. | Incluir la prueba LSP y las tres pruebas de pantalla solicitadas con Testing Library. | adaptada en redacción | Widgets Flutter se sustituyen por DOM. |
| C22 · Materia: Toda función generada debe ser explicable: propósito, entrada, salida y errores. | Toda función generada debe ser explicable: propósito, entrada, salida y errores. | idéntica | Se incluye catálogo explicativo. |
| C23 · Calidad: Los errores de validación deben impedir el cálculo y ocultar cualquier resultado anterior. | Los errores de validación deben impedir el cálculo y ocultar cualquier resultado anterior. | idéntica | Comportamiento verificable. |
| C24 · Governance: La constitución rige spec, plan, tareas y código. | La constitución rige spec, plan, tareas y código. | idéntica | Mismo gobierno. |
| C25 · Governance: Ante un incumplimiento se corrige primero el artefacto que define la regla. | Ante un incumplimiento se corrige primero el artefacto que define la regla. | idéntica | Mismo proceso. |
| C26 · Governance: Revisar el cumplimiento antes y después de implementar. | Revisar el cumplimiento antes y después de implementar. | idéntica | Analyze y converge. |
| C27 · Governance: Cambios de principios incompatibles aumentan MAJOR; ampliaciones MINOR; aclaraciones PATCH. | Cambios de principios incompatibles aumentan MAJOR; ampliaciones MINOR; aclaraciones PATCH. | idéntica | Mismo versionado. |

idéntica: **14/27 (51.85%)**; adaptada en redacción: **12/27 (44.44%)**; reemplazada: **1/27 (3.70%)**.

Reglas modificadas: adaptadas + reemplazadas. No se introduce otro principio de producto. La cobertura crítica se concreta con las pruebas de los seis casos, LSP, pantalla y las aclaraciones SC-004. La prohibición de paquetes de la constitución original ya necesitó una excepción documentada para ejecutar Flutter web; React exige reemplazarla, no ocultarla.

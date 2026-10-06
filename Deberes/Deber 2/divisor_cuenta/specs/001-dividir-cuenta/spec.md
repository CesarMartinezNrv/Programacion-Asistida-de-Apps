# Feature Specification: Dividir una cuenta
**Feature Branch**: `sdd`
**Created**: 2026-10-01
**Status**: Clarified
**Input**: Divisor de cuenta de restaurante, una pantalla sin conexión, monto,
personas, propina, botón Calcular y modos exacto y hacia arriba.

## Clarifications
### Session 2026-10-01
- Q: ¿Aceptamos montos y propinas de cero, rechazando negativos? → A: Sí.
- Q: ¿Permitir coma decimal además del punto? → A: Sí, permitir ambos.
Las respuestas fueron dadas por el usuario en este chat, antes del plan.

## User Scenarios & Testing *(mandatory)*
### User Story 1 - Repartir con propina (Priority: P1)
El usuario ingresa monto, personas y propina, toca Calcular y ve el pago individual.
**Why this priority**: resuelve la necesidad principal.
**Independent Test**: entradas válidas producen el resultado en la misma pantalla.
**Acceptance Scenarios**:
1. **Given** 100.00, 4 personas, 10%, exacto, **When** Calcular, **Then** 27.50.
2. **Given** 90.00, 3 personas, 0%, exacto, **When** Calcular, **Then** 30.00.
5. **Given** 10.00, 3 personas, 0%, exacto, **When** Calcular, **Then** 3.33.

### User Story 2 - Rechazar entradas inválidas (Priority: P1)
**Why this priority**: impide división por cero y resultados engañosos.
**Independent Test**: los errores aparecen sin resultado.
**Acceptance Scenarios**:
3. **Given** 50.00 y 0 personas, **When** Calcular, **Then** “Debe haber al menos una persona”, sin resultado.
4. **Given** monto “abc”, **When** Calcular, **Then** “Monto inválido”, sin resultado.

### User Story 3 - Elegir redondeo (Priority: P2)
**Why this priority**: permite pagar un entero cuando así se desea.
**Independent Test**: cambiar de modo cambia el resultado del mismo reparto.
**Acceptance Scenarios**:
6. **Given** 10.00, 3 personas, 0%, hacia arriba, **When** Calcular, **Then** 4.00.

### Edge Cases
Cero monto y cero propina son válidos; negativos y valores no finitos son inválidos.
Personas debe ser un entero mayor o igual a uno. Campos vacíos se rechazan.
Si el cálculo desborda, mostrar “El monto calculado es demasiado grande”, sin resultado.
Coma y punto son separadores decimales alternativos, sin separadores de miles.
Al editar datos o cambiar modo se oculta el resultado anterior hasta volver a calcular.

## Requirements *(mandatory)*
### Functional Requirements
- **FR-001**: Una sola pantalla contiene las tres entradas, modo y botón Calcular.
- **FR-002**: Calcular monto × (1 + propina / 100) / personas.
- **FR-003**: Exacto redondea a centavos; hacia arriba al entero siguiente.
- **FR-004**: Mostrar siempre dos decimales usando punto en la salida.
- **FR-005**: Personas inválidas muestran “Debe haber al menos una persona”.
- **FR-006**: Monto inválido muestra “Monto inválido”; propina inválida, “Propina inválida”.
- **FR-007**: Un error impide calcular y elimina resultados previos.
- **FR-008**: Aceptar cero y rechazar negativos; aceptar punto o coma en monto/propina.
- **FR-009**: No red, almacenamiento, login, historial, monedas ni otras pantallas.
### Key Entities
- Cuenta: monto no negativo finito, personas entero positivo, propina no negativa finita.
- Resultado: importe individual después de la estrategia elegida.

## Success Criteria *(mandatory)*
### Measurable Outcomes
- **SC-001**: Los seis escenarios devuelven exactamente los mensajes o importes definidos.
- **SC-002**: Ningún error conserva un resultado visible.
- **SC-003**: Ambas reglas se seleccionan y funcionan sin conexión.
- **SC-004**: Cero, coma decimal, negativos y entradas vacías tienen verificación ejecutable.

## Assumptions
Modo inicial exacto, dos personas y propina cero; monto inicialmente vacío.
Validación en orden monto, personas, propina. El redondeo a centavos no reparte sobrantes:
3 × 3.33 = 9.99 se acepta explícitamente en el escenario 5.
No añadir símbolos de moneda. Las decisiones de valores iniciales, orden de errores,
desbordamiento y limpieza al editar son decisiones explícitas del agente, no pedidos textuales.


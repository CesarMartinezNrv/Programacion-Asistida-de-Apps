# Data Model
## Cuenta
double monto finito >= 0, int personas >= 1, double propina finita >= 0.
Objeto inmutable. ValidarEntrada establece precondiciones; la entidad no valida.
## Resultado
double porPersona finito >= 0; resultado después de redondeo.
## EstrategiaRedondeo
double redondear(double importe). Precondición: importe finito >= 0 y representable en centavos.
Postcondición: resultado finito >= 0. Exacto aproxima a centavos; arriba usa ceilToDouble.
## Estado de pantalla
Inicial: resultado/error null. Editar: limpiar resultado/error.
Calcular válido: resultado presente/error null. Calcular inválido: resultado null/error presente.


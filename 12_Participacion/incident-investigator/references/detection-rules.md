# Reglas de detección

Lee esta referencia antes de clasificar los registros de un CSV compatible.

## Convenciones

- Ordena por timestamp y conserva las filas originales; el encabezado cuenta como fila 1.
- Usa ventanas móviles de duración menor o igual a cinco minutos, con ambos extremos incluidos. Dos eventos separados exactamente cinco minutos pueden pertenecer a la misma ventana.
- Compara event y result exactamente. No conviertas healthcheck en login ni cambies mayúsculas o espacios para hacer coincidir una regla.
- No mezcles fechas con zonas horarias incompatibles sin resolver primero su interpretación. No asignes una fecha inventada a un registro inválido.
- No elimines duplicados por parecido. Si no hay identificador inequívoco, conserva los registros y explica que una repetición podría alterar los conteos.
- Agrupa ventanas solapadas cuando describan la misma secuencia para no presentarlas como ataques independientes. Conserva una ventana concreta que cumpla el umbral y sus filas de respaldo.

## R1. Fuerza bruta probable

Busca al menos seis registros con event=login y result=failed desde la misma IP hacia el mismo usuario en una ventana de cinco minutos. Cita los fallos que cumplen el umbral y su intervalo.

Por separado, indica si hay event=login y result=success para esa misma IP y usuario después del último fallo de la ventana citada y hasta cinco minutos después, inclusive. Informa las filas del éxito y el tiempo transcurrido. Un timestamp idéntico al del último fallo no permite afirmar el orden temporal; decláralo. El éxito no es requisito para la alerta ni demuestra que alguien haya comprometido la cuenta.

## R2. Password spraying probable

Busca registros con event=login y result=failed desde una misma IP hacia al menos cinco usuarios distintos en una ventana de cinco minutos. Cuenta usuarios distintos, no cinco intentos al mismo usuario. Cita filas y usuarios que cumplen el umbral. R1 y R2 pueden coincidir; explica el solapamiento.

## R3. Token potencialmente expuesto

Identifica detail que contenga literalmente `token=`. Reporta la fila y, si necesitas citar el campo, muestra únicamente `token=[REDACTED]`. Si hay varios tokens, ocúltalos todos. Si no está claro dónde termina el valor, omite el campo completo. No deduzcas que el token es válido, que fue usado ni que hubo una filtración externa.

## R4. Cambio de rol no aprobado según el registro

Busca event=role_change, result=success y el indicador approved=false en detail. Comprueba que el indicador sea un campo completo y no parte de otro nombre o valor. Si el formato es ambiguo, explica la ambigüedad. Cita la fila y describe lo registrado sin atribuir autoría ni culpabilidad.

## Controles de falsos positivos

Tres fallos aislados no cumplen R1: el umbral exige seis de la misma IP hacia el mismo usuario dentro de cinco minutos. Aun así, revisa por separado si esos registros forman parte de una ventana que cumple otra regla.

Un healthcheck no cuenta como login/failed, aunque detail contenga palabras como failed o login. Un cambio con approved=true no cumple R4. La ausencia de alertas bajo estas reglas no prueba que el sistema sea seguro.

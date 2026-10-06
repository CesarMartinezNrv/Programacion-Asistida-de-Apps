# Contrato de pantalla

Una pantalla accesible con entradas etiquetadas Monto, Personas y Propina (%), selector Redondeo y botón Calcular.
El resultado se presenta bajo Pago por persona con dos decimales y punto, sin símbolo de moneda.
Los errores aparecen con role=alert y eliminan el resultado.
Campos de texto permiten probar abc y coma decimal; no se usa conversión permisiva parseFloat.
No red, persistencia, login, historial, monedas ni navegación adicional.

Hook `useDivisor(dependencias)` recibe validar, calcular, estrategias y formatear. La pantalla recibe las dependencias, sin importar data.

# Modelo de datos

- cuenta(monto, personas, propina): objeto inmutable; monto y propina finitos no negativos, personas entero positivo. La validación ocurre antes de construirlo.
- resultado(importe): objeto inmutable; importe individual tras aplicar una estrategia.
- estrategiaRedondeo: contrato estructural `{ aplicar(valor) }`; recibe y devuelve números finitos no negativos. El coordinador garantiza que valor × 100 sea finito para el redondeo exacto.
- Estado de presentación: textos monto/personas/propina, modo, resultado nullable y error nullable; nunca resultado y error simultáneamente.
- Transiciones: edición → sin resultado/error; calcular válido → resultado; calcular inválido → error sin cálculo; cambiar modo → limpiar resultado.
- Valores iniciales: monto vacío, personas `2`, propina `0`, modo `exacto`.

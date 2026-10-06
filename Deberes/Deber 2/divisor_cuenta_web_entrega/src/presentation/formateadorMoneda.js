/** Devuelve texto con dos decimales y punto, sin símbolo ni separadores de miles. */
export function formateadorMoneda(importe) {
  return importe.toLocaleString('en-US', {
    useGrouping: false, minimumFractionDigits: 2, maximumFractionDigits: 2,
  })
}

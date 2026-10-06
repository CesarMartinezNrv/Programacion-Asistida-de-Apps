/** Envuelve el importe calculado; no valida ni formatea. */
export function resultado(importe) {
  return Object.freeze({ importe })
}

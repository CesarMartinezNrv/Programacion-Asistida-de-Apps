/// Devuelve el primer error; null indica que los datos son válidos.
class ValidarEntrada {
  const ValidarEntrada();
  String? ejecutar({
    required double monto,
    required int personas,
    required double propina,
  }) {
    if (!monto.isFinite || monto < 0) return 'Monto inválido';
    if (personas < 1) return 'Debe haber al menos una persona';
    if (!propina.isFinite || propina < 0) return 'Propina inválida';
    return null;
  }
}

import '../domain/cuenta.dart';
import '../domain/resultado.dart';
import '../domain/validar_entrada.dart';
import '../domain/calcular_division.dart';
import '../domain/estrategia_redondeo.dart';

/// Coordina conversión, validación y cálculo; no depende de Flutter ni data.
class DivisorController {
  final ValidarEntrada validar;
  final CalcularDivision calcular;
  final Map<String, EstrategiaRedondeo> estrategias;
  Resultado? resultado;
  String? error;

  DivisorController({
    required this.validar,
    required this.calcular,
    required Map<String, EstrategiaRedondeo> estrategias,
  }) : estrategias = Map.unmodifiable(estrategias);

  /// Elimina estados anteriores al editar o volver a calcular.
  void limpiar() {
    resultado = null;
    error = null;
  }

  /// Convierte separador decimal local; una entrada no numérica se vuelve NaN.
  double _numero(String texto) =>
      double.tryParse(texto.trim().replaceAll(',', '.')) ?? double.nan;

  /// Publica un resultado o un error; nunca ambos.
  void ejecutar({
    required String monto,
    required String personas,
    required String propina,
    required String modo,
  }) {
    limpiar();
    final total = _numero(monto);
    final cantidad = int.tryParse(personas.trim()) ?? 0;
    final porcentaje = _numero(propina);
    error = validar.ejecutar(
      monto: total,
      personas: cantidad,
      propina: porcentaje,
    );
    if (error != null) return;
    // Precondición numérica: evita desbordamiento antes de delegar el cálculo.
    final importe = total * (1 + porcentaje / 100) / cantidad;
    if (!importe.isFinite || !(importe * 100).isFinite) {
      error = 'El monto calculado es demasiado grande';
      return;
    }
    final estrategia = estrategias[modo];
    if (estrategia == null) {
      error = 'Modo de redondeo inválido';
      return;
    }
    resultado = calcular.ejecutar(
      Cuenta(monto: total, personas: cantidad, propina: porcentaje),
      estrategia,
    );
  }
}

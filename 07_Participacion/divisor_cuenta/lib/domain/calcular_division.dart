import 'cuenta.dart';
import 'resultado.dart';
import 'estrategia_redondeo.dart';

/// Aplica la fórmula a una cuenta válida y delega el redondeo.
class CalcularDivision {
  const CalcularDivision();
  Resultado ejecutar(Cuenta cuenta, EstrategiaRedondeo estrategia) {
    final importe = cuenta.monto * (1 + cuenta.propina / 100) / cuenta.personas;
    return Resultado(estrategia.redondear(importe));
  }
}

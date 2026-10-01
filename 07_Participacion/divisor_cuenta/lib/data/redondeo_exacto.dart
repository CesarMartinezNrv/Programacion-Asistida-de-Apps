import '../domain/estrategia_redondeo.dart';

class RedondeoExacto implements EstrategiaRedondeo {
  const RedondeoExacto();
  @override
  double redondear(double importe) => (importe * 100).roundToDouble() / 100;
}

/// Convierte un importe a texto de dos decimales sin símbolo de moneda.
class FormateadorMoneda {
  const FormateadorMoneda();
  String formatear(double importe) => importe.toStringAsFixed(2);
}

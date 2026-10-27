// Herramienta de consola: imprime evidencia de cada comprobación.
// ignore_for_file: avoid_print
import 'package:divisor_cuenta/domain/cuenta.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';
import 'package:divisor_cuenta/domain/estrategia_redondeo.dart';
import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import '../test/casos_de_prueba.dart';

/// Verifica criterios sin importar Flutter ni bibliotecas de pruebas.
void main() {
  const validar = ValidarEntrada();
  const calcular = CalcularDivision();
  for (final caso in casos) {
    final error = validar.ejecutar(
      monto: caso.monto,
      personas: caso.personas,
      propina: caso.propina,
    );
    if (caso.errorEsperado != null) {
      if (error != caso.errorEsperado) {
        throw StateError('Error inesperado: ${caso.nombre}');
      }
    } else {
      if (error != null) throw StateError(error);
      final EstrategiaRedondeo estrategia = caso.modo == 'arriba'
          ? const RedondeoHaciaArriba()
          : const RedondeoExacto();
      final resultado = calcular.ejecutar(
        Cuenta(
          monto: caso.monto,
          personas: caso.personas,
          propina: caso.propina,
        ),
        estrategia,
      );
      if ((resultado.porPersona - caso.esperado!).abs() > 0.001) {
        throw StateError('Resultado incorrecto: ${caso.nombre}');
      }
    }
    print('PASS ${caso.nombre}');
  }
  const cuenta = Cuenta(monto: 10, personas: 3, propina: 0);
  final estrategias = <EstrategiaRedondeo>[
    const RedondeoExacto(),
    const RedondeoHaciaArriba(),
  ];
  const esperados = [3.33, 4.0];
  for (var i = 0; i < estrategias.length; i++) {
    if ((calcular.ejecutar(cuenta, estrategias[i]).porPersona - esperados[i])
            .abs() >
        0.001) {
      throw StateError('LSP');
    }
  }
  print('PASS LSP; 7 comprobaciones Dart puro');
}

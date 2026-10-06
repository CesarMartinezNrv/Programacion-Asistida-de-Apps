// test_api viene transitivamente de flutter_test; sin nuevos paquetes.
// ignore: depend_on_referenced_packages
import 'package:test_api/scaffolding.dart';
// ignore: depend_on_referenced_packages
import 'package:matcher/expect.dart';
import 'package:divisor_cuenta/domain/cuenta.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';
import 'package:divisor_cuenta/domain/estrategia_redondeo.dart';
import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';

import 'casos_de_prueba.dart';

class _EstrategiaContada implements EstrategiaRedondeo {
  int llamadas = 0;
  @override
  double redondear(double importe) {
    llamadas++;
    return importe;
  }
}

void main() {
  for (final caso in casos) {
    test(caso.nombre, () {
      const validar = ValidarEntrada();
      const calcular = CalcularDivision();
      final error = validar.ejecutar(
        monto: caso.monto,
        personas: caso.personas,
        propina: caso.propina,
      );
      if (caso.errorEsperado != null) {
        final contada = _EstrategiaContada();
        ResultadoDePrueba? salida;
        if (error == null) {
          salida = ResultadoDePrueba(
            calcular
                .ejecutar(
                  Cuenta(
                    monto: caso.monto,
                    personas: caso.personas,
                    propina: caso.propina,
                  ),
                  contada,
                )
                .porPersona,
          );
        }
        expect(error, caso.errorEsperado);
        expect(salida, isNull);
        expect(contada.llamadas, 0);
      } else {
        expect(error, isNull);
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
        expect(resultado.porPersona, closeTo(caso.esperado!, 0.001));
      }
    });
  }
  test('LSP: mismo cálculo, estrategias sustituibles sin casts', () {
    const calcular = CalcularDivision();
    const cuenta = Cuenta(monto: 10, personas: 3, propina: 0);
    final estrategias = <EstrategiaRedondeo>[
      const RedondeoExacto(),
      const RedondeoHaciaArriba(),
    ];
    const esperados = [3.33, 4.0];
    for (var i = 0; i < estrategias.length; i++) {
      expect(
        calcular.ejecutar(cuenta, estrategias[i]).porPersona,
        closeTo(esperados[i], 0.001),
      );
    }
  });
}

// Mantiene la comprobación de ausencia de cálculo separada de objetos productivos.
class ResultadoDePrueba {
  final double valor;
  ResultadoDePrueba(this.valor);
}

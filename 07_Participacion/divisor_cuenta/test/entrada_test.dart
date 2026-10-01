// ignore: depend_on_referenced_packages
import 'package:test_api/scaffolding.dart';
// ignore: depend_on_referenced_packages
import 'package:matcher/expect.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/presentation/divisor_controller.dart';

DivisorController crearController() => DivisorController(
  validar: const ValidarEntrada(),
  calcular: const CalcularDivision(),
  estrategias: const {
    'exacto': RedondeoExacto(),
    'arriba': RedondeoHaciaArriba(),
  },
);

void main() {
  test('Cero es válido', () {
    final controller = crearController()
      ..ejecutar(monto: '0', personas: '1', propina: '0', modo: 'exacto');
    expect(controller.error, isNull);
    expect(controller.resultado!.porPersona, 0);
  });
  test('Punto y coma decimal tienen igual resultado', () {
    for (final separador in ['.', ',']) {
      final controller = crearController()
        ..ejecutar(
          monto: '100${separador}50',
          personas: '2',
          propina: '0',
          modo: 'exacto',
        );
      expect(controller.resultado!.porPersona, 50.25);
    }
  });
  test('Negativos y valores no finitos se rechazan', () {
    const validar = ValidarEntrada();
    for (final monto in [-1.0, double.infinity, double.nan]) {
      expect(
        validar.ejecutar(monto: monto, personas: 1, propina: 0),
        'Monto inválido',
      );
    }
    for (final propina in [-1.0, double.infinity, double.nan]) {
      expect(
        validar.ejecutar(monto: 1, personas: 1, propina: propina),
        'Propina inválida',
      );
    }
  });
  test('Personas fraccionarias y vacías se rechazan', () {
    for (final personas in ['1.5', '', '-1']) {
      final controller = crearController()
        ..ejecutar(
          monto: '10',
          personas: personas,
          propina: '0',
          modo: 'exacto',
        );
      expect(controller.error, 'Debe haber al menos una persona');
      expect(controller.resultado, isNull);
    }
  });
  test('Error posterior borra resultado anterior', () {
    final controller = crearController()
      ..ejecutar(monto: '100', personas: '4', propina: '10', modo: 'exacto');
    expect(controller.resultado!.porPersona, 27.5);
    controller.ejecutar(
      monto: 'abc',
      personas: '4',
      propina: '10',
      modo: 'exacto',
    );
    expect(controller.error, 'Monto inválido');
    expect(controller.resultado, isNull);
  });
  test('Campos vacíos e importe excesivo no producen resultado', () {
    final controller = crearController()
      ..ejecutar(monto: '', personas: '1', propina: '0', modo: 'exacto');
    expect(controller.error, 'Monto inválido');
    controller.ejecutar(
      monto: '10',
      personas: '1',
      propina: '',
      modo: 'exacto',
    );
    expect(controller.error, 'Propina inválida');
    controller.ejecutar(
      monto: '1e308',
      personas: '1',
      propina: '100',
      modo: 'exacto',
    );
    expect(controller.error, 'El monto calculado es demasiado grande');
    expect(controller.resultado, isNull);
  });
}

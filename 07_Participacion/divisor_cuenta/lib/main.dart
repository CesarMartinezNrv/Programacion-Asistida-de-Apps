import 'package:flutter/material.dart';

import 'domain/validar_entrada.dart';
import 'domain/calcular_division.dart';
import 'data/redondeo_exacto.dart';
import 'data/redondeo_hacia_arriba.dart';
import 'presentation/divisor_controller.dart';
import 'presentation/formateador_moneda.dart';
import 'presentation/pantalla_divisor.dart';

void main() => runApp(crearAplicacion());

/// Único punto de composición de servicios e implementaciones.
Widget crearAplicacion() {
  final controller = DivisorController(
    validar: const ValidarEntrada(),
    calcular: const CalcularDivision(),
    estrategias: const {
      'exacto': RedondeoExacto(),
      'arriba': RedondeoHaciaArriba(),
    },
  );
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Divisor de cuenta',
    theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
    home: PantallaDivisor(
      controller: controller,
      formateador: const FormateadorMoneda(),
    ),
  );
}

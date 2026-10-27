import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/main.dart';
import 'package:divisor_cuenta/presentation/pantalla_divisor.dart';
import 'package:divisor_cuenta/presentation/formateador_moneda.dart';

import 'entrada_test.dart' show crearController;

Widget crearApp() => MaterialApp(
  home: PantallaDivisor(
    controller: crearController(),
    formateador: const FormateadorMoneda(),
  ),
);

Future<void> ingresar(
  WidgetTester tester,
  String monto,
  String personas,
  String propina,
) async {
  await tester.enterText(find.byKey(const Key('monto')), monto);
  await tester.enterText(find.byKey(const Key('personas')), personas);
  await tester.enterText(find.byKey(const Key('propina')), propina);
  await tester.tap(find.text('Calcular'));
  await tester.pump();
}

void main() {
  testWidgets('100, 4, 10 muestra 27.50', (tester) async {
    await tester.pumpWidget(crearApp());
    await ingresar(tester, '100', '4', '10');
    expect(find.text('27.50'), findsOneWidget);
  });
  testWidgets('50 y cero personas muestra error sin resultado', (tester) async {
    await tester.pumpWidget(crearApp());
    await ingresar(tester, '100', '4', '10');
    expect(find.byKey(const Key('resultado')), findsOneWidget);
    await ingresar(tester, '50', '0', '0');
    expect(find.text('Debe haber al menos una persona'), findsOneWidget);
    expect(find.byKey(const Key('resultado')), findsNothing);
  });
  testWidgets('abc muestra Monto inválido', (tester) async {
    await tester.pumpWidget(crearApp());
    await ingresar(tester, 'abc', '4', '0');
    expect(find.text('Monto inválido'), findsOneWidget);
    expect(find.byKey(const Key('resultado')), findsNothing);
  });
  testWidgets('Selector hacia arriba muestra 4.00', (tester) async {
    await tester.pumpWidget(crearApp());
    await tester.tap(find.text('Hacia arriba'));
    await tester.pump();
    await ingresar(tester, '10', '3', '0');
    expect(find.text('4.00'), findsOneWidget);
  });
  testWidgets('La composición real inicia la pantalla', (tester) async {
    await tester.pumpWidget(crearAplicacion());
    expect(find.text('Divisor de cuenta'), findsOneWidget);
  });
}

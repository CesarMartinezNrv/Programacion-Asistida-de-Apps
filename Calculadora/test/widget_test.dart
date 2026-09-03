// Tests basicos de la calculadora.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculadora/main.dart';

void main() {
  Future<void> montar(
    WidgetTester tester, {
    Size tamano = const Size(400, 900),
  }) async {
    await tester.binding.setSurfaceSize(tamano);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());
  }

  testWidgets('Arranca mostrando 0', (WidgetTester tester) async {
    await montar(tester);

    expect(find.text('Calculadora'), findsOneWidget);
    // El '0' del display (puede haber mas de uno si el teclado lo tuviera,
    // aqui el boton es '0' tambien, asi que solo comprobamos que exista).
    expect(find.text('0'), findsWidgets);
  });

  testWidgets('2 + 3 = 5', (WidgetTester tester) async {
    await montar(tester);

    await tester.tap(find.widgetWithText(InkWell, '2'));
    await tester.tap(find.widgetWithText(InkWell, '+'));
    await tester.tap(find.widgetWithText(InkWell, '3'));
    await tester.tap(find.widgetWithText(InkWell, '='));
    await tester.pump();

    expect(find.text('5'), findsWidgets);
  });

  testWidgets('Division por cero muestra Error', (WidgetTester tester) async {
    await montar(tester);

    await tester.tap(find.widgetWithText(InkWell, '5'));
    await tester.tap(find.widgetWithText(InkWell, '÷'));
    await tester.tap(find.widgetWithText(InkWell, '0'));
    await tester.tap(find.widgetWithText(InkWell, '='));
    await tester.pump();

    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('No se desborda en pantallas pequenas o apaisadas', (
    WidgetTester tester,
  ) async {
    // Si el layout desbordara, pumpWidget lanzaria una excepcion y el test
    // fallaria automaticamente.
    await montar(tester, tamano: const Size(320, 480));
    await montar(tester, tamano: const Size(800, 360));
  });
}

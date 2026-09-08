import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('mantiene el contador al salir y volver a entrar', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Presiona para empezar'), findsOneWidget);

    await tester.tap(find.text('Empezar'));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Empezar'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
  });
}

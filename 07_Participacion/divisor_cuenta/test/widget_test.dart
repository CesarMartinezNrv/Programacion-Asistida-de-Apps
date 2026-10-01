import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/main.dart';

void main() {
  testWidgets('Muestra el divisor', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Divisor de cuenta'), findsOneWidget);
  });
}

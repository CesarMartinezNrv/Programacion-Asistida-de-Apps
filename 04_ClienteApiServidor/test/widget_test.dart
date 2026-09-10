import 'package:cliente_api_servidor/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('muestra la pantalla para realizar el GET', (tester) async {
    await tester.pumpWidget(const CryptoApp());

    expect(find.text('API de CoinGecko'), findsOneWidget);
    expect(find.text('Hacer petición GET'), findsOneWidget);
    expect(find.text('Petición GET'), findsOneWidget);
  });
}

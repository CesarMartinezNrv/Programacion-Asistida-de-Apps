import 'package:flutter_test/flutter_test.dart';
import 'package:participacion_semana6/main.dart';

void main() {
  testWidgets('muestra instrucciones cuando faltan credenciales', (
    tester,
  ) async {
    await tester.pumpWidget(const ConfiguracionPendienteApp());

    expect(find.text('Falta configurar Supabase'), findsOneWidget);
    expect(find.textContaining('SUPABASE_URL'), findsOneWidget);
  });
}

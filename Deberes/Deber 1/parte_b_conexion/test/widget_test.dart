import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/main.dart';

class _ConexionRepositoryFalso implements ConexionRepository {
  @override
  Future<EstadoConexion> consultarAhora() async => EstadoConexion.wifi;

  @override
  Stream<EstadoConexion> observarCambios() => const Stream.empty();
}

void main() {
  testWidgets('actualiza la foto al consultar', (tester) async {
    final consultar = ConsultarConexion(_ConexionRepositoryFalso());
    await tester.pumpWidget(ConexionApp(consultarConexion: consultar));

    expect(find.text('Estado sin consultar'), findsOneWidget);
    await tester.tap(find.text('Consultar ahora'));
    await tester.pump();

    expect(find.text('Wi-Fi'), findsOneWidget);
    expect(find.textContaining('Consulta:'), findsOneWidget);
  });
}

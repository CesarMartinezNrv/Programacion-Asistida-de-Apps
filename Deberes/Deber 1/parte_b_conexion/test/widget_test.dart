import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';
import 'package:parte_b_conexion/main.dart';

class _ConexionRepositoryFalso implements ConexionRepository {
  final cambios = StreamController<EstadoConexion>.broadcast();

  @override
  Future<EstadoConexion> consultarAhora() async => EstadoConexion.wifi;

  @override
  Stream<EstadoConexion> observarCambios() => cambios.stream;
}

void main() {
  testWidgets('el stream actualiza la pantalla automáticamente', (
    tester,
  ) async {
    final repository = _ConexionRepositoryFalso();
    addTearDown(repository.cambios.close);

    await tester.pumpWidget(
      ConexionApp(
        consultarConexion: ConsultarConexion(repository),
        observarConexion: ObservarConexion(repository),
      ),
    );

    await tester.tap(find.text('Con Stream'));
    await tester.pumpAndSettle();
    expect(find.text('Wi-Fi'), findsOneWidget);
    expect(find.text('Cambios recibidos: 0'), findsOneWidget);

    repository.cambios.add(EstadoConexion.sinConexion);
    await tester.pumpAndSettle();

    expect(find.text('Sin conexión'), findsOneWidget);
    expect(find.text('Cambios recibidos: 1'), findsOneWidget);
  });
}

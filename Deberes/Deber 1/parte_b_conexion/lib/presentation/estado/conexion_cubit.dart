import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';

class ConexionCubit extends Cubit<EstadoConexion> {
  ConexionCubit(this._consultarConexion, this._observarConexion)
    : super(EstadoConexion.otro);

  final ConsultarConexion _consultarConexion;
  final ObservarConexion _observarConexion;
  StreamSubscription<EstadoConexion>? _suscripcion;

  int cambiosRecibidos = 0;

  Future<void> iniciar() async {
    final estadoInicial = await _consultarConexion();
    if (isClosed) return;
    emit(estadoInicial);

    await _suscripcion?.cancel();
    _suscripcion = _observarConexion().listen((estado) {
      cambiosRecibidos++;
      if (!isClosed) emit(estado);
    });
  }

  @override
  Future<void> close() async {
    await _suscripcion?.cancel();
    await super.close();
  }
}

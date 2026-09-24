import 'package:flutter/foundation.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/registrar_usuario.dart';

class SesionProvider extends ChangeNotifier {
  SesionProvider(this._authRepository, this._registrarUsuario)
    : idUsuario = _authRepository.obtenerIdActual();

  final AuthRepository _authRepository;
  final RegistrarUsuario _registrarUsuario;

  String? idUsuario;
  bool cargando = false;
  String? error;

  Future<void> registrar(String correo, String clave, String nombre) async {
    if (!_validar(correo: correo, clave: clave, nombre: nombre)) return;
    await _ejecutar(() async {
      idUsuario = await _registrarUsuario(correo.trim(), clave, nombre.trim());
    });
  }

  Future<void> ingresar(String correo, String clave) async {
    if (!_validar(correo: correo, clave: clave)) return;
    await _ejecutar(() async {
      await _authRepository.ingresar(correo.trim(), clave);
      idUsuario = _authRepository.obtenerIdActual();
    });
  }

  Future<void> salir() async {
    await _ejecutar(() async {
      await _authRepository.salir();
      idUsuario = null;
    });
  }

  bool _validar({
    required String correo,
    required String clave,
    String? nombre,
  }) {
    final correoLimpio = correo.trim();
    final nombreLimpio = nombre?.trim();
    if (correoLimpio.isEmpty || clave.isEmpty || nombreLimpio == '') {
      error = 'Completa todos los campos requeridos.';
    } else if (!correoLimpio.contains('@')) {
      error = 'Ingresa un correo electrónico válido.';
    } else if (clave.length < 6) {
      error = 'La contraseña debe tener al menos 6 caracteres.';
    } else {
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<void> _ejecutar(Future<void> Function() operacion) async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      await operacion();
    } catch (e) {
      error = _mensajeAmigable(e);
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  String _mensajeAmigable(Object excepcion) {
    final mensaje = excepcion.toString().replaceFirst('AuthException: ', '');
    if (mensaje.toLowerCase().contains('invalid login credentials')) {
      return 'El correo o la contraseña no son correctos.';
    }
    if (mensaje.toLowerCase().contains('already registered')) {
      return 'Ya existe una cuenta con este correo.';
    }
    return mensaje;
  }
}

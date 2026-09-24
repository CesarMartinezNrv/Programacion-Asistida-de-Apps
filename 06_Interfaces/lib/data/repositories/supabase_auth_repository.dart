import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseClient get _client => Supabase.instance.client;

  @override
  Future<String> registrar(String correo, String clave) async {
    final respuesta = await _client.auth.signUp(email: correo, password: clave);
    final usuario = respuesta.user;
    if (usuario == null) {
      throw const AuthException('No se pudo crear el usuario.');
    }
    return usuario.id;
  }

  @override
  Future<void> ingresar(String correo, String clave) async {
    await _client.auth.signInWithPassword(email: correo, password: clave);
  }

  @override
  Future<void> salir() => _client.auth.signOut();

  @override
  String? obtenerIdActual() => _client.auth.currentUser?.id;
}

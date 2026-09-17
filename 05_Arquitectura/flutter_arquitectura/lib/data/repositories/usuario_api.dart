import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';

class UsuarioApi implements UsuarioRepository {
  const UsuarioApi();

  @override
  Future<List<Usuario>> obtener() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    if (response.statusCode != 200) {
      throw Exception('No se pudieron obtener los usuarios');
    }

    final usuarios = jsonDecode(response.body) as List<dynamic>;
    return usuarios.map((usuario) {
      final datos = usuario as Map<String, dynamic>;
      return Usuario(
        id: datos['id'] as int,
        nombre: datos['name'] as String,
        email: datos['email'] as String,
      );
    }).toList();
  }
}

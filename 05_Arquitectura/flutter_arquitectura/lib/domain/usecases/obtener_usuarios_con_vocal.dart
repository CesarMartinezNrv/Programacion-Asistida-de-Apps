import '../entities/usuario.dart';
import '../repositories/usuario_repository.dart';

class ObtenerUsuariosConVocal {
  const ObtenerUsuariosConVocal(this.repository);

  final UsuarioRepository repository;

  Future<List<Usuario>> call() async {
    final usuarios = await repository.obtener();
    return usuarios
        .where(
          (usuario) => RegExp(
            r'^[aeiou]',
            caseSensitive: false,
          ).hasMatch(usuario.nombre),
        )
        .toList();
  }
}

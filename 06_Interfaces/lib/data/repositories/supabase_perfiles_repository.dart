import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/perfil.dart';
import '../../domain/repositories/perfiles_repository.dart';

class SupabasePerfilesRepository implements PerfilesRepository {
  SupabaseClient get _client => Supabase.instance.client;

  @override
  Future<void> crear(String id, String nombre) async {
    await _client.from('perfiles').insert({'id': id, 'nombre': nombre});
  }

  @override
  Future<List<Perfil>> obtenerTodos() async {
    final filas = await _client
        .from('perfiles')
        .select('id, nombre, creado_en')
        .order('creado_en', ascending: false);

    return filas
        .map(
          (fila) => Perfil(
            id: fila['id'] as String,
            nombre: fila['nombre'] as String,
            creadoEn: DateTime.parse(fila['creado_en'] as String).toLocal(),
          ),
        )
        .toList(growable: false);
  }
}

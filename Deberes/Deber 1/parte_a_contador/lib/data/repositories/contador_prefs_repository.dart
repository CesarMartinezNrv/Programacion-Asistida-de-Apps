import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/contador_repository.dart';

class ContadorPrefsRepository implements ContadorRepository {
  static const _claveContador = 'contador';

  @override
  Future<int> leer() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_claveContador) ?? 0;
  }

  @override
  Future<void> guardar(int valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_claveContador, valor);
  }
}

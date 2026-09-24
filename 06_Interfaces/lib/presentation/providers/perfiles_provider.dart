import 'package:flutter/foundation.dart';

import '../../domain/entities/perfil.dart';
import '../../domain/repositories/perfiles_repository.dart';

class PerfilesProvider extends ChangeNotifier {
  PerfilesProvider(this._repository);

  final PerfilesRepository _repository;
  List<Perfil> perfiles = const [];
  bool cargando = false;
  String? error;

  Future<void> cargar() async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      perfiles = await _repository.obtenerTodos();
    } catch (e) {
      error = e.toString();
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  void limpiar() {
    perfiles = const [];
    error = null;
    notifyListeners();
  }
}

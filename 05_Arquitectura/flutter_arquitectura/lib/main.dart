import 'package:flutter/material.dart';

import 'data/repositories/usuario_memoria.dart';
import 'domain/usecases/obtener_usuarios_con_vocal.dart';
import 'presentation/pantalla_usuarios.dart';

void main() {
  const repositorio = UsuarioMemoria();
  const obtenerUsuariosConVocal = ObtenerUsuariosConVocal(repositorio);
  runApp(
    const AplicacionUsuarios(obtenerUsuariosConVocal: obtenerUsuariosConVocal),
  );
}

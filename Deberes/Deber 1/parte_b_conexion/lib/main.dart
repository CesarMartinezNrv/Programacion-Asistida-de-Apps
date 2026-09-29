import 'package:flutter/material.dart';

import 'data/repositories/conexion_plus_repository.dart';
import 'domain/usecases/consultar_conexion.dart';
import 'presentation/pantallas/pantalla_foto.dart';

void main() {
  final repository = ConexionPlusRepository();
  runApp(ConexionApp(consultarConexion: ConsultarConexion(repository)));
}

class ConexionApp extends StatelessWidget {
  const ConexionApp({required this.consultarConexion, super.key});

  final ConsultarConexion consultarConexion;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conexión con Future',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        splashFactory: InkRipple.splashFactory,
      ),
      home: PantallaFoto(consultarConexion: consultarConexion),
    );
  }
}

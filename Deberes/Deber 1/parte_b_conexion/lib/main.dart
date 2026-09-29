import 'package:flutter/material.dart';

import 'data/repositories/conexion_plus_repository.dart';
import 'domain/usecases/consultar_conexion.dart';
import 'domain/usecases/observar_conexion.dart';
import 'presentation/pantallas/pantalla_foto.dart';
import 'presentation/pantallas/pantalla_stream.dart';

void main() {
  final repository = ConexionPlusRepository();
  runApp(
    ConexionApp(
      consultarConexion: ConsultarConexion(repository),
      observarConexion: ObservarConexion(repository),
    ),
  );
}

class ConexionApp extends StatelessWidget {
  const ConexionApp({
    required this.consultarConexion,
    required this.observarConexion,
    super.key,
  });

  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Future vs Stream',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        splashFactory: InkRipple.splashFactory,
      ),
      home: InicioConexion(
        consultarConexion: consultarConexion,
        observarConexion: observarConexion,
      ),
    );
  }
}

class InicioConexion extends StatefulWidget {
  const InicioConexion({
    required this.consultarConexion,
    required this.observarConexion,
    super.key,
  });

  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  @override
  State<InicioConexion> createState() => _InicioConexionState();
}

class _InicioConexionState extends State<InicioConexion> {
  int _indice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _indice == 0
          ? PantallaFoto(consultarConexion: widget.consultarConexion)
          : PantallaStream(
              consultarConexion: widget.consultarConexion,
              observarConexion: widget.observarConexion,
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (indice) => setState(() => _indice = indice),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            selectedIcon: Icon(Icons.camera_alt),
            label: 'Con Future',
          ),
          NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie),
            label: 'Con Stream',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../domain/entities/usuario.dart';
import '../domain/usecases/obtener_usuarios_con_vocal.dart';

class AplicacionUsuarios extends StatelessWidget {
  const AplicacionUsuarios({super.key, required this.obtenerUsuariosConVocal});

  final ObtenerUsuariosConVocal obtenerUsuariosConVocal;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Usuarios',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: PantallaUsuarios(obtenerUsuariosConVocal: obtenerUsuariosConVocal),
    );
  }
}

class PantallaUsuarios extends StatefulWidget {
  const PantallaUsuarios({super.key, required this.obtenerUsuariosConVocal});

  final ObtenerUsuariosConVocal obtenerUsuariosConVocal;

  @override
  State<PantallaUsuarios> createState() => _PantallaUsuariosState();
}

class _PantallaUsuariosState extends State<PantallaUsuarios> {
  late final Future<List<Usuario>> _usuarios;

  @override
  void initState() {
    super.initState();
    _usuarios = widget.obtenerUsuariosConVocal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios con nombre vocal')),
      body: FutureBuilder<List<Usuario>>(
        future: _usuarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar usuarios: ${snapshot.error}'),
            );
          }

          final usuarios = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final usuario = usuarios[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${usuario.id}')),
                  title: Text(usuario.nombre),
                  subtitle: Text(usuario.email),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';
import '../estado/conexion_cubit.dart';

class PantallaStream extends StatelessWidget {
  const PantallaStream({
    required this.consultarConexion,
    required this.observarConexion,
    super.key,
  });

  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ConexionCubit(consultarConexion, observarConexion)..iniciar(),
      child: const _ContenidoStream(),
    );
  }
}

class _ContenidoStream extends StatelessWidget {
  const _ContenidoStream();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Con Stream')),
      body: BlocBuilder<ConexionCubit, EstadoConexion>(
        builder: (context, estado) {
          final cubit = context.read<ConexionCubit>();
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_icono(estado), size: 88, color: _color(estado)),
                  const SizedBox(height: 20),
                  Text(
                    _etiqueta(estado),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: _color(estado),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Cambios recibidos: ${cubit.cambiosRecibidos}'),
                  const SizedBox(height: 8),
                  const Text(
                    'La pantalla se actualiza automáticamente.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _etiqueta(EstadoConexion estado) => switch (estado) {
    EstadoConexion.wifi => 'Wi-Fi',
    EstadoConexion.datosMoviles => 'Datos móviles',
    EstadoConexion.otro => 'Otra conexión',
    EstadoConexion.sinConexion => 'Sin conexión',
  };

  IconData _icono(EstadoConexion estado) => switch (estado) {
    EstadoConexion.wifi => Icons.wifi,
    EstadoConexion.datosMoviles => Icons.signal_cellular_alt,
    EstadoConexion.otro => Icons.device_hub,
    EstadoConexion.sinConexion => Icons.wifi_off,
  };

  Color _color(EstadoConexion estado) => switch (estado) {
    EstadoConexion.sinConexion => Colors.red,
    _ => Colors.green,
  };
}

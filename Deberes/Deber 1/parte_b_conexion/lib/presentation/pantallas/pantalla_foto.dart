import 'package:flutter/material.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';

class PantallaFoto extends StatefulWidget {
  const PantallaFoto({required this.consultarConexion, super.key});

  final ConsultarConexion consultarConexion;

  @override
  State<PantallaFoto> createState() => _PantallaFotoState();
}

class _PantallaFotoState extends State<PantallaFoto> {
  EstadoConexion? _estado;
  DateTime? _horaConsulta;
  bool _consultando = false;

  Future<void> _consultar() async {
    if (_consultando) return;
    setState(() => _consultando = true);

    final estado = await widget.consultarConexion();
    final hora = DateTime.now();
    if (!mounted) return;

    setState(() {
      _estado = estado;
      _horaConsulta = hora;
      _consultando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final estado = _estado;

    return Scaffold(
      appBar: AppBar(title: const Text('Con Future')),
      body: Center(
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
              Text(
                _horaConsulta == null
                    ? 'Aún no se ha consultado'
                    : 'Consulta: ${_formatearHora(_horaConsulta!)}',
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _consultando ? null : _consultar,
                icon: const Icon(Icons.refresh),
                label: Text(
                  _consultando ? 'Consultando...' : 'Consultar ahora',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatearHora(DateTime fecha) {
    String dosDigitos(int valor) => valor.toString().padLeft(2, '0');
    return '${dosDigitos(fecha.hour)}:'
        '${dosDigitos(fecha.minute)}:'
        '${dosDigitos(fecha.second)}';
  }

  String _etiqueta(EstadoConexion? estado) => switch (estado) {
    EstadoConexion.wifi => 'Wi-Fi',
    EstadoConexion.datosMoviles => 'Datos móviles',
    EstadoConexion.otro => 'Otra conexión',
    EstadoConexion.sinConexion => 'Sin conexión',
    null => 'Estado sin consultar',
  };

  IconData _icono(EstadoConexion? estado) => switch (estado) {
    EstadoConexion.wifi => Icons.wifi,
    EstadoConexion.datosMoviles => Icons.signal_cellular_alt,
    EstadoConexion.otro => Icons.device_hub,
    EstadoConexion.sinConexion => Icons.wifi_off,
    null => Icons.help_outline,
  };

  Color _color(EstadoConexion? estado) => switch (estado) {
    EstadoConexion.sinConexion => Colors.red,
    null => Colors.grey,
    _ => Colors.green,
  };
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/perfil.dart';
import '../providers/perfiles_provider.dart';
import '../providers/sesion_provider.dart';
import 'pantalla_ingreso.dart';

class PantallaUsuarios extends StatefulWidget {
  const PantallaUsuarios({super.key});

  @override
  State<PantallaUsuarios> createState() => _PantallaUsuariosState();
}

class _PantallaUsuariosState extends State<PantallaUsuarios> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<PerfilesProvider>().cargar();
    });
  }

  Future<void> _cerrarSesion() async {
    await context.read<SesionProvider>().salir();
    if (!mounted) return;
    context.read<PerfilesProvider>().limpiar();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const PantallaIngreso()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<PerfilesProvider>();
    final sesion = context.watch<SesionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Comunidad', style: TextStyle(fontWeight: FontWeight.w800)),
            Text('Usuarios registrados', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Recargar',
            onPressed: estado.cargando
                ? null
                : () => context.read<PerfilesProvider>().cargar(),
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: sesion.cargando ? null : _cerrarSesion,
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: context.read<PerfilesProvider>().cargar,
        child: _ContenidoUsuarios(estado: estado),
      ),
    );
  }
}

class _ContenidoUsuarios extends StatelessWidget {
  const _ContenidoUsuarios({required this.estado});

  final PerfilesProvider estado;

  @override
  Widget build(BuildContext context) {
    if (estado.cargando && estado.perfiles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (estado.error != null && estado.perfiles.isEmpty) {
      return _EstadoMensaje(
        icono: Icons.cloud_off_rounded,
        titulo: 'No pudimos cargar los perfiles',
        detalle: estado.error!,
        accion: 'Intentar otra vez',
        alPulsar: context.read<PerfilesProvider>().cargar,
      );
    }
    if (estado.perfiles.isEmpty) {
      return _EstadoMensaje(
        icono: Icons.person_add_alt_1_rounded,
        titulo: 'Aún no hay perfiles',
        detalle: 'Los nuevos usuarios aparecerán aquí.',
        accion: 'Recargar',
        alPulsar: context.read<PerfilesProvider>().cargar,
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      itemCount: estado.perfiles.length + 1,
      separatorBuilder: (_, index) => SizedBox(height: index == 0 ? 18 : 10),
      itemBuilder: (context, index) {
        if (index == 0) return _Resumen(cantidad: estado.perfiles.length);
        return _TarjetaPerfil(perfil: estado.perfiles[index - 1]);
      },
    );
  }
}

class _Resumen extends StatelessWidget {
  const _Resumen({required this.cantidad});

  final int cantidad;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [colores.primary, colores.tertiary]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.diversity_3_rounded, color: Colors.white, size: 36),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$cantidad ${cantidad == 1 ? 'persona' : 'personas'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                'forman parte de la comunidad',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TarjetaPerfil extends StatelessWidget {
  const _TarjetaPerfil({required this.perfil});

  final Perfil perfil;

  @override
  Widget build(BuildContext context) {
    final formato = DateFormat("d 'de' MMMM, y · HH:mm", 'es');
    final nombre = perfil.nombre.trim();
    final inicial = nombre.isEmpty ? '?' : nombre[0].toUpperCase();
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Text(
            inicial,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        title: Text(
          nombre,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text('Se unió el ${formato.format(perfil.creadoEn)}'),
        ),
      ),
    );
  }
}

class _EstadoMensaje extends StatelessWidget {
  const _EstadoMensaje({
    required this.icono,
    required this.titulo,
    required this.detalle,
    required this.accion,
    required this.alPulsar,
  });

  final IconData icono;
  final String titulo;
  final String detalle;
  final String accion;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(32),
      children: [
        const SizedBox(height: 100),
        Icon(icono, size: 64, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 20),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(detalle, textAlign: TextAlign.center),
        const SizedBox(height: 22),
        Center(
          child: FilledButton.tonal(onPressed: alPulsar, child: Text(accion)),
        ),
      ],
    );
  }
}

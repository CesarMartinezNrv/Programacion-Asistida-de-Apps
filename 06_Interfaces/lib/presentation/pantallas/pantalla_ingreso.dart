import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sesion_provider.dart';
import 'pantalla_usuarios.dart';

class PantallaIngreso extends StatefulWidget {
  const PantallaIngreso({super.key});

  @override
  State<PantallaIngreso> createState() => _PantallaIngresoState();
}

class _PantallaIngresoState extends State<PantallaIngreso> {
  final _correoController = TextEditingController();
  final _claveController = TextEditingController();
  final _nombreController = TextEditingController();
  bool _ocultarClave = true;
  bool _navegacionProgramada = false;

  @override
  void dispose() {
    _correoController.dispose();
    _claveController.dispose();
    _nombreController.dispose();
    super.dispose();
  }

  void _irAUsuarios() {
    if (_navegacionProgramada) return;
    _navegacionProgramada = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const PantallaUsuarios()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final sesion = context.watch<SesionProvider>();
    if (sesion.idUsuario != null) _irAUsuarios();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _EncabezadoIngreso(),
                  const SizedBox(height: 34),
                  TextField(
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.alternate_email_rounded),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _claveController,
                    obscureText: _ocultarClave,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        tooltip: _ocultarClave
                            ? 'Mostrar contraseña'
                            : 'Ocultar contraseña',
                        onPressed: () =>
                            setState(() => _ocultarClave = !_ocultarClave),
                        icon: Icon(
                          _ocultarClave
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _nombreController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Nombre (para crear cuenta)',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                  ),
                  if (sesion.error != null) ...[
                    const SizedBox(height: 16),
                    _MensajeError(mensaje: sesion.error!),
                  ],
                  const SizedBox(height: 22),
                  ElevatedButton(
                    onPressed: sesion.cargando
                        ? null
                        : () => context.read<SesionProvider>().ingresar(
                            _correoController.text,
                            _claveController.text,
                          ),
                    child: sesion.cargando
                        ? const SizedBox.square(
                            dimension: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Ingresar'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: sesion.cargando
                        ? null
                        : () => context.read<SesionProvider>().registrar(
                            _correoController.text,
                            _claveController.text,
                            _nombreController.text,
                          ),
                    child: const Text('Crear cuenta'),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Al continuar, tu perfil será visible para los usuarios registrados.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EncabezadoIngreso extends StatelessWidget {
  const _EncabezadoIngreso();

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: colores.primaryContainer,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(Icons.groups_2_rounded, color: colores.primary, size: 30),
        ),
        const SizedBox(height: 24),
        Text(
          'Tu comunidad,\nen un solo lugar.',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Ingresa a tu cuenta o crea un perfil para conocer a los usuarios registrados.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: colores.onSurfaceVariant,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _MensajeError extends StatelessWidget {
  const _MensajeError({required this.mensaje});

  final String mensaje;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colores.errorContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: colores.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              mensaje,
              style: TextStyle(color: colores.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

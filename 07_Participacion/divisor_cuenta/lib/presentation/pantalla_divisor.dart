import 'package:flutter/material.dart';

import 'divisor_controller.dart';
import 'formateador_moneda.dart';

class PantallaDivisor extends StatefulWidget {
  final DivisorController controller;
  final FormateadorMoneda formateador;
  const PantallaDivisor({
    super.key,
    required this.controller,
    required this.formateador,
  });
  @override
  State<PantallaDivisor> createState() => _PantallaDivisorState();
}

class _PantallaDivisorState extends State<PantallaDivisor> {
  final _monto = TextEditingController();
  final _personas = TextEditingController(text: '2');
  final _propina = TextEditingController(text: '0');
  String _modo = 'exacto';

  void _limpiar(String _) => setState(widget.controller.limpiar);

  void _calcular() => setState(
    () => widget.controller.ejecutar(
      monto: _monto.text,
      personas: _personas.text,
      propina: _propina.text,
      modo: _modo,
    ),
  );

  @override
  void dispose() {
    _monto.dispose();
    _personas.dispose();
    _propina.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Divisor de cuenta')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(24),
          children: [
            TextField(
              key: const Key('monto'),
              controller: _monto,
              onChanged: _limpiar,
              decoration: const InputDecoration(
                labelText: 'Monto total',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('personas'),
              controller: _personas,
              onChanged: _limpiar,
              decoration: const InputDecoration(
                labelText: 'Número de personas',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('propina'),
              controller: _propina,
              onChanged: _limpiar,
              decoration: const InputDecoration(
                labelText: 'Propina (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 24),
            const Text('Redondeo'),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'exacto', label: Text('Exacto')),
                ButtonSegment(value: 'arriba', label: Text('Hacia arriba')),
              ],
              selected: {_modo},
              onSelectionChanged: (valores) => setState(() {
                _modo = valores.single;
                widget.controller.limpiar();
              }),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _calcular, child: const Text('Calcular')),
            const SizedBox(height: 24),
            if (widget.controller.error != null)
              Text(
                widget.controller.error!,
                key: const Key('error'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            if (widget.controller.resultado != null) ...[
              const Text('Cada persona paga', textAlign: TextAlign.center),
              Text(
                widget.formateador.formatear(
                  widget.controller.resultado!.porPersona,
                ),
                key: const Key('resultado'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

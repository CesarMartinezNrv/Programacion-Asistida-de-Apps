import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Divisor de cuenta',
    theme: ThemeData(colorSchemeSeed: Colors.teal),
    home: const PantallaCuenta(),
  );
}

class PantallaCuenta extends StatefulWidget {
  const PantallaCuenta({super.key});
  @override
  State<PantallaCuenta> createState() => _PantallaCuentaState();
}

class _PantallaCuentaState extends State<PantallaCuenta> {
  final monto = TextEditingController();
  final personas = TextEditingController(text: '2');
  final propina = TextEditingController(text: '0');
  String? resultado;
  String? error;

  void calcular() {
    setState(() {
      resultado = null;
      error = null;
      final total = double.tryParse(monto.text);
      final cantidad = int.tryParse(personas.text);
      final porcentaje = double.tryParse(propina.text);
      if (total == null || !total.isFinite || total < 0) {
        error = 'Monto inválido';
      } else if (cantidad == null || cantidad < 1) {
        error = 'Debe haber al menos una persona';
      } else if (porcentaje == null || !porcentaje.isFinite || porcentaje < 0) {
        error = 'Propina inválida';
      } else {
        resultado = (total * (1 + porcentaje / 100) / cantidad).toStringAsFixed(
          2,
        );
      }
    });
  }

  @override
  void dispose() {
    monto.dispose();
    personas.dispose();
    propina.dispose();
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
              controller: monto,
              decoration: const InputDecoration(labelText: 'Monto total'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            TextField(
              controller: personas,
              decoration: const InputDecoration(
                labelText: 'Número de personas',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: propina,
              decoration: const InputDecoration(labelText: 'Propina (%)'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: calcular, child: const Text('Calcular')),
            if (error != null) Text(error!),
            if (resultado != null) ...[
              const Text('Cada persona paga'),
              Text(resultado!),
            ],
          ],
        ),
      ),
    ),
  );
}

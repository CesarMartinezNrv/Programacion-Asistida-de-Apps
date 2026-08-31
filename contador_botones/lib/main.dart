import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int contador = 0;

  void restar() {
    setState(() {
      if (contador > 0) {
        contador--;
      }
    });
  }

  void resetear() {
    setState(() {
      contador = 0;
    });
  }

  void sumar() {
    setState(() {
      contador++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador de golpes'),
      ),

      body: Stack(
        children: [
          // CONTADOR EN EL CENTRO
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'GOLPES',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  '$contador',
                  style: const TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // IMAGEN EN LA ESQUINA SUPERIOR DERECHA
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: sumar,
              child: Image.asset(
                'assets/images/punching.jpg',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // BOTONES EN LA PARTE INFERIOR
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  heroTag: 'restar',
                  onPressed: restar,
                  child: const Icon(Icons.remove),
                ),

                ElevatedButton(
                  onPressed: resetear,
                  child: const Text('Reset'),
                ),

                FloatingActionButton(
                  heroTag: 'sumar',
                  onPressed: sumar,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
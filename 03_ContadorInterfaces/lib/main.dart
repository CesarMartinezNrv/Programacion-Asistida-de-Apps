import 'dart:async';

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
      title: 'Golpes',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF101010),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF181818),
          foregroundColor: Colors.amber,
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
        ),
      ),
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
  bool mostrarGolpe = false;
  Timer? temporizadorGolpe;

  void restar() {
    if (contador == 0) {
      return;
    }

    setState(() {
      contador--;
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

  void golpear() {
    temporizadorGolpe?.cancel();

    setState(() {
      contador++;
      mostrarGolpe = true;
    });

    temporizadorGolpe = Timer(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          mostrarGolpe = false;
        });
      }
    });
  }

  @override
  void dispose() {
    temporizadorGolpe?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Golpes')),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'GOLPES',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '$contador',
                  key: const ValueKey('contador'),
                  style: const TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 30,
            left: 24,
            child: AnimatedOpacity(
              opacity: mostrarGolpe ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: const Text(
                '¡GOLPE!',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: InkWell(
              onTap: golpear,
              borderRadius: BorderRadius.circular(16),
              child: Ink(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.sports_mma,
                  size: 56,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
                  tooltip: 'Restar',
                  child: const Icon(Icons.remove),
                ),
                ElevatedButton(
                  onPressed: resetear,
                  child: const Text('Reset'),
                ),
                FloatingActionButton(
                  heroTag: 'sumar',
                  onPressed: sumar,
                  tooltip: 'Sumar',
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

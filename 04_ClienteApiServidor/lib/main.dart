import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const CryptoApp());
}

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cliente CoinGecko',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const CryptoPage(),
    );
  }
}

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  static final Uri _url = Uri.parse(
    'https://api.coingecko.com/api/v3/coins/markets'
    '?vs_currency=usd&order=market_cap_desc&per_page=5&page=1&sparkline=false',
  );

  List<Moneda> _monedas = [];
  String _jsonRecibido = '';
  String? _error;
  int? _codigoEstado;
  bool _cargando = false;

  Future<void> _hacerPeticionGet() async {
    setState(() {
      _cargando = true;
      _error = null;
      _codigoEstado = null;
      _jsonRecibido = '';
    });

    try {
      // 1. Se realiza la petición GET a la URL de CoinGecko.
      final respuesta = await http.get(_url);

      // 2. La API devuelve un código de estado y texto en formato JSON.
      final jsonDecodificado = jsonDecode(respuesta.body);
      final jsonFormateado = const JsonEncoder.withIndent(
        '  ',
      ).convert(jsonDecodificado);

      debugPrint('GET $_url');
      debugPrint('Estado HTTP: ${respuesta.statusCode}');
      debugPrint(jsonFormateado);

      if (respuesta.statusCode != 200) {
        throw Exception(
          'La API respondió con el código ${respuesta.statusCode}.',
        );
      }

      // 3. Cada objeto del arreglo JSON se convierte en un objeto Moneda.
      final listaJson = jsonDecodificado as List<dynamic>;
      final monedas = listaJson
          .map((elemento) => Moneda.fromJson(elemento as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _codigoEstado = respuesta.statusCode;
        _jsonRecibido = jsonFormateado;
        _monedas = monedas;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _monedas = [];
        _error = 'No se pudieron obtener los datos: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API de CoinGecko')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Petición GET',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SelectableText(
              _url.toString(),
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _cargando ? null : _hacerPeticionGet,
              icon: const Icon(Icons.download),
              label: const Text('Hacer petición GET'),
            ),
            if (_cargando) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            if (_codigoEstado != null) ...[
              const SizedBox(height: 16),
              Text(
                'Respuesta HTTP: $_codigoEstado OK',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 32),
              const Text(
                'Datos convertidos desde JSON',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._monedas.map((moneda) => TarjetaMoneda(moneda: moneda)),
              const Divider(height: 32),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: const Text(
                  'Ver JSON recibido',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: Colors.black87,
                    child: SelectableText(
                      _jsonRecibido,
                      style: const TextStyle(
                        color: Colors.lightGreenAccent,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class Moneda {
  const Moneda({
    required this.nombre,
    required this.simbolo,
    required this.precioActual,
    required this.maximo24h,
    required this.minimo24h,
  });

  final String nombre;
  final String simbolo;
  final double precioActual;
  final double maximo24h;
  final double minimo24h;

  factory Moneda.fromJson(Map<String, dynamic> json) {
    return Moneda(
      nombre: json['name'] as String,
      simbolo: (json['symbol'] as String).toUpperCase(),
      precioActual: (json['current_price'] as num).toDouble(),
      maximo24h: (json['high_24h'] as num).toDouble(),
      minimo24h: (json['low_24h'] as num).toDouble(),
    );
  }
}

class TarjetaMoneda extends StatelessWidget {
  const TarjetaMoneda({super.key, required this.moneda});

  final Moneda moneda;

  String _dinero(double valor) {
    final decimales = valor < 1 ? 6 : 2;
    return '\$${valor.toStringAsFixed(decimales)} USD';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${moneda.nombre} (${moneda.simbolo})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Precio actual: ${_dinero(moneda.precioActual)}'),
            Text('Máximo 24 h: ${_dinero(moneda.maximo24h)}'),
            Text('Mínimo 24 h: ${_dinero(moneda.minimo24h)}'),
          ],
        ),
      ),
    );
  }
}

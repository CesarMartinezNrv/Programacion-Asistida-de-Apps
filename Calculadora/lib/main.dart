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
      title: 'Calculadora',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalculadoraPage(),
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  // Lo que se ve en pantalla.
  String display = '0';

  // Valor acumulado y operacion pendiente.
  double? acumulado;
  String? operacionPendiente;

  // Si el ultimo boton pulsado fue "=" o un operador, el siguiente digito
  // empieza un numero nuevo.
  bool empezarNuevoNumero = true;

  void _pulsarDigito(String digito) {
    setState(() {
      if (empezarNuevoNumero || display == '0') {
        display = digito;
        empezarNuevoNumero = false;
      } else {
        display += digito;
      }
    });
  }

  void _pulsarPunto() {
    setState(() {
      if (empezarNuevoNumero) {
        display = '0.';
        empezarNuevoNumero = false;
      } else if (!display.contains('.')) {
        display += '.';
      }
    });
  }

  void _limpiarTodo() {
    setState(() {
      display = '0';
      acumulado = null;
      operacionPendiente = null;
      empezarNuevoNumero = true;
    });
  }

  void _borrarUltimo() {
    setState(() {
      if (empezarNuevoNumero) return;
      if (display.length <= 1 || (display.length == 2 && display.startsWith('-'))) {
        display = '0';
        empezarNuevoNumero = true;
      } else {
        display = display.substring(0, display.length - 1);
      }
    });
  }

  void _cambiarSigno() {
    setState(() {
      if (display == '0') return;
      if (display.startsWith('-')) {
        display = display.substring(1);
      } else {
        display = '-$display';
      }
    });
  }

  void _porcentaje() {
    setState(() {
      final valor = double.tryParse(display) ?? 0;
      display = _formatear(valor / 100);
      empezarNuevoNumero = true;
    });
  }

  void _pulsarOperador(String op) {
    setState(() {
      final valorActual = double.tryParse(display) ?? 0;

      if (acumulado == null) {
        acumulado = valorActual;
      } else if (!empezarNuevoNumero) {
        acumulado = _operar(acumulado!, valorActual, operacionPendiente!);
        display = _formatear(acumulado!);
      }

      operacionPendiente = op;
      empezarNuevoNumero = true;
    });
  }

  void _igual() {
    setState(() {
      if (operacionPendiente == null || acumulado == null) return;

      final valorActual = double.tryParse(display) ?? 0;
      final resultado = _operar(acumulado!, valorActual, operacionPendiente!);

      display = _formatear(resultado);
      acumulado = null;
      operacionPendiente = null;
      empezarNuevoNumero = true;
    });
  }

  double _operar(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '×':
        return a * b;
      case '÷':
        return b == 0 ? double.nan : a / b;
      default:
        return b;
    }
  }

  String _formatear(double valor) {
    if (valor.isNaN || valor.isInfinite) return 'Error';
    // Sin decimales innecesarios: 4.0 -> "4", 4.5 -> "4.5".
    if (valor == valor.roundToDouble() && valor.abs() < 1e15) {
      return valor.toStringAsFixed(0);
    }
    return valor
        .toStringAsPrecision(12)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // PANTALLA
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    display,
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),

            // TECLADO
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  _fila([
                    _BotonCalc('C', color: _Tipo.funcion, onTap: _limpiarTodo),
                    _BotonCalc('+/-', color: _Tipo.funcion, onTap: _cambiarSigno),
                    _BotonCalc('%', color: _Tipo.funcion, onTap: _porcentaje),
                    _BotonCalc('÷',
                        color: _Tipo.operador,
                        onTap: () => _pulsarOperador('÷')),
                  ]),
                  _fila([
                    _BotonCalc('7', onTap: () => _pulsarDigito('7')),
                    _BotonCalc('8', onTap: () => _pulsarDigito('8')),
                    _BotonCalc('9', onTap: () => _pulsarDigito('9')),
                    _BotonCalc('×',
                        color: _Tipo.operador,
                        onTap: () => _pulsarOperador('×')),
                  ]),
                  _fila([
                    _BotonCalc('4', onTap: () => _pulsarDigito('4')),
                    _BotonCalc('5', onTap: () => _pulsarDigito('5')),
                    _BotonCalc('6', onTap: () => _pulsarDigito('6')),
                    _BotonCalc('-',
                        color: _Tipo.operador, onTap: () => _pulsarOperador('-')),
                  ]),
                  _fila([
                    _BotonCalc('1', onTap: () => _pulsarDigito('1')),
                    _BotonCalc('2', onTap: () => _pulsarDigito('2')),
                    _BotonCalc('3', onTap: () => _pulsarDigito('3')),
                    _BotonCalc('+',
                        color: _Tipo.operador, onTap: () => _pulsarOperador('+')),
                  ]),
                  _fila([
                    _BotonCalc('⌫', color: _Tipo.funcion, onTap: _borrarUltimo),
                    _BotonCalc('0', onTap: () => _pulsarDigito('0')),
                    _BotonCalc('.', onTap: _pulsarPunto),
                    _BotonCalc('=', color: _Tipo.igual, onTap: _igual),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fila(List<Widget> botones) {
    return Row(
      children: botones
          .map((b) => Expanded(child: b))
          .toList(),
    );
  }
}

enum _Tipo { numero, funcion, operador, igual }

class _BotonCalc extends StatelessWidget {
  const _BotonCalc(this.texto, {this.color = _Tipo.numero, required this.onTap});

  final String texto;
  final _Tipo color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Color fondo;
    Color textoColor;
    switch (color) {
      case _Tipo.operador:
        fondo = scheme.primaryContainer;
        textoColor = scheme.onPrimaryContainer;
        break;
      case _Tipo.igual:
        fondo = scheme.primary;
        textoColor = scheme.onPrimary;
        break;
      case _Tipo.funcion:
        fondo = scheme.surfaceContainerHighest;
        textoColor = scheme.onSurface;
        break;
      case _Tipo.numero:
        fondo = scheme.surfaceContainerHigh;
        textoColor = scheme.onSurface;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(6),
      child: AspectRatio(
        aspectRatio: 1.4,
        child: Material(
          color: fondo,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Center(
              child: Text(
                texto,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: textoColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

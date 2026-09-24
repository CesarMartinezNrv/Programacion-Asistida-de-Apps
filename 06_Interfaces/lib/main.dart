import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/repositories/supabase_auth_repository.dart';
import 'data/repositories/supabase_perfiles_repository.dart';
import 'domain/usecases/registrar_usuario.dart';
import 'presentation/pantallas/pantalla_ingreso.dart';
import 'presentation/providers/perfiles_provider.dart';
import 'presentation/providers/sesion_provider.dart';
import 'presentation/tema/tema_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await initializeDateFormatting('es');

  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final supabaseKey = dotenv.env['SUPABASE_KEY'] ?? '';
  final configuracionValida =
      supabaseUrl.startsWith('https://') &&
      supabaseUrl.contains('.supabase.co') &&
      supabaseKey.isNotEmpty &&
      !supabaseKey.contains('TU_CLAVE');

  if (!configuracionValida) {
    runApp(const ConfiguracionPendienteApp());
    return;
  }

  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseKey);

  final authRepository = SupabaseAuthRepository();
  final perfilesRepository = SupabasePerfilesRepository();
  final registrarUsuario = RegistrarUsuario(authRepository, perfilesRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SesionProvider(authRepository, registrarUsuario),
        ),
        ChangeNotifierProvider(
          create: (_) => PerfilesProvider(perfilesRepository),
        ),
      ],
      child: const UsuariosApp(),
    ),
  );
}

class UsuariosApp extends StatelessWidget {
  const UsuariosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comunidad USFQ',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.claro,
      home: const PantallaIngreso(),
    );
  }
}

class ConfiguracionPendienteApp extends StatelessWidget {
  const ConfiguracionPendienteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: TemaApp.claro,
      home: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: const Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.settings_suggest_outlined, size: 64),
                  SizedBox(height: 20),
                  Text(
                    'Falta configurar Supabase',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Reemplaza los valores de SUPABASE_URL y SUPABASE_KEY en el archivo .env y vuelve a iniciar la aplicación.',
                    textAlign: TextAlign.center,
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

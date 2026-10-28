import 'package:flutter/material.dart';
import 'package:mapa_locais/screens/mapa_screen.dart';

class LocalApp extends StatelessWidget {
  final Object? firebaseInitializationError;

  const LocalApp({super.key, this.firebaseInitializationError});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapa de Locais',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: firebaseInitializationError == null
          ? const MapaScreen()
          : _FirebaseInitializationErrorScreen(
              error: firebaseInitializationError!,
            ),
      onGenerateRoute: (settings) {
        if (settings.name != '/mapa') {
          return null;
        }

        final arguments = settings.arguments;
        final mapArguments = arguments is Map<String, String>
            ? arguments
            : const <String, String>{};

        return MaterialPageRoute<void>(
          builder: (_) => MapaScreen(
            cidadeInicial: mapArguments['cidade'] ?? 'São Paulo',
            pesquisaInicial: mapArguments['pesquisa'] ?? '',
          ),
        );
      },
    );
  }
}

class _FirebaseInitializationErrorScreen extends StatelessWidget {
  final Object error;

  const _FirebaseInitializationErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de locais')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Não foi possível inicializar o Firebase. '
                'Configure o projeto com `flutterfire configure` e tente novamente.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              SelectableText(error.toString(), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

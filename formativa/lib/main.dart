import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mapa_locais/app.dart';
import 'package:mapa_locais/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error, stackTrace) {
    debugPrint('Falha ao inicializar o Firebase: $error');
    debugPrintStack(stackTrace: stackTrace);
    runApp(LocalApp(firebaseInitializationError: error));
    return;
  }

  runApp(const LocalApp());
}

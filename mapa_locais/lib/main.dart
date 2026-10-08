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
  } catch (_) {
    // O projeto pode continuar em modo offline até a configuração real do Firebase.
  }

  runApp(const LocalApp());
}

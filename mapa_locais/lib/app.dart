import 'package:flutter/material.dart';
import 'package:mapa_locais/screens/mapa_screen.dart';

class LocalApp extends StatelessWidget {
  const LocalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapa de Locais',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MapaScreen(),
    );
  }
}

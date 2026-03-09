import 'package:flutter/material.dart';

void main() {
  runApp(HumorApp());
}

class HumorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Botão de Humor',
      debugShowCheckedModeBanner: false,
      home: HumorPage(),
    );
  }
}

class HumorPage extends StatefulWidget {
  @override
  _HumorPageState createState() => _HumorPageState();
}

class _HumorPageState extends State<HumorPage> {

  int estado = 0;

  final List<String> humores = [
    "😀 Feliz",
    "😐 Neutro",
    "😡 Bravo"
  ];

  void mudarHumor() {
    setState(() {
      estado++;
      if (estado >= humores.length) {
        estado = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Botão de Humor"),
      ),
      body: Center(
        child: Text(
          humores[estado],
          style: TextStyle(fontSize: 40),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: mudarHumor,
        child: Icon(Icons.mood),
      ),
    );
  }
}
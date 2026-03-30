import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SalvarTextoApp(),
  ));
}

class SalvarTextoApp extends StatefulWidget {
  const SalvarTextoApp({super.key});

  @override
  State<SalvarTextoApp> createState() => _SalvarTextoAppState();
}

class _SalvarTextoAppState extends State<SalvarTextoApp> {
  final TextEditingController _controller = TextEditingController();
  String _textoSalvo = '';

  @override
  void initState() {
    super.initState();
    _carregarTexto();
  }

  @override
  void dispose() {
    _controller.dispose(); // evita vazamento de memória
    super.dispose();
  }

  Future<void> _carregarTexto() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _textoSalvo = prefs.getString('texto') ?? '';
    });
  }

  Future<void> _salvarTexto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('texto', _controller.text);

    _controller.clear(); // limpa o campo (opcional)
    _carregarTexto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salvar Texto com Shared Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Digite algo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarTexto,
              child: const Text('Salvar'),
            ),
            const SizedBox(height: 20),
            Text(
              'Texto salvo: $_textoSalvo',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
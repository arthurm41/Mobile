import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; // corrigido
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AppBanco(),
  ));
}

class AppBanco extends StatefulWidget {
  @override
  _AppBancoState createState() => _AppBancoState();
}

class _AppBancoState extends State<AppBanco> {
  Database? _database;
  List<Map<String, dynamic>> _dados = [];

  @override
  void initState() {
    super.initState();
    _initBanco();
  }

  // Inicializa o banco
  Future<void> _initBanco() async {
    String caminho = join(await getDatabasesPath(), 'meubanco.db');

    _database = await openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT
          )
        ''');
      },
    );

    _carregarDados();
  }

  // Inserir dado
  Future<void> _inserir(String nome) async {
    await _database?.insert('usuarios', {'nome': nome});
    _carregarDados();
  }

  // Buscar dados
  Future<void> _carregarDados() async {
    final dados = await _database?.query('usuarios');
    setState(() {
      _dados = dados ?? [];
    });
  }

  // Interface simples
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Banco SQLite Flutter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _inserir(_controller.text);
                _controller.clear();
              },
              child: Text('Salvar'),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _dados.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_dados[index]['nome']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
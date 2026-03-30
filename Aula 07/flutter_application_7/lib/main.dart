import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ListaContatos(),
    );
  }
}

// ================= LISTA DE CONTATOS =================        
class ListaContatos extends StatelessWidget {
  const ListaContatos({super.key});

  @override
  Widget build(BuildContext context) {
    final contatos = [
      {
        'nome': 'Arthur',
        'telefone': '1199999-1111',
        'cor': Colors.blue,
        'icone': Icons.person,
      },
      {
        'nome': 'Ramos',
        'telefone': '1198888-2222',
        'cor': Colors.green,
        'icone': Icons.person_outline,
      },
      {
        'nome': 'Marques',
        'telefone': '1197777-3333',
        'cor': Colors.orange,
        'icone': Icons.account_circle,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Contatos'),
      ),
      body: ListView.builder(
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          final contato = contatos[index];

          return ListTile(
            leading: Icon(
              contato['icone'] as IconData,
              color: contato['cor'] as Color,
            ),
            title: Text(contato['nome'] as String),
            subtitle: Text(contato['telefone'] as String),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalheContato(
                    nome: contato['nome'] as String,
                    telefone: contato['telefone'] as String,
                    cor: contato['cor'] as Color,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ================= TELA DE DETALHES =================
class DetalheContato extends StatelessWidget {
  final String nome;
  final String telefone;
  final Color cor;

  const DetalheContato({
    super.key,
    required this.nome,
    required this.telefone,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nome),
        backgroundColor: cor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80, color: cor),
            const SizedBox(height: 20),

            Text(
              nome,
              style: const TextStyle(fontSize: 24),
            ),

            const SizedBox(height: 10),

            Text(
              telefone,
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              icon: const Icon(Icons.phone),
              label: const Text('Ligar'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ligando para $nome...'),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text('Voltar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
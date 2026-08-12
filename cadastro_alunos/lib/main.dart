import 'package:flutter/material.dart';

void main() {
  runApp(const CadastroAlunosApp());
}

class CadastroAlunosApp extends StatelessWidget {
  const CadastroAlunosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Alunos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CadastroAlunosPage(),
    );
  }
}

class CadastroAlunosPage extends StatefulWidget {
  const CadastroAlunosPage({super.key});

  @override
  State<CadastroAlunosPage> createState() => _CadastroAlunosPageState();
}

class _CadastroAlunosPageState extends State<CadastroAlunosPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController cursoController = TextEditingController();

  final List<Map<String, String>> alunos = [];

  void cadastrarAluno() {
    String nome = nomeController.text.trim();
    String idade = idadeController.text.trim();
    String curso = cursoController.text.trim();

    if (nome.isEmpty || idade.isEmpty || curso.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos!'),
        ),
      );
      return;
    }

    setState(() {
      alunos.add({
        'nome': nome,
        'idade': idade,
        'curso': curso,
      });
    });

    nomeController.clear();
    idadeController.clear();
    cursoController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Aluno cadastrado com sucesso!'),
      ),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    idadeController.dispose();
    cursoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Alunos'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cadastrar aluno',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: idadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Idade',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.cake),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: cursoController,
              decoration: const InputDecoration(
                labelText: 'Curso',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: cadastrarAluno,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Cadastrar',
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Alunos cadastrados',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: alunos.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum aluno cadastrado.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: alunos.length,
                      itemBuilder: (context, index) {
                        final aluno = alunos[index];

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                aluno['nome']![0].toUpperCase(),
                              ),
                            ),
                            title: Text(
                              aluno['nome']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Idade: ${aluno['idade']} anos\n'
                              'Curso: ${aluno['curso']}',
                            ),
                          ),
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
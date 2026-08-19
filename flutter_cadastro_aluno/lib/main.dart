import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaPrincipal(),
    ),
  );
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final nomeController = TextEditingController();
  final idadeController = TextEditingController();
  final cursoController = TextEditingController();

  final CollectionReference alunos =
      FirebaseFirestore.instance.collection('alunos');

  Future<void> cadastrarAluno() async {
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

    await alunos.add({
      'nome': nome,
      'idade': int.tryParse(idade) ?? 0,
      'curso': curso,
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

  Future<void> editarAluno(
    String id,
    String nome,
    String idade,
    String curso,
  ) async {
    final nomeEditController = TextEditingController(text: nome);
    final idadeEditController = TextEditingController(text: idade);
    final cursoEditController = TextEditingController(text: curso);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar aluno'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeEditController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
              ),
              TextField(
                controller: idadeEditController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                ),
              ),
              TextField(
                controller: cursoEditController,
                decoration: const InputDecoration(
                  labelText: 'Curso',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nomeEditController.text.isEmpty ||
                    idadeEditController.text.isEmpty ||
                    cursoEditController.text.isEmpty) {
                  return;
                }

                await alunos.doc(id).update({
                  'nome': nomeEditController.text.trim(),
                  'idade': int.tryParse(idadeEditController.text) ?? 0,
                  'curso': cursoEditController.text.trim(),
                });

                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> excluirAluno(String id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir aluno'),
          content: const Text(
            'Deseja realmente excluir este aluno?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await alunos.doc(id).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Alunos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: cadastrarAluno,
                icon: const Icon(Icons.add),
                label: const Text('Cadastrar Aluno'),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Alunos cadastrados',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: alunos.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar alunos.'),
                    );
                  }

                  final documentos = snapshot.data?.docs ?? [];

                  if (documentos.isEmpty) {
                    return const Center(
                      child: Text('Nenhum aluno cadastrado.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: documentos.length,
                    itemBuilder: (context, index) {
                      final documento = documentos[index];
                      final dados =
                          documento.data() as Map<String, dynamic>;

                      final nome = dados['nome'] ?? '';
                      final idade = dados['idade'] ?? '';
                      final curso = dados['curso'] ?? '';

                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(nome.toString()),
                          subtitle: Text(
                            '$idade anos\n$curso',
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  editarAluno(
                                    documento.id,
                                    nome.toString(),
                                    idade.toString(),
                                    curso.toString(),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  excluirAluno(documento.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
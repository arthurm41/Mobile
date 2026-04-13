import 'package:flutter/material.dart';
import 'database/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> lista = [];

  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();

  int? editingId;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future carregarDados() async {
    try {
      final data = await DatabaseHelper.instance.getAll();
      setState(() {
        lista = data;
      });
    } catch (e) {
      setState(() {
        lista = [];
      });
    }
  }

  Future salvar() async {
    try {
      if (editingId == null) {
        await DatabaseHelper.instance.insert({
          'titulo': tituloController.text,
          'descricao': descricaoController.text,
          'data': DateTime.now().toString()
        });
      } else {
        await DatabaseHelper.instance.update({
          'id': editingId,
          'titulo': tituloController.text,
          'descricao': descricaoController.text,
          'data': DateTime.now().toString()
        });
        editingId = null;
      }

      tituloController.clear();
      descricaoController.clear();
      carregarDados();
    } catch (e) {
      print("Erro: $e");
    }
  }

  void editar(Map<String, dynamic> item) {
    setState(() {
      editingId = item['id'];
      tituloController.text = item['titulo'];
      descricaoController.text = item['descricao'];
    });
  }

  Future excluir(int id) async {

    
    try {
      await DatabaseHelper.instance.delete(id);
      carregarDados();
    } catch (e) {
      print("Erro ao excluir: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro Inteligente')),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),

            TextField(
              controller: descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: salvar,
              child: Text(editingId == null ? 'Salvar' : 'Atualizar'),
            ),

            SizedBox(height: 20),

            Expanded(
              child: lista.isEmpty
                  ? Center(child: Text("Nenhum item cadastrado"))
                  : ListView.builder(
                      itemCount: lista.length,
                      itemBuilder: (context, index) {
                        final item = lista[index];

                        return Card(
                          child: ListTile(
                            title: Text(item['titulo']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['descricao']),
                                Text(
                                  item['data'],
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                            onTap: () => editar(item),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => excluir(item['id']),
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
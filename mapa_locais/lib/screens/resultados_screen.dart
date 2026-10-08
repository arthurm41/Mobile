import 'package:flutter/material.dart';
import 'package:mapa_locais/dialogs/confirm_delete_dialog.dart';
import 'package:mapa_locais/models/local.dart';
import 'package:mapa_locais/screens/detalhes_screen.dart';
import 'package:mapa_locais/services/local_service.dart';
import 'package:mapa_locais/widgets/local_card.dart';
import 'package:mapa_locais/widgets/local_form_dialog.dart';

class ResultadosScreen extends StatefulWidget {
  final String cidadeInicial;
  final String pesquisaInicial;

  const ResultadosScreen({
    super.key,
    required this.cidadeInicial,
    required this.pesquisaInicial,
  });

  @override
  State<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen> {
  final LocalService _service = LocalService();
  final TextEditingController _pesquisaController = TextEditingController();

  String _cidadeSelecionada = 'Todas';
  String _categoriaSelecionada = 'Todos';

  final List<String> _cidades = ['Todas', 'São Paulo', 'Campinas', 'Jundiaí'];
  final List<String> _categorias = [
    'Todos',
    'Academia',
    'Saúde',
    'Restaurante',
    'Loja',
    'Serviço',
  ];

  @override
  void initState() {
    super.initState();
    _cidadeSelecionada = widget.cidadeInicial;
    _pesquisaController.text = widget.pesquisaInicial;
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  Future<void> _abrirFormulario({Local? local}) async {
    final cidadePadrao =
        _cidadeSelecionada == 'Todas' ? 'São Paulo' : _cidadeSelecionada;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => LocalFormDialog(
        local: local,
        cidadeInicial: cidadePadrao,
      ),
    );
  }

  Future<void> _confirmarExclusao(Local local) async {
    final confirmou = await confirmarExclusao(context, local.nome);
    if (!confirmou || !mounted) {
      return;
    }

    try {
      await _service.excluir(local.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${local.nome} excluído com sucesso.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
        backgroundColor: const Color(0xFF0F4C81),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Local>>(
        stream: _service.listarLocais(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar os locais: ${snapshot.error}'),
            );
          }

          final locais = snapshot.data ?? [];
          final listaFiltrada = filtrarLocais(
            locais,
            _pesquisaController.text,
            _cidadeSelecionada,
            _categoriaSelecionada,
          );

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  controller: _pesquisaController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Pesquisar...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _cidadeSelecionada,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        items: _cidades
                            .map(
                              (cidade) => DropdownMenuItem(
                                value: cidade,
                                child: Text(cidade),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _cidadeSelecionada = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _categoriaSelecionada,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        items: _categorias
                            .map(
                              (categoria) => DropdownMenuItem(
                                value: categoria,
                                child: Text(categoria),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _categoriaSelecionada = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: listaFiltrada.isEmpty
                    ? const Center(
                        child: Text('Nenhum local encontrado para os filtros atuais.'),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: listaFiltrada.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final local = listaFiltrada[index];
                          return LocalCard(
                            local: local,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetalhesScreen(local: local),
                                ),
                              );
                            },
                            onEdit: () => _abrirFormulario(local: local),
                            onDelete: () => _confirmarExclusao(local),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Cadastrar'),
      ),
    );
  }
}

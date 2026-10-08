import 'package:flutter/material.dart';
import 'package:mapa_locais/models/local.dart';
import 'package:mapa_locais/services/local_service.dart';

class LocalFormDialog extends StatefulWidget {
  final Local? local;
  final String cidadeInicial;

  const LocalFormDialog({
    super.key,
    this.local,
    required this.cidadeInicial,
  });

  @override
  State<LocalFormDialog> createState() => _LocalFormDialogState();
}

class _LocalFormDialogState extends State<LocalFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _service = LocalService();
  final _nomeController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _avaliacaoController = TextEditingController();
  final _distanciaController = TextEditingController();
  final _horarioController = TextEditingController();
  final _descricaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.local != null) {
      final local = widget.local!;
      _nomeController.text = local.nome;
      _categoriaController.text = local.categoria;
      _cidadeController.text = local.cidade;
      _avaliacaoController.text = local.avaliacao.toString();
      _distanciaController.text = local.distancia.toString();
      _horarioController.text = local.horario;
      _descricaoController.text = local.descricao;
    } else {
      _cidadeController.text = widget.cidadeInicial;
      _categoriaController.text = 'Academia';
      _avaliacaoController.text = '4.5';
      _distanciaController.text = '1.0';
      _horarioController.text = '08:00 - 18:00';
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _categoriaController.dispose();
    _cidadeController.dispose();
    _avaliacaoController.dispose();
    _distanciaController.dispose();
    _horarioController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final local = Local(
      id: widget.local?.id ?? '',
      nome: _nomeController.text.trim(),
      categoria: _categoriaController.text.trim(),
      cidade: _cidadeController.text.trim(),
      avaliacao: double.tryParse(_avaliacaoController.text) ?? 0.0,
      distancia: double.tryParse(_distanciaController.text) ?? 0.0,
      horario: _horarioController.text.trim(),
      descricao: _descricaoController.text.trim(),
      favorito: widget.local?.favorito ?? false,
    );

    try {
      if (widget.local == null) {
        await _service.adicionar(local);
      } else {
        await _service.atualizar(local);
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.local == null
                  ? 'Local cadastrado com sucesso.'
                  : 'Local atualizado com sucesso.',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar local: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.local == null ? 'Novo local' : 'Editar local',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _nomeController,
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Informe o nome' : null,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _categoriaController,
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Informe a categoria' : null,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _cidadeController,
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Informe a cidade' : null,
                  decoration: const InputDecoration(labelText: 'Cidade'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _avaliacaoController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Avaliação'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _distanciaController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Distância (km)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _horarioController,
                  decoration: const InputDecoration(labelText: 'Horário'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descricaoController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _salvar,
                        child: Text(widget.local == null ? 'Salvar' : 'Atualizar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

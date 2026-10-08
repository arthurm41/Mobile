import 'package:flutter/material.dart';
import 'package:mapa_locais/models/local.dart';
import 'package:mapa_locais/services/local_service.dart';

class DetalhesScreen extends StatefulWidget {
  final Local local;

  const DetalhesScreen({super.key, required this.local});

  @override
  State<DetalhesScreen> createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  final LocalService _service = LocalService();
  late bool _favorito;

  @override
  void initState() {
    super.initState();
    _favorito = widget.local.favorito;
  }

  Future<void> _toggleFavorito() async {
    final novoValor = !_favorito;
    try {
      await _service.alterarFavorito(widget.local.id, novoValor);
      setState(() => _favorito = novoValor);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              novoValor ? 'Local adicionado aos favoritos.' : 'Local removido dos favoritos.',
            ),
            backgroundColor: novoValor ? Colors.orange : Colors.grey,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar favorito: $e'),
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
        title: const Text('Detalhes do local'),
        backgroundColor: const Color(0xFF0F4C81),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_favorito ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorito,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F4C81), Color(0xFF4A90E2)],
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.location_on,
                size: 72,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.local.nome,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(widget.local.categoria),
                  backgroundColor: Colors.blue.shade100,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _InfoChip(icon: Icons.star, label: widget.local.avaliacao.toStringAsFixed(1)),
                _InfoChip(icon: Icons.location_city, label: widget.local.cidade),
                _InfoChip(icon: Icons.route, label: '${widget.local.distancia.toStringAsFixed(1)} km'),
                _InfoChip(icon: Icons.access_time, label: widget.local.horario),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Descrição',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              widget.local.descricao,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Voltar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mapa em desenvolvimento.')),
                      );
                    },
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('Ver no mapa'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.blue.shade700),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

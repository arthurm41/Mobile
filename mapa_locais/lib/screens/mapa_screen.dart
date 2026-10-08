import 'package:flutter/material.dart';
import 'package:mapa_locais/models/local.dart';
import 'package:mapa_locais/screens/resultados_screen.dart';
import 'package:mapa_locais/services/local_service.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final LocalService _service = LocalService();
  final TextEditingController _pesquisaController = TextEditingController();
  String _cidadeSelecionada = 'São Paulo';

  final List<String> _cidades = ['São Paulo', 'Campinas', 'Jundiaí'];
  final List<Offset> _marcadores = [
    const Offset(0.18, 0.28),
    const Offset(0.47, 0.22),
    const Offset(0.65, 0.44),
    const Offset(0.36, 0.62),
    const Offset(0.78, 0.68),
  ];

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  void _abrirResultados() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultadosScreen(
          cidadeInicial: _cidadeSelecionada,
          pesquisaInicial: _pesquisaController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Local>>(
      stream: _service.listarLocais(),
      builder: (context, snapshot) {
        final locais = snapshot.data ?? [];
        final locaisExibidos = locais
            .where((local) =>
                _cidadeSelecionada == 'Todos' || local.cidade == _cidadeSelecionada)
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mapa de locais'),
            centerTitle: false,
            backgroundColor: const Color(0xFF0F4C81),
            foregroundColor: Colors.white,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _pesquisaController,
                            decoration: InputDecoration(
                              hintText: 'Pesquisar por nome ou categoria',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _cidadeSelecionada,
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      height: 260,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFFDDEEFF),
                                        Color(0xFFD7F5D7),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 28,
                                  top: 22,
                                  child: Container(
                                    width: constraints.maxWidth * 0.74,
                                    height: 1,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                                Positioned(
                                  left: 42,
                                  top: 110,
                                  child: Container(
                                    width: constraints.maxWidth * 0.78,
                                    height: 1,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                                Positioned(
                                  left: 70,
                                  top: 70,
                                  child: Container(
                                    width: 1,
                                    height: constraints.maxHeight * 0.7,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                                Positioned(
                                  left: 220,
                                  top: 120,
                                  child: Container(
                                    width: 1,
                                    height: constraints.maxHeight * 0.55,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                                ...List.generate(
                                  locaisExibidos.length > 5
                                      ? 5
                                      : locaisExibidos.length,
                                  (index) {
                                    final local = locaisExibidos[index];
                                    final offset = _marcadores[index % _marcadores.length];
                                    return Positioned(
                                      left: constraints.maxWidth * offset.dx,
                                      top: constraints.maxHeight * offset.dy,
                                      child: GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ResultadosScreen(
                                              cidadeInicial: _cidadeSelecionada,
                                              pesquisaInicial: local.nome,
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade500,
                                            borderRadius: BorderRadius.circular(18),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: Text(
                                            local.nome.substring(0, 1).toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _abrirResultados,
                        icon: const Icon(Icons.list_alt_outlined),
                        label: const Text('Abrir resultados'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Locais em $_cidadeSelecionada',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        itemCount: locaisExibidos.length > 3 ? 3 : locaisExibidos.length,
                        itemBuilder: (context, index) {
                          final local = locaisExibidos[index];
                          return Card(
                            child: ListTile(
                              title: Text(local.nome),
                              subtitle: Text('${local.categoria} • ${local.cidade}'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ResultadosScreen(
                                      cidadeInicial: _cidadeSelecionada,
                                      pesquisaInicial: local.nome,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

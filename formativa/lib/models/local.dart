class Local {
  final String id;
  final String nome;
  final String categoria;
  final String cidade;
  final double avaliacao;
  final double distancia;
  final String horario;
  final String descricao;
  final bool favorito;

  const Local({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.cidade,
    required this.avaliacao,
    required this.distancia,
    required this.horario,
    required this.descricao,
    required this.favorito,
  });

  factory Local.fromMap(String id, Map<String, dynamic> data) {
    return Local(
      id: id,
      nome: data['nome']?.toString() ?? '',
      categoria: data['categoria']?.toString() ?? '',
      cidade: data['cidade']?.toString() ?? '',
      avaliacao: (data['avaliacao'] is num)
          ? (data['avaliacao'] as num).toDouble()
          : 0.0,
      distancia: (data['distancia'] is num)
          ? (data['distancia'] as num).toDouble()
          : 0.0,
      horario: data['horario']?.toString() ?? '',
      descricao: data['descricao']?.toString() ?? '',
      favorito: data['favorito'] == true,
    );
  }

  Local copyWith({
    String? id,
    String? nome,
    String? categoria,
    String? cidade,
    double? avaliacao,
    double? distancia,
    String? horario,
    String? descricao,
    bool? favorito,
  }) {
    return Local(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      categoria: categoria ?? this.categoria,
      cidade: cidade ?? this.cidade,
      avaliacao: avaliacao ?? this.avaliacao,
      distancia: distancia ?? this.distancia,
      horario: horario ?? this.horario,
      descricao: descricao ?? this.descricao,
      favorito: favorito ?? this.favorito,
    );
  }

  Map<String, dynamic> toMap() => {
    'nome': nome,
    'categoria': categoria,
    'cidade': cidade,
    'avaliacao': avaliacao,
    'distancia': distancia,
    'horario': horario,
    'descricao': descricao,
    'favorito': favorito,
  };
}

List<Local> filtrarLocais(
  List<Local> locais,
  String texto,
  String cidade,
  String categoria,
) {
  final termo = texto.trim().toLowerCase();

  return locais.where((local) {
    final correspondeCidade = cidade == 'Todas' || local.cidade == cidade;
    final correspondeCategoria =
        categoria == 'Todos' || local.categoria == categoria;
    final correspondeTexto =
        termo.isEmpty ||
        local.nome.toLowerCase().contains(termo) ||
        local.categoria.toLowerCase().contains(termo);

    return correspondeCidade && correspondeCategoria && correspondeTexto;
  }).toList();
}

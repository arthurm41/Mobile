import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_locais/models/local.dart';

void main() {
  group('Local filtering', () {
    final locais = [
      Local(
        id: '1',
        nome: 'Academia Fitness',
        categoria: 'Academia',
        cidade: 'São Paulo',
        avaliacao: 4.8,
        distancia: 1.2,
        horario: '06:00 - 22:00',
        descricao: 'Academia com piscina.',
        favorito: false,
      ),
      Local(
        id: '2',
        nome: 'Clínica Vida',
        categoria: 'Saúde',
        cidade: 'Campinas',
        avaliacao: 4.5,
        distancia: 3.5,
        horario: '08:00 - 18:00',
        descricao: 'Atendimento médico.',
        favorito: true,
      ),
    ];

    test('filtra por texto, cidade e categoria', () {
      final resultado = filtrarLocais(
        locais,
        'Academia',
        'São Paulo',
        'Academia',
      );

      expect(resultado.length, 1);
      expect(resultado.first.nome, 'Academia Fitness');
    });

    test('retorna todos quando filtros estão em valores padrão', () {
      final resultado = filtrarLocais(
        locais,
        '',
        'Todas',
        'Todos',
      );

      expect(resultado.length, 2);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Teste de carregamento da tela', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: AppBanco(),
    ));

    // Verifica se o título aparece
    expect(find.text('Banco SQLite Flutter'), findsOneWidget);

    // Verifica se o campo de texto existe
    expect(find.byType(TextField), findsOneWidget);

    // Verifica se o botão existe
    expect(find.text('Salvar'), findsOneWidget);
  });
}
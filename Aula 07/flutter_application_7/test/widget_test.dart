import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_7/main.dart';

void main() {

  // ================= TESTE 1 =================
  testWidgets('Teste da lista de contatos', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ListaContatos(),
      ),
    );

    // Verifica se os contatos aparecem na tela
    expect(find.text('Arthur'), findsOneWidget);
    expect(find.text('Maria'), findsOneWidget);
    expect(find.text('João'), findsOneWidget);
  });

  // ================= TESTE 2 =================
  testWidgets('Teste de navegação para detalhes', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ListaContatos(),
      ),
    );

    // Clica no contato Arthur
    await tester.tap(find.text('Arthur'));
    await tester.pumpAndSettle();

    // Verifica se foi para a tela de detalhes
    expect(find.text('Arthur'), findsWidgets);
    expect(find.text('1199999-1111'), findsOneWidget);
  });

  // ================= TESTE 3 =================
  testWidgets('Teste do botão voltar', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ListaContatos(),
      ),
    );

    // Entra no contato
    await tester.tap(find.text('Arthur'));
    await tester.pumpAndSettle();

    // Clica no botão voltar
    await tester.tap(find.text('Voltar'));
    await tester.pumpAndSettle();

    // Verifica se voltou para lista
    expect(find.text('Lista de Contatos'), findsOneWidget);
  });

}
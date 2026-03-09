import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_6/main.dart';

void main() {
  testWidgets('Teste do app de humor', (WidgetTester tester) async {

    // Carrega o aplicativo
    await tester.pumpWidget(HumorApp());

    // Verifica se começa com humor Feliz
    expect(find.text('😀 Feliz'), findsOneWidget);

    // Clica no botão de mudar humor
    await tester.tap(find.byIcon(Icons.mood));
    await tester.pump();

    // Verifica se mudou para Neutro
    expect(find.text('😐 Neutro'), findsOneWidget);

    // Clica novamente
    await tester.tap(find.byIcon(Icons.mood));
    await tester.pump();

    // Verifica se mudou para Bravo
    expect(find.text('😡 Bravo'), findsOneWidget);
  });
}
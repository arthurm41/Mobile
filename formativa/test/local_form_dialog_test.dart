import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_locais/widgets/local_form_dialog.dart';

void main() {
  Future<void> openForm(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: LocalFormDialog(cidadeInicial: 'São Paulo')),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('requires a valid rating between zero and five', (
    WidgetTester tester,
  ) async {
    await openForm(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'Local teste');
    await tester.enterText(find.byType(TextFormField).at(3), '5,1');
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Salvar'));
    await tester.tap(find.widgetWithText(FilledButton, 'Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('Use um valor entre 0 e 5'), findsOneWidget);
  });

  testWidgets('rejects a negative distance', (WidgetTester tester) async {
    await openForm(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'Local teste');
    await tester.enterText(find.byType(TextFormField).at(4), '-1');
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Salvar'));
    await tester.tap(find.widgetWithText(FilledButton, 'Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('A distância não pode ser negativa'), findsOneWidget);
  });
}

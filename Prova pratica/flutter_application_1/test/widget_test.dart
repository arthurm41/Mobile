import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Tela principal carrega', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Cadastro Inteligente'), findsOneWidget);
    expect(find.text('Título'), findsOneWidget);
    expect(find.text('Descrição'), findsOneWidget);
  });
}
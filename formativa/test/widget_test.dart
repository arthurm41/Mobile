import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_locais/app.dart';

void main() {
  testWidgets('shows Firestore initialization errors instead of hiding them', (
    WidgetTester tester,
  ) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    await tester.pumpWidget(const LocalApp());
    await tester.pumpAndSettle();

    expect(find.text('Mapa de locais'), findsOneWidget);
    expect(find.textContaining('Erro ao carregar os locais'), findsOneWidget);
  });

  testWidgets('shows Firebase setup errors when initialization fails', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const LocalApp(firebaseInitializationError: 'Configuração inválida'),
    );

    expect(
      find.textContaining('Configure o projeto com `flutterfire configure`'),
      findsOneWidget,
    );
    expect(find.text('Configuração inválida'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_locais/app.dart';

void main() {
  testWidgets('app loads and shows main screen', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    await tester.pumpWidget(const LocalApp());

    expect(find.text('Mapa de locais'), findsOneWidget);
    expect(find.text('Abrir resultados'), findsOneWidget);
  });
}

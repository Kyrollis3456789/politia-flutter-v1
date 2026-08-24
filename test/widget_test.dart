import 'package:flutter_test/flutter_test.dart';
import 'package:politia/main.dart';

void main() {
  testWidgets('Politia app smoke test', (WidgetTester tester) async {
    // Build PolitiaApp and trigger a frame.
    await tester.pumpWidget(const PolitiaApp());
    await tester.pumpAndSettle();

    // Verify that the title Politia renders.
    expect(find.text('Politia'), findsWidgets);
  });
}

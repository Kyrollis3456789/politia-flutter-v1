import 'package:flutter_test/flutter_test.dart';
import 'package:politia/main.dart';

void main() {
  testWidgets('Politia app smoke test', (WidgetTester tester) async {
    // Build PolitiaApp and trigger initial frame
    await tester.pumpWidget(const PolitiaApp());
    await tester.pump();

    // Verify that the title Politia renders on Splash
    expect(find.text('Politia'), findsWidgets);

    // Fast-forward through the 4-second minimum splash gatekeeper timer and complete route navigation
    await tester.pump(const Duration(seconds: 5));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify that the screen renders Politia
    expect(find.text('Politia'), findsWidgets);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:politia/features/splash/splash_screen.dart';
import 'package:politia/main.dart';

void main() {
  testWidgets('Politia app smoke test', (WidgetTester tester) async {
    // Build PolitiaApp and trigger initial frame
    await tester.pumpWidget(const PolitiaApp());
    await tester.pump();

    // Verify splash elements
    expect(find.text('At Church - Coptic Orthodox'), findsOneWidget);

    // Tap splash screen to trigger exit transition
    await tester.tap(find.byType(SplashScreen));
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 100));

    // Drain pending initialization timer
    await tester.pump(const Duration(seconds: 5));
  });
}

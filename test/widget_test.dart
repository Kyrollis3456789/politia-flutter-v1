import 'package:flutter_test/flutter_test.dart';
import 'package:politia/features/splash/splash_screen.dart';
import 'package:politia/main.dart';

void main() {
  testWidgets('Politia app smoke test', (WidgetTester tester) async {
    // Build PolitiaApp and trigger initial frame
    await tester.pumpWidget(const PolitiaApp());
    await tester.pump();

    // Verify persistent splash elements
    expect(find.text('POLITIA\nCOPTIC ORTHODOX'), findsOneWidget);
    expect(find.byType(SplashScreen), findsOneWidget);

    // Drain background initialization timer
    await tester.pump(const Duration(seconds: 5));
  });
}

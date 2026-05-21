import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:snapkobi/core/constants/app_strings.dart';
import 'package:snapkobi/main.dart' as app;
import 'package:snapkobi/shared/widgets/layout/main_scaffold.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('auth flow smoke', (tester) async {
    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 6));

    final onboardingLogin = find.text(AppStrings.onboardingLogin);
    final onHome = find.byType(MainScaffold);

    if (onboardingLogin.evaluate().isNotEmpty) {
      await tester.tap(onboardingLogin);
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.loginAppBarTitle), findsOneWidget);
      return;
    }

    expect(onHome, findsOneWidget);
  });
}

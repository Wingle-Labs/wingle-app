import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_height_page.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_height_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('BasicProfileHeightPage는 화면을 벗어났다가 다시 들어와도 입력값을 유지한다', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    Future<void> pumpPage() async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: EasyLocalization(
            supportedLocales: AppLocalization.supportedLocales,
            path: AppLocalization.path,
            fallbackLocale: AppLocalization.fallbackLocale,
            startLocale: AppLocalization.fallbackLocale,
            saveLocale: false,
            child: MaterialApp(
              theme: Themes.light,
              home: const BasicProfileHeightPage(),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    container.read(basicProfileHeightProvider.notifier).update('175');

    await pumpPage();
    expect(container.read(basicProfileHeightProvider), '175');

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    await pumpPage();

    expect(
      tester.widget<TextField>(find.byType(TextField).at(0)).controller?.text,
      '1',
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).controller?.text,
      '7',
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(2)).controller?.text,
      '5',
    );
  });
}

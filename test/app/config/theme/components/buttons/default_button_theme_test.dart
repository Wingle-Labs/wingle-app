import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wingle/app/config/theme/color/app_colors.dart';
import 'package:wingle/app/config/theme/components/buttons/default_outlined_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_text_button.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  Future<void> pumpApp(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: AppLocalization.supportedLocales,
        path: AppLocalization.path,
        fallbackLocale: AppLocalization.fallbackLocale,
        startLocale: AppLocalization.fallbackLocale,
        saveLocale: false,
        child: MaterialApp(
          theme: Themes.light,
          home: Center(child: child),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('DefaultOutlinedButton theme별 semantic token을 사용한다', (
    tester,
  ) async {
    final colors = Themes.light.extension<AppColors>()!.scheme;

    for (final theme in DefaultOutlinedButtonTheme.values) {
      await pumpApp(
        tester,
        DefaultOutlinedButton(label: '텍스트', theme: theme, onPressed: () {}),
      );

      final material = tester.widget<Material>(find.byType(Material).last);
      final shape = material.shape! as RoundedRectangleBorder;
      final expectedColor = switch (theme) {
        DefaultOutlinedButtonTheme.primary =>
          colors.componentPrimaryOutlinedButtonEnabled,
        DefaultOutlinedButtonTheme.secondary =>
          colors.componentSecondaryOutlinedButtonEnabled,
        DefaultOutlinedButtonTheme.assistive =>
          colors.componentAssistiveOutlinedButtonEnabled,
      };

      expect(material.color, colors.backgroundNormal);
      expect(shape.side.color, expectedColor);
    }
  });

  testWidgets('DefaultTextButton theme별 semantic token을 사용한다', (tester) async {
    final colors = Themes.light.extension<AppColors>()!.scheme;

    for (final theme in DefaultTextButtonTheme.values) {
      await pumpApp(
        tester,
        DefaultTextButton(label: '텍스트', theme: theme, onPressed: () {}),
      );

      final material = tester.widget<Material>(find.byType(Material).last);
      final text = tester.widget<Text>(find.text('텍스트'));
      final expectedColor = switch (theme) {
        DefaultTextButtonTheme.primary =>
          colors.componentPrimaryTextButtonEnabled,
        DefaultTextButtonTheme.assistive =>
          colors.componentAssistiveTextButtonEnabled,
      };

      expect(material.color, Colors.transparent);
      expect(text.style?.color, expectedColor);
    }
  });
}

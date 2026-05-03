import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wingle/app/config/theme/color/app_colors.dart';
import 'package:wingle/app/config/theme/components/badges/default_badge.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  Future<void> pumpBadge(
    WidgetTester tester, {
    DefaultBadgeSize size = DefaultBadgeSize.md,
    DefaultBadgeType type = DefaultBadgeType.primary,
    String text = '뱃지 내용',
  }) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: AppLocalization.supportedLocales,
        path: AppLocalization.path,
        fallbackLocale: AppLocalization.fallbackLocale,
        startLocale: AppLocalization.fallbackLocale,
        saveLocale: false,
        child: MaterialApp(
          theme: Themes.light,
          home: Scaffold(
            body: Center(
              child: DefaultBadge(text: text, size: size, type: type),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('DefaultBadge는 type별 semantic token을 사용한다', (tester) async {
    final colors = Themes.light.extension<AppColors>()!.scheme;

    final expected = {
      DefaultBadgeType.primary: colors.componentBadgePrimaryBackground,
      DefaultBadgeType.secondary: colors.componentBadgeSecondaryBackground,
      DefaultBadgeType.tertiary: colors.componentBadgeTertiaryBackground,
      DefaultBadgeType.gray: colors.componentBadgeGrayBackground,
    };

    for (final entry in expected.entries) {
      await pumpBadge(tester, type: entry.key);

      final decoratedBox = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(DefaultBadge),
          matching: find.byType(DecoratedBox),
        ),
      );

      final decoration = decoratedBox.decoration as BoxDecoration;
      expect(decoration.color, entry.value);
    }
  });

  testWidgets('DefaultBadge는 label을 렌더링한다', (tester) async {
    await pumpBadge(tester, text: '할인');

    expect(find.text('할인'), findsOneWidget);
  });
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wingle/app/config/theme/color/app_colors.dart';
import 'package:wingle/app/config/theme/components/buttons/default_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  Future<void> pumpButton(
    WidgetTester tester, {
    required DefaultButtonVariant variant,
    DefaultButtonStatus status = DefaultButtonStatus.enabled,
    Widget? leadingWidget,
    Widget? trailingWidget,
    VoidCallback? onPressed,
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
          home: Center(
            child: DefaultFilledButton(
              label: '텍스트',
              variant: variant,
              status: status,
              leadingWidget: leadingWidget,
              trailingWidget: trailingWidget,
              onPressed: onPressed ?? () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('DefaultFilledButton variant별 높이를 적용한다', (tester) async {
    const expectedHeights = {
      DefaultButtonVariant.fullWidth: 48.0,
      DefaultButtonVariant.xl: 54.0,
      DefaultButtonVariant.lg: 48.0,
      DefaultButtonVariant.md: 40.0,
      DefaultButtonVariant.sm: 36.0,
      DefaultButtonVariant.xs: 32.0,
    };

    for (final entry in expectedHeights.entries) {
      await pumpButton(tester, variant: entry.key);

      expect(tester.getSize(find.byType(Material).last).height, entry.value);
    }
  });

  testWidgets('DefaultFilledButton은 한쪽 아이콘만 있어도 텍스트를 중앙에 둔다', (tester) async {
    await pumpButton(
      tester,
      variant: DefaultButtonVariant.lg,
      leadingWidget: const SizedBox.square(dimension: 16),
    );

    final buttonCenter = tester.getCenter(find.byType(Material).last);
    final textCenter = tester.getCenter(find.text('텍스트'));

    expect((buttonCenter.dx - textCenter.dx).abs(), lessThan(0.1));
  });

  testWidgets('DefaultFilledButton loading 상태는 인디케이터를 표시하고 탭을 막는다', (
    tester,
  ) async {
    var tapCount = 0;

    await pumpButton(
      tester,
      variant: DefaultButtonVariant.lg,
      status: DefaultButtonStatus.loading,
      onPressed: () => tapCount += 1,
    );

    expect(find.byType(AnimationProgressIndicator), findsOneWidget);

    await tester.tap(find.byType(Material).last);
    await tester.pump();

    expect(tapCount, 0);
  });

  testWidgets('DefaultFilledButton theme별 semantic token을 사용한다', (
    tester,
  ) async {
    final colors = Themes.light.extension<AppColors>()!.scheme;

    for (final theme in DefaultFilledButtonTheme.values) {
      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: AppLocalization.supportedLocales,
          path: AppLocalization.path,
          fallbackLocale: AppLocalization.fallbackLocale,
          startLocale: AppLocalization.fallbackLocale,
          saveLocale: false,
          child: MaterialApp(
            theme: Themes.light,
            home: Center(
              child: DefaultFilledButton(
                label: '텍스트',
                theme: theme,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final material = tester.widget<Material>(find.byType(Material).last);
      final expectedColor = switch (theme) {
        DefaultFilledButtonTheme.primary =>
          colors.componentPrimaryFilledButtonEnabled,
        DefaultFilledButtonTheme.secondary =>
          colors.componentSecondaryFilledButtonEnabled,
        DefaultFilledButtonTheme.tertiary =>
          colors.componentTertiaryFilledButtonEnabled,
      };

      expect(material.color, expectedColor);
    }
  });
}

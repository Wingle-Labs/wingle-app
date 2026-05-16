import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wingle/app/config/theme/color/app_colors.dart';
import 'package:wingle/app/config/theme/components/chips/default_chip_button.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  Future<void> pumpChipButton(
    WidgetTester tester, {
    DefaultChipButtonTheme theme = DefaultChipButtonTheme.primary,
    DefaultChipButtonState state = DefaultChipButtonState.unselected,
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
          home: Scaffold(
            body: Center(
              child: DefaultChipButton(
                label: '임시 텍스트',
                theme: theme,
                state: state,
                onPressed: onPressed,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('DefaultChipButton은 primary selected semantic token을 사용한다', (
    tester,
  ) async {
    final colors = Themes.light.extension<AppColors>()!.scheme;

    await pumpChipButton(
      tester,
      theme: DefaultChipButtonTheme.primary,
      state: DefaultChipButtonState.selected,
    );

    final decoratedBox = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(DefaultChipButton),
        matching: find.byType(DecoratedBox),
      ),
    );

    final decoration = decoratedBox.decoration as BoxDecoration;
    expect(
      decoration.color,
      colors.componentChipButtonPrimarySelectedBackground,
    );
  });

  testWidgets('DefaultChipButton은 secondary selected semantic token을 사용한다', (
    tester,
  ) async {
    final colors = Themes.light.extension<AppColors>()!.scheme;

    await pumpChipButton(
      tester,
      theme: DefaultChipButtonTheme.secondary,
      state: DefaultChipButtonState.selected,
    );

    final decoratedBox = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(DefaultChipButton),
        matching: find.byType(DecoratedBox),
      ),
    );

    final decoration = decoratedBox.decoration as BoxDecoration;
    expect(
      decoration.color,
      colors.componentChipButtonSecondarySelectedBackground,
    );
  });

  testWidgets('DefaultChipButton disabled 상태는 탭을 막는다', (tester) async {
    var tapCount = 0;

    await pumpChipButton(
      tester,
      state: DefaultChipButtonState.disabled,
      onPressed: () => tapCount += 1,
    );

    await tester.tap(find.byType(DefaultChipButton));
    await tester.pump();

    expect(tapCount, 0);
  });

  testWidgets('DefaultChipButton 폭은 내부 텍스트와 패딩에 따라 결정된다', (tester) async {
    await pumpChipButton(tester);
    final shortWidth = tester.getSize(find.byType(DefaultChipButton)).width;

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: AppLocalization.supportedLocales,
        path: AppLocalization.path,
        fallbackLocale: AppLocalization.fallbackLocale,
        startLocale: AppLocalization.fallbackLocale,
        saveLocale: false,
        child: MaterialApp(
          theme: Themes.light,
          home: const Scaffold(
            body: Center(
              child: DefaultChipButton(
                label: '임시 텍스트가 더 길어집니다',
                theme: DefaultChipButtonTheme.primary,
                state: DefaultChipButtonState.unselected,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final longWidth = tester.getSize(find.byType(DefaultChipButton)).width;

    expect(longWidth, greaterThan(shortWidth));
  });
}

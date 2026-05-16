import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wingle/app/config/theme/components/buttons/default_button.dart';
import 'package:wingle/app/config/theme/components/icons/default_icon.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/weight.dart';
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
            child: DefaultButton(
              label: '텍스트',
              variant: variant,
              status: status,
              visualSpec: const DefaultButtonVisualSpec(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                pressedOverlayColor: Colors.white24,
              ),
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

  Finder findButtonSurface() {
    return find.descendant(
      of: find.byType(DefaultButton),
      matching: find.byType(InkWell),
    );
  }

  testWidgets('DefaultButton variant별 높이를 적용한다', (tester) async {
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
      expect(tester.getSize(findButtonSurface()).height, entry.value);
    }
  });

  testWidgets('DefaultButton은 양쪽 icon slot 유무와 무관하게 텍스트를 중앙에 둔다', (
    tester,
  ) async {
    await pumpButton(
      tester,
      variant: DefaultButtonVariant.lg,
      leadingWidget: const SizedBox.square(dimension: 16),
      trailingWidget: const SizedBox.square(dimension: 16),
    );

    final buttonCenter = tester.getCenter(findButtonSurface());
    final textCenter = tester.getCenter(find.text('텍스트'));

    expect((buttonCenter.dx - textCenter.dx).abs(), lessThan(0.1));
  });

  testWidgets('DefaultButton loading 상태는 인디케이터를 표시하고 탭을 막는다', (tester) async {
    var tapCount = 0;

    await pumpButton(
      tester,
      variant: DefaultButtonVariant.lg,
      status: DefaultButtonStatus.loading,
      onPressed: () => tapCount += 1,
    );

    expect(find.byType(AnimationProgressIndicator), findsOneWidget);

    await tester.tap(findButtonSurface());
    await tester.pump();

    expect(tapCount, 0);
  });

  testWidgets('DefaultButton disabled 상태는 탭을 막는다', (tester) async {
    var tapCount = 0;

    await pumpButton(
      tester,
      variant: DefaultButtonVariant.lg,
      status: DefaultButtonStatus.disabled,
      onPressed: () => tapCount += 1,
    );

    await tester.tap(findButtonSurface());
    await tester.pump();

    expect(tapCount, 0);
  });

  testWidgets('DefaultButton은 fullWidth가 아니면 내부 컨텐츠와 padding으로 너비가 결정된다', (
    tester,
  ) async {
    await pumpButton(tester, variant: DefaultButtonVariant.lg);
    final shortWidth = tester.getSize(findButtonSurface()).width;

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
            child: DefaultButton(
              label: '조금 더 긴 텍스트',
              variant: DefaultButtonVariant.lg,
              visualSpec: const DefaultButtonVisualSpec(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                pressedOverlayColor: Colors.white24,
              ),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final longWidth = tester.getSize(findButtonSurface()).width;

    expect(longWidth, greaterThan(shortWidth));
  });

  testWidgets('DefaultButton variant별 라벨 스타일과 아이콘 크기를 적용한다', (tester) async {
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
            child: DefaultButton(
              label: '텍스트',
              variant: DefaultButtonVariant.xs,
              visualSpec: const DefaultButtonVisualSpec(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                pressedOverlayColor: Colors.white24,
              ),
              leading: Icons.favorite,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final xsText = tester.widget<Text>(find.text('텍스트'));
    final xsIcon = tester.widget<DefaultIcon>(find.byType(DefaultIcon));

    expect(xsText.style?.fontSize, AppFontSize.caption);
    expect(xsText.style?.fontWeight, AppFontWeight.medium);
    expect(xsIcon.size, AppIconSize.xxs);

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
            child: DefaultButton(
              label: '텍스트',
              variant: DefaultButtonVariant.xl,
              visualSpec: const DefaultButtonVisualSpec(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white24,
                pressedOverlayColor: Colors.white24,
              ),
              leading: Icons.favorite,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final xlText = tester.widget<Text>(find.text('텍스트'));
    final xlIcon = tester.widget<DefaultIcon>(find.byType(DefaultIcon));

    expect(xlText.style?.fontSize, AppFontSize.subtitle);
    expect(xlText.style?.fontWeight, AppFontWeight.semiBold);
    expect(xlIcon.size, AppIconSize.md);
  });
}

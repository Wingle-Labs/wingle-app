import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_text_button.dart';
import 'package:wingle/app/config/theme/components/states/default_bottom_sheet.dart';
import 'package:wingle/app/config/theme/components/states/keyboard_avoiding_popup.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  Future<void> pumpBottomSheet(WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: AppLocalization.supportedLocales,
        path: AppLocalization.path,
        fallbackLocale: AppLocalization.fallbackLocale,
        startLocale: AppLocalization.fallbackLocale,
        saveLocale: false,
        child: MaterialApp(
          theme: Themes.light,
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      DefaultBottomSheet.show<void>(
                        context,
                        body: const Text('body'),
                        mainLabel: '계속하기',
                        subLabel: '로그아웃',
                        onMain: () {},
                        onSub: () {},
                      );
                    },
                    child: const Text('open'),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('DefaultBottomSheet 버튼은 padding 안쪽 가용 폭을 채운다', (tester) async {
    await pumpBottomSheet(tester);

    final mainButtonWidth = tester
        .getSize(find.byType(DefaultFilledButton))
        .width;
    final subButtonWidth = tester.getSize(find.byType(DefaultTextButton)).width;

    expect(mainButtonWidth, greaterThan(500));
    expect(subButtonWidth, mainButtonWidth);
  });

  testWidgets('DefaultBottomSheet는 키보드 inset을 하단 padding으로 반영한다', (
    tester,
  ) async {
    const keyboardInset = 320.0;
    tester.view.viewInsets = FakeViewPadding(
      bottom: keyboardInset * tester.view.devicePixelRatio,
    );
    addTearDown(tester.view.resetViewInsets);

    await pumpBottomSheet(tester);
    await tester.pump(const Duration(milliseconds: 200));

    final animatedPadding = tester.widget<AnimatedPadding>(
      find.descendant(
        of: find.byType(KeyboardAvoidingPopup),
        matching: find.byType(AnimatedPadding),
      ),
    );

    expect(
      animatedPadding.padding,
      const EdgeInsets.only(bottom: keyboardInset),
    );
  });
}

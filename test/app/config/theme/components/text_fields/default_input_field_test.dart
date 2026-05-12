import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_input_field.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_outlined_input_field.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  Future<void> pumpInputField(
    WidgetTester tester, {
    DefaultInputFieldState state = DefaultInputFieldState.defaultState,
    DefaultInputFieldType type = DefaultInputFieldType.inputSuffix,
    TextEditingController? controller,
    Widget? prefix,
    Widget? suffix,
    Widget? assistiveAction,
    String? errorText,
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
              child: DefaultOutlinedInputField(
                controller: controller ?? TextEditingController(),
                labelText: 'Label Text',
                hintText: 'Hint Text',
                assistiveText: 'Assistive text',
                state: state,
                type: type,
                prefix: prefix,
                suffix: suffix,
                assistiveAction: assistiveAction,
                errorText: errorText,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('DefaultOutlinedInputField는 라벨, 힌트, 보조 텍스트를 렌더링한다', (
    tester,
  ) async {
    await pumpInputField(tester);

    expect(find.text('Label Text'), findsOneWidget);
    expect(find.text('Hint Text'), findsOneWidget);
    expect(find.text('Assistive text'), findsOneWidget);
  });

  testWidgets('DefaultOutlinedInputField error 상태는 에러 텍스트를 노출한다', (
    tester,
  ) async {
    await pumpInputField(
      tester,
      state: DefaultInputFieldState.error,
      errorText: 'Error Text',
    );

    expect(find.text('Error Text'), findsOneWidget);
  });

  testWidgets(
    'DefaultOutlinedInputField는 prefix, suffix, assistive action 확장을 지원한다',
    (tester) async {
      await pumpInputField(
        tester,
        type: DefaultInputFieldType.inputPrefixSuffix,
        prefix: const SizedBox.square(dimension: 16),
        suffix: const SizedBox.square(dimension: 16),
      );

      expect(find.byType(SizedBox), findsWidgets);

      await pumpInputField(
        tester,
        type: DefaultInputFieldType.inputAssistiveAction,
        assistiveAction: const Text('Assistive Action'),
      );

      expect(find.text('Assistive Action'), findsOneWidget);
    },
  );
}

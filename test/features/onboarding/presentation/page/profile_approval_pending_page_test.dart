import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';
import 'package:wingle/features/onboarding/presentation/page/profile_approval_pending_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('프로필 승인 대기 화면은 안내 문구와 비활성 시작 버튼을 표시한다', (tester) async {
    _setMobileViewport(tester);

    await tester.pumpWidget(_testApp(const ProfileApprovalPendingPage()));
    await tester.pump();

    expect(
      _textEither('onboarding.approvalPending.title', '프로필 신청 완료'),
      findsOneWidget,
    );
    expect(
      _textEither(
        'onboarding.approvalPending.subtitle',
        '관리자가 승인 후 가입이 완료됩니다.',
      ),
      findsOneWidget,
    );
    expect(find.byType(Placeholder), findsOneWidget);

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNull);
  });
}

void _setMobileViewport(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(375, 812)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _testApp(Widget home) {
  return EasyLocalization(
    supportedLocales: AppLocalization.supportedLocales,
    path: AppLocalization.path,
    fallbackLocale: AppLocalization.fallbackLocale,
    startLocale: AppLocalization.fallbackLocale,
    saveLocale: false,
    child: MaterialApp(theme: Themes.light, home: home),
  );
}

Finder _textEither(String key, String translated) {
  return find.byWidgetPredicate((widget) {
    return widget is Text && (widget.data == key || widget.data == translated);
  });
}

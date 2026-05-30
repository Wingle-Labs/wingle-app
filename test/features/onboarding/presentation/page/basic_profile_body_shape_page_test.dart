import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/app/providers/current_user_gender_provider.dart';
import 'package:wingle/common/constants/localization_constants.dart';
import 'package:wingle/features/onboarding/domain/model/body_shape/body_shape_models.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_body_shape_page.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  test('BodyShapeCodebook는 성별에 따라 서로 다른 옵션을 반환한다', () {
    final codebook = BodyShapeCodebook.mock();

    expect(codebook.labelForGenderAndCode('male', 'BT_M_001'), '슬림');
    expect(codebook.labelForGenderAndCode('female', 'BT_F_003'), '볼륨');
    expect(codebook.labelForGenderAndCode('남', 'BT_M_003'), '탄탄');
    expect(codebook.labelForGenderAndCode('여', 'BT_F_004'), '체구 있음');
    expect(codebook.optionsForGender('female').map((option) => option.label), [
      '슬림',
      '보통',
      '볼륨',
      '체구 있음',
      '공개 안함',
    ]);
    expect(codebook.optionsForGender('male').map((option) => option.label), [
      '슬림',
      '보통',
      '탄탄',
      '체격 있음',
      '공개 안함',
    ]);
  });

  test('BodyShapeCodebook는 BODY_TYPE snapshot code를 옵션 code로 유지한다', () {
    final codebook = BodyShapeCodebook.fromCodebookEntries(const [
      CommonCodeDetail(
        code: 'BT_F_001',
        codeName: '슬림',
        parentCode: 'BT_FEMALE',
        displayOrder: 0,
      ),
      CommonCodeDetail(code: 'BT_MALE', codeName: '남성 체형', displayOrder: 0),
      CommonCodeDetail(
        code: 'BT_M_001',
        codeName: '슬림',
        parentCode: 'BT_MALE',
        displayOrder: 0,
      ),
      CommonCodeDetail(
        code: 'BT_F_003',
        codeName: '볼륨',
        parentCode: 'BT_FEMALE',
        displayOrder: 0,
      ),
    ]);

    expect(codebook.optionsForGender('male').map((option) => option.code), [
      'BT_M_001',
    ]);
    expect(codebook.optionsForGender('female').map((option) => option.code), [
      'BT_F_001',
      'BT_F_003',
    ]);
  });

  test('basicProfileProvider는 체형 선택과 초기화를 지원한다', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(basicProfileProvider.notifier);

    expect(container.read(basicProfileProvider).bodyShapeCode, isNull);

    notifier.selectBodyShape('BT_M_001');
    expect(container.read(basicProfileProvider).bodyShapeCode, 'BT_M_001');

    notifier.reset();
    expect(container.read(basicProfileProvider).bodyShapeCode, isNull);
  });

  testWidgets('BasicProfileBodyShapePage의 뒤로가기는 키 입력으로 이동한다', (tester) async {
    final container = ProviderContainer(
      overrides: [currentUserGenderProvider.overrideWithValue('male')],
    );
    addTearDown(container.dispose);
    final router = GoRouter(
      initialLocation: OnboardingRoutes.basicProfileBodyShape.fullPath,
      routes: [
        GoRoute(
          name: OnboardingRoutes.basicProfileBodyShape.name,
          path: OnboardingRoutes.basicProfileBodyShape.fullPath,
          builder: (context, state) => const BasicProfileBodyShapePage(),
        ),
        GoRoute(
          name: OnboardingRoutes.basicProfileHeight.name,
          path: OnboardingRoutes.basicProfileHeight.fullPath,
          builder: (context, state) => const Text('height-target'),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: EasyLocalization(
          supportedLocales: AppLocalization.supportedLocales,
          path: AppLocalization.path,
          fallbackLocale: AppLocalization.fallbackLocale,
          startLocale: AppLocalization.fallbackLocale,
          saveLocale: false,
          child: MaterialApp.router(theme: Themes.light, routerConfig: router),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('height-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.basicProfileHeight.fullPath,
    );
  });

  testWidgets('체형 선택이 완료되면 현재 단계 버튼을 활성화한다', (tester) async {
    final container = ProviderContainer(
      overrides: [currentUserGenderProvider.overrideWithValue('male')],
    );
    addTearDown(container.dispose);

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
            home: const BasicProfileBodyShapePage(),
          ),
        ),
      ),
    );
    await tester.pump();

    FloatingActionButton button() =>
        tester.widget<FloatingActionButton>(find.byType(FloatingActionButton));

    expect(button().onPressed, isNull);

    await tester.tap(find.text('슬림'));
    await tester.pump();

    expect(button().onPressed, isNotNull);
  });
}

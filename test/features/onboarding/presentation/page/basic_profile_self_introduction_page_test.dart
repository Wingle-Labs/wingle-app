import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';
import 'package:wingle/features/auth/domain/models/login_profile_details.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_self_introduction_page.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_details_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('자기소개 화면은 빈 입력에서 다음 버튼을 비활성화한다', (tester) async {
    _setMobileViewport(tester);

    await tester.pumpWidget(
      _testApp(home: const BasicProfileSelfIntroductionPage()),
    );
    await tester.pump();

    expect(
      _textEither(
        'onboarding.basicProfile.selfIntroduction.title',
        '내 첫 인상이 될 자기소개,\n솔직 담백한 글을 작성해주세요',
      ),
      findsOneWidget,
    );
    expect(
      _textEither('onboarding.basicProfile.selfIntroduction.label', '자기소개'),
      findsOneWidget,
    );
    expect(
      _textEither(
        'onboarding.basicProfile.selfIntroduction.quality.empty',
        '미입력',
      ),
      findsOneWidget,
    );
    expect(find.text('0/1000자'), findsOneWidget);

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('자기소개 입력 필드는 4줄로 시작하고 입력 줄 수에 따라 높이가 바뀐다', (tester) async {
    _setMobileViewport(tester);

    await tester.pumpWidget(
      _testApp(home: const BasicProfileSelfIntroductionPage()),
    );
    await tester.pump();

    final fieldFinder = find.byType(TextFormField);
    final field = tester.widget<EditableText>(find.byType(EditableText));
    expect(field.minLines, 4);
    expect(field.maxLines, isNull);
    expect(field.expands, isFalse);

    final initialHeight = tester.getSize(fieldFinder).height;

    await tester.enterText(
      fieldFinder,
      List.generate(10, (index) => '자기소개 ${index + 1}번째 줄').join('\n'),
    );
    await tester.pump();

    final expandedHeight = tester.getSize(fieldFinder).height;
    expect(expandedHeight, greaterThan(initialHeight));

    await tester.enterText(fieldFinder, '짧은 자기소개');
    await tester.pump();

    final collapsedHeight = tester.getSize(fieldFinder).height;
    expect(collapsedHeight, lessThan(expandedHeight));
    expect(collapsedHeight, closeTo(initialHeight, 0.1));
  });

  testWidgets('짧은 자기소개도 저장하고 상세 프로필 API 제출 후 심사를 요청한다', (tester) async {
    _setMobileViewport(tester);
    final router = _selfIntroductionRouter();
    addTearDown(router.dispose);
    final persistence = _MemoryProfileDetailsPersistence(
      const LoginProfileDetails(
        mbti: 'ENFP',
        mainStylePhotoKey: 'users/1/style/main.webp',
        mainFacePhotoKey: 'users/1/face/main.webp',
      ),
    );
    final repository = _RecordingProfileRepository();

    await tester.pumpWidget(
      _testRouterApp(router, persistence: persistence, repository: repository),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextFormField), '반가워요');
    await tester.pump();

    expect(
      _textEither(
        'onboarding.basicProfile.selfIntroduction.quality.short',
        '짧음',
      ),
      findsOneWidget,
    );
    expect(find.text('4/1000자'), findsOneWidget);

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNotNull);

    await tester.tap(find.byType(FloatingActionButton));
    await _pumpAsyncWork(tester);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();

    expect(repository.submittedMbti, 'ENFP');
    expect(repository.submittedSelfIntroduction, '반가워요');
    expect(repository.submittedMainStylePhotoKey, 'users/1/style/main.webp');
    expect(repository.submittedMainFacePhotoKey, 'users/1/face/main.webp');
    expect(repository.didRequestProfileApproval, isTrue);
    expect(persistence.profile?.selfIntroduction, '반가워요');
    expect(persistence.profileStatus, LoginProfileStatus.awaitingApproval);
    expect(find.text('approval-pending-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.approvalPending.fullPath,
    );
  });

  testWidgets('자기소개 화면의 앱바 뒤로가기는 얼굴 사진 화면으로 이동한다', (tester) async {
    _setMobileViewport(tester);
    final router = _selfIntroductionRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(_testRouterApp(router));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('face-photo-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.profileFacePhotos.fullPath,
    );
  });
}

void _setMobileViewport(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(375, 812)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _testApp({
  required Widget home,
  _MemoryProfileDetailsPersistence? persistence,
  _RecordingProfileRepository? repository,
}) {
  return ProviderScope(
    overrides: [
      profileDetailsPersistenceProvider.overrideWithValue(
        persistence ?? _MemoryProfileDetailsPersistence(),
      ),
      if (repository != null)
        profileRepositoryProvider.overrideWithValue(repository),
    ],
    child: EasyLocalization(
      supportedLocales: AppLocalization.supportedLocales,
      path: AppLocalization.path,
      fallbackLocale: AppLocalization.fallbackLocale,
      startLocale: AppLocalization.fallbackLocale,
      saveLocale: false,
      child: MaterialApp(theme: Themes.light, home: home),
    ),
  );
}

Widget _testRouterApp(
  GoRouter router, {
  _MemoryProfileDetailsPersistence? persistence,
  _RecordingProfileRepository? repository,
}) {
  return ProviderScope(
    overrides: [
      profileDetailsPersistenceProvider.overrideWithValue(
        persistence ?? _MemoryProfileDetailsPersistence(),
      ),
      profileRepositoryProvider.overrideWithValue(
        repository ?? _RecordingProfileRepository(),
      ),
    ],
    child: EasyLocalization(
      supportedLocales: AppLocalization.supportedLocales,
      path: AppLocalization.path,
      fallbackLocale: AppLocalization.fallbackLocale,
      startLocale: AppLocalization.fallbackLocale,
      saveLocale: false,
      child: MaterialApp.router(theme: Themes.light, routerConfig: router),
    ),
  );
}

GoRouter _selfIntroductionRouter() {
  return GoRouter(
    initialLocation: OnboardingRoutes.profileSelfIntroduction.fullPath,
    routes: [
      GoRoute(
        name: OnboardingRoutes.profileSelfIntroduction.name,
        path: OnboardingRoutes.profileSelfIntroduction.fullPath,
        builder: (context, state) => const BasicProfileSelfIntroductionPage(),
      ),
      GoRoute(
        name: OnboardingRoutes.profileFacePhotos.name,
        path: OnboardingRoutes.profileFacePhotos.fullPath,
        builder: (context, state) => const Text('face-photo-target'),
      ),
      GoRoute(
        name: OnboardingRoutes.approvalPending.name,
        path: OnboardingRoutes.approvalPending.fullPath,
        builder: (context, state) => const Text('approval-pending-target'),
      ),
    ],
  );
}

Future<void> _pumpAsyncWork(WidgetTester tester) async {
  await tester.runAsync(() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  });
  await tester.pump();
}

Finder _textEither(String key, String translated) {
  return find.byWidgetPredicate((widget) {
    return widget is Text && (widget.data == key || widget.data == translated);
  });
}

class _MemoryProfileDetailsPersistence implements ProfileDetailsPersistence {
  LoginProfileDetails? profile;
  LoginProfileStatus? profileStatus;

  _MemoryProfileDetailsPersistence([this.profile]);

  @override
  LoginProfileDetails? readProfileDetails() => profile;

  @override
  Future<void> saveProfileDetails(LoginProfileDetails? profile) async {
    this.profile = profile;
  }

  @override
  Future<void> saveProfileStatus(LoginProfileStatus status) async {
    profileStatus = status;
  }
}

class _RecordingProfileRepository extends MockProfileRepository {
  String? submittedMbti;
  String? submittedSelfIntroduction;
  String? submittedMainStylePhotoKey;
  String? submittedMainFacePhotoKey;
  bool didRequestProfileApproval = false;

  @override
  Future<void> submitProfileDetails({
    required String mbti,
    required String selfIntroduction,
    String? mainStylePhotoKey,
    List<String> subStylePhotoKeys = const <String>[],
    String? mainFacePhotoKey,
    List<String> subFacePhotoKeys = const <String>[],
  }) async {
    submittedMbti = mbti;
    submittedSelfIntroduction = selfIntroduction;
    submittedMainStylePhotoKey = mainStylePhotoKey;
    submittedMainFacePhotoKey = mainFacePhotoKey;
  }

  @override
  Future<void> requestProfileApproval() async {
    didRequestProfileApproval = true;
  }
}

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_input_field.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/constants/localization_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_education_profile.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_education_page.dart';
import 'package:wingle/features/onboarding/presentation/providers/education_profile_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/university_codebook_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    await HiveUtil.initialize(HiveAesCipher(Hive.generateSecureKey()));
    await HiveUtil.write(
      key: HiveLoginBox.profileStatus,
      value: LoginProfileStatus.educationInfoCompleted.apiValue,
    );
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  testWidgets('학교 정보 입력 첫 화면은 학력 선택 전 다음 버튼을 비활성화한다', (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pump();

    expect(
      _textEither(
        'onboarding.basicProfile.education.levelTitle',
        '현재 재학중이신가요?',
      ),
      findsOneWidget,
    );
    expect(
      _textEither('onboarding.basicProfile.education.option.university', '대학교'),
      findsOneWidget,
    );

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('학력 선택 후 다음을 누르면 학교명 입력으로 이동한다', (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pump();

    await tester.tap(
      _textEither('onboarding.basicProfile.education.option.university', '대학교'),
    );
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    expect(
      _textEither(
        'onboarding.basicProfile.education.schoolTitle',
        '출신/재학 중인\n학교는 어디인가요?',
      ),
      findsOneWidget,
    );
    expect(find.byType(TextFormField), findsOneWidget);
  });

  testWidgets('학교명 입력 필드는 코드북 학교 자동완성을 선택할 수 있다', (tester) async {
    final repository = _RecordingProfileRepository();

    await tester.pumpWidget(
      _testApp(
        repository: repository,
        universities: const [
          CodebookEntry(code: 'U001', codeName: '한국대학교', displayOrder: 0),
          CodebookEntry(code: 'U002', codeName: '한국사이버대학교', displayOrder: 1),
        ],
      ),
    );
    await tester.pump();

    await tester.tap(
      _textEither('onboarding.basicProfile.education.option.university', '대학교'),
    );
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    await tester.enterText(find.byType(TextFormField), '한국');
    await tester.pump();

    expect(find.text('한국대학교'), findsOneWidget);
    expect(find.text('한국사이버대학교'), findsOneWidget);

    await tester.tap(find.text('한국대학교'));
    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(BasicProfileEducationPage)),
    );
    expect(container.read(educationProfileProvider).schoolName, '한국대학교');
    expect(container.read(educationProfileProvider).universityCode, 'U001');

    await tester.tap(find.byType(FloatingActionButton));
    await _pumpAsyncWork(tester);

    expect(repository.university, 'U001');
    expect(repository.customUniversityName, isNull);
    expect(
      _textEither(
        'onboarding.basicProfile.educationEmail.emailLabel',
        '학교 이메일',
      ),
      findsOneWidget,
    );
  });

  testWidgets('학교명을 제출하면 학교 이메일 인증 화면으로 이동한다', (tester) async {
    final repository = _RecordingProfileRepository();

    await tester.pumpWidget(_testApp(repository: repository));
    await tester.pump();

    await tester.tap(
      _textEither('onboarding.basicProfile.education.option.university', '대학교'),
    );
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), '한국대학교');
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await _pumpAsyncWork(tester);

    expect(repository.university, 'U001');
    final container = ProviderScope.containerOf(
      tester.element(find.byType(BasicProfileEducationPage)),
    );
    expect(container.read(educationProfileProvider).submitErrorMessage, isNull);
    expect(
      container.read(educationProfileProvider).isEducationSubmitted,
      isTrue,
    );
    expect(
      _textEither(
        'onboarding.basicProfile.educationEmail.emailLabel',
        '학교 이메일',
      ),
      findsOneWidget,
    );
  });

  testWidgets('학교 이메일 인증번호 실패는 인증번호 입력 필드에 오류를 표시한다', (tester) async {
    await tester.pumpWidget(
      _testApp(
        repository: _RecordingProfileRepository(failEducationConfirm: true),
      ),
    );
    await tester.pump();

    await tester.tap(
      _textEither('onboarding.basicProfile.education.option.university', '대학교'),
    );
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), '한국대학교');
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await _pumpAsyncWork(tester);

    await tester.enterText(find.byType(TextFormField), 'name@snu.ac.kr');
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField).last, '123456');
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    final fields = tester
        .widgetList<DefaultInputField>(find.byType(DefaultInputField))
        .toList();

    expect(fields, hasLength(2));
    expect(fields.first.errorText, isNull);
    expect(fields.last.errorText, ApiErrorMessages.verifyEducationEmailFailed);
  });

  testWidgets('학교 이메일 화면의 증명서 안내를 누르면 학적증명서 등록 화면으로 이동한다', (tester) async {
    await tester.pumpWidget(
      _testApp(repository: _RecordingProfileRepository()),
    );
    await tester.pump();

    await tester.tap(
      _textEither('onboarding.basicProfile.education.option.university', '대학교'),
    );
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), '한국대학교');
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await _pumpAsyncWork(tester);

    await tester.tap(
      _textEither(
        'onboarding.basicProfile.educationEmail.certificationGuide',
        '메일이 만료되었을 때는 이렇게 인증 가능해요',
      ),
    );
    await tester.pump();

    expect(
      _textEither(
        'onboarding.basicProfile.educationCertification.title',
        '학적 증명서를\n등록해주세요',
      ),
      findsOneWidget,
    );
    expect(
      _textEither(
        'onboarding.basicProfile.educationCertification.uploadLabel',
        '증명서 사진 업로드',
      ),
      findsOneWidget,
    );
  });

  testWidgets('코드북에 없는 학교를 제출하면 학적증명서 등록 화면으로 이동한다', (tester) async {
    final repository = _RecordingProfileRepository();

    await tester.pumpWidget(_testApp(repository: repository));
    await tester.pump();

    await tester.tap(
      _textEither('onboarding.basicProfile.education.option.university', '대학교'),
    );
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), '새로운대학교');
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await _pumpAsyncWork(tester);

    expect(repository.university, isNull);
    expect(repository.customUniversityName, '새로운대학교');
    expect(
      _textEither(
        'onboarding.basicProfile.educationCertification.title',
        '학적 증명서를\n등록해주세요',
      ),
      findsOneWidget,
    );
    expect(
      _textEither(
        'onboarding.basicProfile.educationCertification.uploadLabel',
        '증명서 사진 업로드',
      ),
      findsOneWidget,
    );
  });

  testWidgets('고등학교는 학교명 제출 후 학적 인증 없이 상세 프로필로 이동한다', (tester) async {
    final repository = _RecordingProfileRepository();
    final router = _educationRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(_testRouterApp(router, repository: repository));
    await tester.pump();

    await tester.tap(
      _textEither(
        'onboarding.basicProfile.education.option.highSchool',
        '고등학교',
      ),
    );
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), '서울고등학교');
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await _pumpAsyncWork(tester);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();

    expect(repository.educationLevel, 'HIGH_SCHOOL');
    expect(repository.customUniversityName, '서울고등학교');
    expect(find.text('profile-details-target'), findsOneWidget);
  });

  testWidgets('학교 정보 입력 첫 화면의 앱바 뒤로가기는 직종 선택으로 이동한다', (tester) async {
    final router = _educationRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(_testRouterApp(router));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();

    expect(find.text('occupation-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.basicProfileCompany.fullPath,
    );
  });

  testWidgets('학교 정보 입력 첫 화면의 시스템 뒤로가기도 직종 선택으로 이동한다', (tester) async {
    final router = _educationRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(_testRouterApp(router));
    await tester.pump();

    await tester.binding.handlePopRoute();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();

    expect(find.text('occupation-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.basicProfileCompany.fullPath,
    );
  });
}

Widget _testApp({
  MockProfileRepository repository = const MockProfileRepository(),
  List<CodebookEntry> universities = const [
    CodebookEntry(code: 'U001', codeName: '한국대학교', displayOrder: 0),
  ],
}) {
  return ProviderScope(
    overrides: [
      profileRepositoryProvider.overrideWithValue(repository),
      educationProfilePersistenceProvider.overrideWithValue(
        _MemoryEducationProfilePersistence(),
      ),
      universityCodebookEntriesProvider.overrideWithValue(universities),
    ],
    child: EasyLocalization(
      supportedLocales: AppLocalization.supportedLocales,
      path: AppLocalization.path,
      fallbackLocale: AppLocalization.fallbackLocale,
      startLocale: AppLocalization.fallbackLocale,
      saveLocale: false,
      child: MaterialApp(
        theme: Themes.light,
        home: const BasicProfileEducationPage(),
      ),
    ),
  );
}

Widget _testRouterApp(
  GoRouter router, {
  MockProfileRepository repository = const MockProfileRepository(),
  List<CodebookEntry> universities = const [
    CodebookEntry(code: 'U001', codeName: '한국대학교', displayOrder: 0),
  ],
}) {
  return ProviderScope(
    overrides: [
      profileRepositoryProvider.overrideWithValue(repository),
      educationProfilePersistenceProvider.overrideWithValue(
        _MemoryEducationProfilePersistence(),
      ),
      universityCodebookEntriesProvider.overrideWithValue(universities),
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

GoRouter _educationRouter() {
  return GoRouter(
    initialLocation: OnboardingRoutes.basicProfileEducation.fullPath,
    routes: [
      GoRoute(
        name: OnboardingRoutes.basicProfileEducation.name,
        path: OnboardingRoutes.basicProfileEducation.fullPath,
        builder: (context, state) => const BasicProfileEducationPage(),
      ),
      GoRoute(
        name: OnboardingRoutes.basicProfileCompany.name,
        path: OnboardingRoutes.basicProfileCompany.fullPath,
        builder: (context, state) => const Text('occupation-target'),
      ),
      GoRoute(
        name: OnboardingRoutes.profileDetails.name,
        path: OnboardingRoutes.profileDetails.fullPath,
        builder: (context, state) => const Text('profile-details-target'),
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

class _RecordingProfileRepository extends MockProfileRepository {
  final bool failEducationConfirm;

  String? university;
  String? customUniversityName;
  String? educationLevel;

  _RecordingProfileRepository({this.failEducationConfirm = false});

  @override
  Future<void> submitEducation({
    required String? university,
    required String? customUniversityName,
    required String educationLevel,
  }) async {
    this.university = university;
    this.customUniversityName = customUniversityName;
    this.educationLevel = educationLevel;
  }

  @override
  Future<void> updateEducation({
    required String? university,
    required String? customUniversityName,
    required String educationLevel,
  }) async {
    this.university = university;
    this.customUniversityName = customUniversityName;
    this.educationLevel = educationLevel;
  }

  @override
  Future<void> verifyEducationEmail({required String email}) async {}

  @override
  Future<void> confirmEducationEmail({
    required String email,
    required int verificationCode,
  }) async {
    if (failEducationConfirm) {
      throw Exception('invalid code');
    }
  }
}

class _MemoryEducationProfilePersistence
    implements EducationProfilePersistence {
  LoginEducationProfile? _profile;

  @override
  LoginEducationProfile? readEducationProfile() => _profile;

  @override
  Future<void> saveEducationProfile(LoginEducationProfile? profile) async {
    _profile = profile;
  }
}

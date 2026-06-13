import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/auth/domain/models/my_profile_snapshot.dart';
import 'package:wingle/features/home/route/home_routes.dart';
import 'package:wingle/features/onboarding/application/device_contact_service.dart';
import 'package:wingle/features/onboarding/domain/model/contact_block_contact.dart';
import 'package:wingle/features/onboarding/domain/repository/contact_repository.dart';
import 'package:wingle/features/onboarding/presentation/page/contact_block_page.dart';
import 'package:wingle/features/onboarding/presentation/providers/contact_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/device_contact_service_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/onboarding_profile_status_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('다음에 버튼은 연락처 업로드 없이 온보딩을 완료하고 홈으로 이동한다', (tester) async {
    _setMobileViewport(tester);
    final router = _contactBlockRouter();
    addTearDown(router.dispose);
    final contactRepository = _RecordingContactRepository();
    final persistence = _MemoryOnboardingProfileStatusPersistence();
    final deviceContactService = _RecordingDeviceContactService(const []);

    await tester.pumpWidget(
      _testApp(
        router,
        contactRepository: contactRepository,
        persistence: persistence,
        deviceContactService: deviceContactService,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      _textEither('onboarding.contactBlock.title', '아는 사람은\n매칭에서 제외할 수 있어요'),
      findsOneWidget,
    );

    await tester.tap(_textEither('onboarding.contactBlock.later', '다음에'));
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(deviceContactService.readCount, 0);
    expect(contactRepository.uploadedPhoneNumbers, isEmpty);
    expect(persistence.profileStatus, LoginProfileStatus.onboardingCompleted);
    expect(find.text('home-target'), findsOneWidget);
  });

  testWidgets('차단하기는 선택한 연락처 전화번호를 업로드하고 홈으로 이동한다', (tester) async {
    _setMobileViewport(tester);
    final router = _contactBlockRouter();
    addTearDown(router.dispose);
    final contactRepository = _RecordingContactRepository();
    final persistence = _MemoryOnboardingProfileStatusPersistence();
    final deviceContactService = _RecordingDeviceContactService(const [
      ContactBlockContact(
        id: 'contact-1',
        displayName: '김연락',
        phoneNumbers: ['010-1111-2222'],
      ),
      ContactBlockContact(
        id: 'contact-2',
        displayName: '박연락',
        phoneNumbers: ['010-3333-4444'],
      ),
    ]);

    await tester.pumpWidget(
      _testApp(
        router,
        contactRepository: contactRepository,
        persistence: persistence,
        deviceContactService: deviceContactService,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(_textEither('onboarding.contactBlock.block', '차단하기'));
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(deviceContactService.readCount, 1);
    expect(
      _textEither('onboarding.contactBlock.sheetTitle', '제외할 연락처를 선택해주세요'),
      findsOneWidget,
    );
    expect(find.text('김연락'), findsOneWidget);
    expect(find.text('박연락'), findsOneWidget);

    await tester.tap(find.text('김연락'));
    await tester.pumpAndSettle();

    await tester.tap(
      _textEither('onboarding.contactBlock.uploadSelected', '선택한 연락처 차단하기'),
    );
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(contactRepository.uploadedPhoneNumbers, [
      ['010-1111-2222'],
    ]);
    expect(persistence.profileStatus, LoginProfileStatus.onboardingCompleted);
    expect(find.text('home-target'), findsOneWidget);
  });
}

void _setMobileViewport(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(375, 812)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _testApp(
  GoRouter router, {
  required _RecordingContactRepository contactRepository,
  required _MemoryOnboardingProfileStatusPersistence persistence,
  required _RecordingDeviceContactService deviceContactService,
}) {
  return ProviderScope(
    overrides: [
      contactRepositoryProvider.overrideWithValue(contactRepository),
      onboardingProfileStatusPersistenceProvider.overrideWithValue(persistence),
      deviceContactServiceProvider.overrideWithValue(deviceContactService),
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

GoRouter _contactBlockRouter() {
  return GoRouter(
    initialLocation: OnboardingRoutes.contactBlock.fullPath,
    routes: [
      GoRoute(
        name: OnboardingRoutes.contactBlock.name,
        path: OnboardingRoutes.contactBlock.fullPath,
        builder: (context, state) => const ContactBlockPage(),
      ),
      GoRoute(
        name: HomeRoutes.root.name,
        path: HomeRoutes.root.path,
        builder: (context, state) => const Text('home-target'),
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

class _RecordingDeviceContactService implements DeviceContactService {
  final List<ContactBlockContact> contacts;
  int readCount = 0;

  _RecordingDeviceContactService(this.contacts);

  @override
  Future<List<ContactBlockContact>> readContacts() async {
    readCount += 1;
    return contacts;
  }
}

class _RecordingContactRepository implements ContactRepository {
  final List<List<String>> uploadedPhoneNumbers = [];

  @override
  Future<void> uploadContacts({required List<String> phoneNumbers}) async {
    uploadedPhoneNumbers.add(List.unmodifiable(phoneNumbers));
  }
}

class _MemoryOnboardingProfileStatusPersistence
    implements OnboardingProfileStatusPersistence {
  LoginProfileStatus? profileStatus;

  @override
  Future<void> saveMyProfileSnapshot(MyProfileSnapshot snapshot) async {
    profileStatus = snapshot.onboardingStatus;
  }

  @override
  Future<void> saveProfileStatus(LoginProfileStatus status) async {
    profileStatus = status;
  }
}

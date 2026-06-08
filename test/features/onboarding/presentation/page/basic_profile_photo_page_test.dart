import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';
import 'package:wingle/features/auth/domain/models/login_profile_details.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/auth/domain/models/my_profile_snapshot.dart';
import 'package:wingle/features/onboarding/data/mock/mock_file_repository.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/domain/model/file/file_models.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_photo_page.dart';
import 'package:wingle/features/onboarding/presentation/providers/file_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_details_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_photo_picker_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/utils/upload_image_compressor.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('스타일 사진 등록 전에는 다음 버튼을 비활성화한다', (tester) async {
    _setMobileViewport(tester);

    await tester.pumpWidget(_testApp(home: const BasicProfileStylePhotoPage()));
    await tester.pump();

    expect(
      _textEither(
        'onboarding.basicProfile.profilePhoto.styleTitle',
        '본인의 스타일이 잘 보이는 사진을\n최소 1장 이상 등록해주세요',
      ),
      findsOneWidget,
    );
    expect(
      _textEither('onboarding.basicProfile.profilePhoto.styleLabel', '스타일'),
      findsOneWidget,
    );
    expect(
      _textEither('onboarding.basicProfile.profilePhoto.guide', '사진 등록 가이드'),
      findsOneWidget,
    );

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('스타일 사진 화면 진입 시 서버 스냅샷 사진을 슬롯 상태로 복원한다', (tester) async {
    _setMobileViewport(tester);
    final persistence = _MemoryProfileDetailsPersistence();

    await tester.pumpWidget(
      _testApp(
        home: const BasicProfileStylePhotoPage(),
        persistence: persistence,
        profileRepository: const _ImmediateProfileRepository(
          profileSnapshot: MyProfileSnapshot(
            profileDetails: LoginProfileDetails(
              stylePhotos: [
                LoginProfilePhoto(
                  key: 'users/1/style/server-main.webp',
                  url:
                      'https://storage.example.com/users/1/style/server-main.webp',
                ),
                LoginProfilePhoto(
                  key: 'users/1/style/server-sub.webp',
                  url:
                      'https://storage.example.com/users/1/style/server-sub.webp',
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.pump();

    expect(_cachedNetworkImageUrls(tester), [
      'https://storage.example.com/users/1/style/server-main.webp',
      'https://storage.example.com/users/1/style/server-sub.webp',
    ]);
    expect(_cachedNetworkImageCacheKeys(tester), [
      'users/1/style/server-main.webp',
      'users/1/style/server-sub.webp',
    ]);
    expect(find.byType(AnimationProgressIndicator), findsNWidgets(2));
    expect(
      persistence.profile?.mainStylePhotoKey,
      'users/1/style/server-main.webp',
    );
    expect(persistence.profile?.subStylePhotoKeys, [
      'users/1/style/server-sub.webp',
    ]);

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('로컬에 key만 있는 얼굴 사진은 서버 스냅샷 URL로 미리보기를 보강한다', (tester) async {
    _setMobileViewport(tester);
    final persistence = _MemoryProfileDetailsPersistence(
      const LoginProfileDetails(
        mainFacePhotoKey: 'users/1/face/server-main.webp',
      ),
    );

    await tester.pumpWidget(
      _testApp(
        home: const BasicProfileFacePhotoPage(),
        persistence: persistence,
        profileRepository: const _ImmediateProfileRepository(
          profileSnapshot: MyProfileSnapshot(
            profileDetails: LoginProfileDetails(
              facePhotos: [
                LoginProfilePhoto(
                  key: 'users/1/face/server-main.webp',
                  url:
                      'https://storage.example.com/users/1/face/server-main.webp',
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(_cachedNetworkImageUrls(tester), [
      'https://storage.example.com/users/1/face/server-main.webp',
    ]);
    expect(_cachedNetworkImageCacheKeys(tester), [
      'users/1/face/server-main.webp',
    ]);
    expect(find.byType(AnimationProgressIndicator), findsOneWidget);
  });

  testWidgets('스타일 사진을 드래그하면 첫 번째 사진을 대표 사진으로 저장한다', (tester) async {
    _setMobileViewport(tester);
    final persistence = _MemoryProfileDetailsPersistence(
      const LoginProfileDetails(
        mainStylePhotoKey: 'users/1/style/main.jpg',
        subStylePhotoKeys: ['users/1/style/sub.jpg'],
      ),
    );

    await tester.pumpWidget(
      _testApp(
        home: const BasicProfileStylePhotoPage(),
        persistence: persistence,
      ),
    );
    await tester.pump();

    final checkIcons = find.byIcon(Icons.check_rounded);
    expect(checkIcons, findsNWidgets(2));

    final gesture = await tester.startGesture(
      tester.getCenter(checkIcons.at(1)),
    );
    await tester.pump(const Duration(milliseconds: 700));
    await gesture.moveTo(tester.getCenter(checkIcons.first));
    await tester.pump();
    await gesture.up();
    await _pumpAsyncWork(tester);

    expect(persistence.profile?.mainStylePhotoKey, 'users/1/style/sub.jpg');
    expect(persistence.profile?.subStylePhotoKeys, ['users/1/style/main.jpg']);
  });

  testWidgets('스타일 사진은 여러 장을 한 번에 선택해 순서대로 저장한다', (tester) async {
    _setMobileViewport(tester);
    final persistence = _MemoryProfileDetailsPersistence();
    final fileRepository = _SequentialProfilePhotoFileRepository();
    int? requestedMaxCount;

    await tester.pumpWidget(
      _testApp(
        home: const BasicProfileStylePhotoPage(),
        persistence: persistence,
        fileRepository: fileRepository,
        photoPicker: (maxCount) async {
          requestedMaxCount = maxCount;
          return [
            _xFile('style-main.jpg'),
            _xFile('style-sub-1.jpg'),
            _xFile('style-sub-2.jpg'),
            _xFile('ignored.jpg'),
          ];
        },
        imageCompressor: (bytes, _) async => bytes,
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.checkroom_outlined));
    await _pumpAsyncWork(tester);

    expect(requestedMaxCount, 3);
    expect(fileRepository.stylePresignRequestCount, 3);
    expect(persistence.profile?.mainStylePhotoKey, 'users/1/style/0.webp');
    expect(persistence.profile?.subStylePhotoKeys, [
      'users/1/style/1.webp',
      'users/1/style/2.webp',
    ]);
  });

  testWidgets('스타일 사진 화면의 앱바 뒤로가기는 MBTI 화면으로 이동한다', (tester) async {
    _setMobileViewport(tester);
    final router = _styleRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(_testRouterApp(router));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('mbti-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.profileDetails.fullPath,
    );
  });

  testWidgets('스타일 사진 저장 후 다음 체인으로 이동한다', (tester) async {
    _setMobileViewport(tester);
    final router = _styleRouter();
    addTearDown(router.dispose);
    final persistence = _MemoryProfileDetailsPersistence(
      const LoginProfileDetails(mainStylePhotoKey: 'users/1/style/main.jpg'),
    );

    await tester.pumpWidget(_testRouterApp(router, persistence: persistence));
    await tester.pump();

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNotNull);

    await tester.tap(find.byType(FloatingActionButton));
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(find.text('face-photo-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.profileFacePhotos.fullPath,
    );
  });

  testWidgets('얼굴 사진 화면의 뒤로가기와 다음 체인을 따른다', (tester) async {
    _setMobileViewport(tester);
    final router = _faceRouter();
    addTearDown(router.dispose);
    final persistence = _MemoryProfileDetailsPersistence(
      const LoginProfileDetails(mainFacePhotoKey: 'users/1/face/main.jpg'),
    );

    await tester.pumpWidget(_testRouterApp(router, persistence: persistence));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('style-photo-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.profileStylePhotos.fullPath,
    );

    router.goNamed(OnboardingRoutes.profileFacePhotos.name);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(find.text('self-introduction-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.profileSelfIntroduction.fullPath,
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
  _SequentialProfilePhotoFileRepository? fileRepository,
  MockProfileRepository? profileRepository,
  ProfilePhotoPickerFn? photoPicker,
  UploadImageCompressionFn? imageCompressor,
}) {
  return ProviderScope(
    overrides: [
      profileDetailsPersistenceProvider.overrideWithValue(
        persistence ?? _MemoryProfileDetailsPersistence(),
      ),
      if (fileRepository != null)
        fileRepositoryProvider.overrideWithValue(fileRepository),
      profileRepositoryProvider.overrideWithValue(
        profileRepository ?? const _ImmediateProfileRepository(),
      ),
      if (photoPicker != null)
        profilePhotoPickerProvider.overrideWithValue(photoPicker),
      if (imageCompressor != null)
        profilePhotoUploadImageCompressorProvider.overrideWithValue(
          imageCompressor,
        ),
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
}) {
  return ProviderScope(
    overrides: [
      profileDetailsPersistenceProvider.overrideWithValue(
        persistence ?? _MemoryProfileDetailsPersistence(),
      ),
      profileRepositoryProvider.overrideWithValue(
        const _ImmediateProfileRepository(),
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

GoRouter _styleRouter() {
  return GoRouter(
    initialLocation: OnboardingRoutes.profileStylePhotos.fullPath,
    routes: [
      GoRoute(
        name: OnboardingRoutes.profileStylePhotos.name,
        path: OnboardingRoutes.profileStylePhotos.fullPath,
        builder: (context, state) => const BasicProfileStylePhotoPage(),
      ),
      GoRoute(
        name: OnboardingRoutes.profileDetails.name,
        path: OnboardingRoutes.profileDetails.fullPath,
        builder: (context, state) => const Text('mbti-target'),
      ),
      GoRoute(
        name: OnboardingRoutes.profileFacePhotos.name,
        path: OnboardingRoutes.profileFacePhotos.fullPath,
        builder: (context, state) => const Text('face-photo-target'),
      ),
    ],
  );
}

GoRouter _faceRouter() {
  return GoRouter(
    initialLocation: OnboardingRoutes.profileFacePhotos.fullPath,
    routes: [
      GoRoute(
        name: OnboardingRoutes.profileFacePhotos.name,
        path: OnboardingRoutes.profileFacePhotos.fullPath,
        builder: (context, state) => const BasicProfileFacePhotoPage(),
      ),
      GoRoute(
        name: OnboardingRoutes.profileStylePhotos.name,
        path: OnboardingRoutes.profileStylePhotos.fullPath,
        builder: (context, state) => const Text('style-photo-target'),
      ),
      GoRoute(
        name: OnboardingRoutes.profileSelfIntroduction.name,
        path: OnboardingRoutes.profileSelfIntroduction.fullPath,
        builder: (context, state) => const Text('self-introduction-target'),
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

List<String> _cachedNetworkImageUrls(WidgetTester tester) {
  return tester
      .widgetList<CachedNetworkImage>(find.byType(CachedNetworkImage))
      .map((image) => image.imageUrl)
      .toList(growable: false);
}

List<String?> _cachedNetworkImageCacheKeys(WidgetTester tester) {
  return tester
      .widgetList<CachedNetworkImage>(find.byType(CachedNetworkImage))
      .map((image) => image.cacheKey)
      .toList(growable: false);
}

XFile _xFile(String name) {
  return XFile.fromData(
    _transparentPngBytes,
    name: name,
    mimeType: 'image/png',
  );
}

final Uint8List _transparentPngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDw'
  'AFgwJ/lcL0RgAAAABJRU5ErkJggg==',
);

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

class _SequentialProfilePhotoFileRepository extends MockFileRepository {
  int stylePresignRequestCount = 0;

  @override
  Future<ProfileImagePresignResult> createStyleImagePresignedUrl({
    String contentType = 'image/webp',
  }) async {
    final index = stylePresignRequestCount++;
    return ProfileImagePresignResult(
      presignedUrl: 'https://mock-upload.example.com/style/$index.webp',
      s3Key: 'users/1/style/$index.webp',
    );
  }

  @override
  Future<void> uploadBytesToPresignedUrl({
    required String presignedUrl,
    required List<int> bytes,
    required String contentType,
  }) async {}
}

class _ImmediateProfileRepository extends MockProfileRepository {
  const _ImmediateProfileRepository({super.profileSnapshot});

  @override
  Future<MyProfileSnapshot?> fetchMyProfile() async {
    return profileSnapshot;
  }
}

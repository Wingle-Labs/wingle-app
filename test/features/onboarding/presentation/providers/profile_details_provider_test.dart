import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_profile_details.dart';
import 'package:wingle/features/onboarding/data/mock/mock_file_repository.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/domain/model/file/file_models.dart';
import 'package:wingle/features/onboarding/presentation/models/profile_details_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/file_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_details_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    await HiveUtil.initialize(HiveAesCipher(Hive.generateSecureKey()));
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('MBTI 네 축을 선택하면 완성된 MBTI 값을 만든다', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(profileDetailsProvider.notifier);
    notifier.selectMbtiLetter('E');
    notifier.selectMbtiLetter('S');
    notifier.selectMbtiLetter('T');
    notifier.selectMbtiLetter('J');

    final state = container.read(profileDetailsProvider);
    expect(state.canContinueMbti, isTrue);
    expect(state.mbti, 'ESTJ');
  });

  test('MBTI 저장 후 새 provider에서 로컬 상세 프로필을 복원한다', () async {
    final container = ProviderContainer();

    final notifier = container.read(profileDetailsProvider.notifier);
    notifier.selectMbtiLetter('I');
    notifier.selectMbtiLetter('N');
    notifier.selectMbtiLetter('F');
    notifier.selectMbtiLetter('P');

    final success = await notifier.saveMbti();
    expect(success, isTrue);

    final persistedProfile =
        jsonDecode(HiveUtil.read(HiveLoginBox.profileDetails)!) as Map;
    expect(persistedProfile['mbti'], 'INFP');

    container.dispose();
    final restoredContainer = ProviderContainer();
    addTearDown(restoredContainer.dispose);

    final restoredState = restoredContainer.read(profileDetailsProvider);
    expect(restoredState.mbti, 'INFP');
  });

  test('MBTI가 완성되기 전에는 선택 중인 값을 로컬 저장하지 않는다', () async {
    final persistence = _MemoryProfileDetailsPersistence();
    final container = ProviderContainer(
      overrides: [
        profileDetailsPersistenceProvider.overrideWithValue(persistence),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(profileDetailsProvider.notifier);
    notifier.selectMbtiLetter('E');
    notifier.selectMbtiLetter('S');
    notifier.selectMbtiLetter('T');
    await Future<void>.delayed(Duration.zero);

    expect(persistence.profile, isNull);

    notifier.selectMbtiLetter('J');
    await Future<void>.delayed(Duration.zero);

    expect(persistence.profile?.mbti, 'ESTJ');
  });

  test('MBTI 네 축이 모두 선택되지 않으면 저장하지 않는다', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(profileDetailsProvider.notifier);
    notifier.selectMbtiLetter('E');

    final success = await notifier.saveMbti();

    expect(success, isFalse);
    expect(HiveUtil.read(HiveLoginBox.profileDetails), isNull);
  });

  test('스타일 사진 업로드 성공 시 대표 스타일 사진 key를 로컬 저장한다', () async {
    final persistence = _MemoryProfileDetailsPersistence();
    final fileRepository = _RecordingProfilePhotoFileRepository();
    final container = ProviderContainer(
      overrides: [
        profileDetailsPersistenceProvider.overrideWithValue(persistence),
        fileRepositoryProvider.overrideWithValue(fileRepository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(profileDetailsProvider.notifier);
    final success = await notifier.uploadPhoto(
      type: ProfilePhotoType.style,
      slotIndex: 0,
      name: 'style.png',
      contentType: 'image/png',
      bytes: Uint8List.fromList([1, 2, 3]),
    );
    final state = container.read(profileDetailsProvider);

    expect(success, isTrue);
    expect(fileRepository.styleContentType, 'image/png');
    expect(fileRepository.uploadedBytes, [1, 2, 3]);
    expect(state.canContinueStylePhotos, isTrue);
    expect(state.mainStylePhotoKey, 'users/1/style/style.png');
    expect(persistence.profile?.mainStylePhotoKey, 'users/1/style/style.png');
  });

  test('얼굴 사진 업로드 성공 시 대표 얼굴 사진 key를 로컬 저장한다', () async {
    final persistence = _MemoryProfileDetailsPersistence();
    final fileRepository = _RecordingProfilePhotoFileRepository();
    final container = ProviderContainer(
      overrides: [
        profileDetailsPersistenceProvider.overrideWithValue(persistence),
        fileRepositoryProvider.overrideWithValue(fileRepository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(profileDetailsProvider.notifier);
    final success = await notifier.uploadPhoto(
      type: ProfilePhotoType.face,
      slotIndex: 0,
      name: 'face.webp',
      contentType: 'image/webp',
      bytes: Uint8List.fromList([4, 5, 6]),
    );
    final state = container.read(profileDetailsProvider);

    expect(success, isTrue);
    expect(fileRepository.faceContentType, 'image/webp');
    expect(state.canContinueFacePhotos, isTrue);
    expect(state.mainFacePhotoKey, 'users/1/face/face.webp');
    expect(persistence.profile?.mainFacePhotoKey, 'users/1/face/face.webp');
  });

  test('사진 순서 변경 시 첫 번째 사진을 대표 사진으로 저장한다', () async {
    final persistence = _MemoryProfileDetailsPersistence();
    final container = ProviderContainer(
      overrides: [
        profileDetailsPersistenceProvider.overrideWithValue(persistence),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(profileDetailsProvider.notifier);
    final success = await notifier.replacePhotos(
      type: ProfilePhotoType.style,
      photos: const [
        ProfilePhotoInput(
          s3Key: 'users/1/style/sub.jpg',
          name: 'sub.jpg',
          contentType: 'image/jpeg',
        ),
        ProfilePhotoInput(
          s3Key: 'users/1/style/main.jpg',
          name: 'main.jpg',
          contentType: 'image/jpeg',
        ),
      ],
    );
    final state = container.read(profileDetailsProvider);

    expect(success, isTrue);
    expect(state.mainStylePhotoKey, 'users/1/style/sub.jpg');
    expect(state.subStylePhotoKeys, ['users/1/style/main.jpg']);
    expect(persistence.profile?.mainStylePhotoKey, 'users/1/style/sub.jpg');
    expect(persistence.profile?.subStylePhotoKeys, ['users/1/style/main.jpg']);
  });

  test('사진 파일 업로드 중이어도 다른 사진 presigned URL 발급을 시작할 수 있다', () async {
    final fileRepository = _BlockingProfilePhotoFileRepository();
    final container = ProviderContainer(
      overrides: [fileRepositoryProvider.overrideWithValue(fileRepository)],
    );
    addTearDown(container.dispose);

    final notifier = container.read(profileDetailsProvider.notifier);
    final firstUpload = notifier.uploadPhotoFile(
      type: ProfilePhotoType.style,
      name: 'first.webp',
      contentType: 'image/webp',
      bytes: Uint8List.fromList([1]),
    );
    final secondUpload = notifier.uploadPhotoFile(
      type: ProfilePhotoType.style,
      name: 'second.webp',
      contentType: 'image/webp',
      bytes: Uint8List.fromList([2]),
    );

    expect(fileRepository.stylePresignRequestCount, 2);
    expect(container.read(profileDetailsProvider).isSubmitting, isFalse);

    fileRepository.completeStylePresign(
      index: 1,
      s3Key: 'users/1/style/second.webp',
    );
    await Future<void>.delayed(Duration.zero);
    fileRepository.completeStylePresign(
      index: 0,
      s3Key: 'users/1/style/first.webp',
    );
    await Future<void>.delayed(Duration.zero);

    expect(fileRepository.uploadRequestCount, 2);

    fileRepository.completeRawUpload(index: 1);
    fileRepository.completeRawUpload(index: 0);

    final firstPhoto = await firstUpload;
    final secondPhoto = await secondUpload;

    expect(firstPhoto?.s3Key, 'users/1/style/first.webp');
    expect(secondPhoto?.s3Key, 'users/1/style/second.webp');
  });

  test('로컬 상세 프로필의 사진 key를 provider 상태로 복원한다', () {
    final persistence = _MemoryProfileDetailsPersistence(
      LoginProfileDetails(
        mainStylePhotoKey: 'users/1/style/main.jpg',
        subStylePhotoKeys: ['users/1/style/sub.jpg'],
        mainFacePhotoKey: 'users/1/face/main.jpg',
      ),
    );
    final container = ProviderContainer(
      overrides: [
        profileDetailsPersistenceProvider.overrideWithValue(persistence),
      ],
    );
    addTearDown(container.dispose);

    final state = container.read(profileDetailsProvider);

    expect(state.canContinueStylePhotos, isTrue);
    expect(state.stylePhotos, hasLength(2));
    expect(state.mainStylePhotoKey, 'users/1/style/main.jpg');
    expect(state.subStylePhotoKeys, ['users/1/style/sub.jpg']);
    expect(state.canContinueFacePhotos, isTrue);
    expect(state.mainFacePhotoKey, 'users/1/face/main.jpg');
  });

  test('자기소개 성실도는 0자, 50자, 200자 기준으로 구분한다', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(profileDetailsProvider.notifier);

    expect(
      container.read(profileDetailsProvider).selfIntroductionQuality,
      SelfIntroductionQuality.empty,
    );

    notifier.updateSelfIntroduction('짧음');
    expect(
      container.read(profileDetailsProvider).selfIntroductionQuality,
      SelfIntroductionQuality.short,
    );
    expect(
      container.read(profileDetailsProvider).canContinueSelfIntroduction,
      isTrue,
    );

    notifier.updateSelfIntroduction(List.filled(50, 'a').join());
    expect(
      container.read(profileDetailsProvider).selfIntroductionQuality,
      SelfIntroductionQuality.normal,
    );

    notifier.updateSelfIntroduction(List.filled(200, 'a').join());
    expect(
      container.read(profileDetailsProvider).selfIntroductionQuality,
      SelfIntroductionQuality.appropriate,
    );
  });

  test('자기소개 입력값을 로컬 상세 프로필에 저장한다', () async {
    final persistence = _MemoryProfileDetailsPersistence();
    final container = ProviderContainer(
      overrides: [
        profileDetailsPersistenceProvider.overrideWithValue(persistence),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(profileDetailsProvider.notifier);
    notifier.updateSelfIntroduction(' 안녕하세요. ');
    await Future<void>.delayed(Duration.zero);

    expect(persistence.profile?.selfIntroduction, '안녕하세요.');

    final success = await notifier.saveSelfIntroduction();
    expect(success, isTrue);
    expect(persistence.profile?.selfIntroduction, '안녕하세요.');
  });

  test('상세 프로필 제출 시 MBTI, 자기소개, 사진 key를 API에 전달한다', () async {
    final profileRepository = _RecordingProfileRepository();
    final persistence = _MemoryProfileDetailsPersistence();
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(profileRepository),
        profileDetailsPersistenceProvider.overrideWithValue(persistence),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(profileDetailsProvider.notifier);
    notifier.selectMbtiLetter('E');
    notifier.selectMbtiLetter('N');
    notifier.selectMbtiLetter('F');
    notifier.selectMbtiLetter('P');
    await notifier.replacePhotos(
      type: ProfilePhotoType.style,
      photos: const [
        ProfilePhotoInput(
          s3Key: 'users/1/style/main.webp',
          name: 'main.webp',
          contentType: 'image/webp',
        ),
        ProfilePhotoInput(
          s3Key: 'users/1/style/sub.webp',
          name: 'sub.webp',
          contentType: 'image/webp',
        ),
      ],
    );
    await notifier.replacePhotos(
      type: ProfilePhotoType.face,
      photos: const [
        ProfilePhotoInput(
          s3Key: 'users/1/face/main.webp',
          name: 'face.webp',
          contentType: 'image/webp',
        ),
      ],
    );
    notifier.updateSelfIntroduction(' 반가워요 ');

    final success = await notifier.submitProfileDetails();

    expect(success, isTrue);
    expect(profileRepository.submittedMbti, 'ENFP');
    expect(profileRepository.submittedSelfIntroduction, '반가워요');
    expect(
      profileRepository.submittedMainStylePhotoKey,
      'users/1/style/main.webp',
    );
    expect(profileRepository.submittedSubStylePhotoKeys, [
      'users/1/style/sub.webp',
    ]);
    expect(
      profileRepository.submittedMainFacePhotoKey,
      'users/1/face/main.webp',
    );
    expect(persistence.profile?.selfIntroduction, '반가워요');
  });
}

class _MemoryProfileDetailsPersistence implements ProfileDetailsPersistence {
  LoginProfileDetails? profile;

  _MemoryProfileDetailsPersistence([this.profile]);

  @override
  LoginProfileDetails? readProfileDetails() => profile;

  @override
  Future<void> saveProfileDetails(LoginProfileDetails? profile) async {
    this.profile = profile;
  }
}

class _RecordingProfilePhotoFileRepository extends MockFileRepository {
  List<int>? uploadedBytes;
  String? styleContentType;
  String? faceContentType;

  @override
  Future<ProfileImagePresignResult> createStyleImagePresignedUrl({
    String contentType = 'image/jpeg',
  }) async {
    styleContentType = contentType;
    return const ProfileImagePresignResult(
      presignedUrl: 'https://mock-upload.example.com/style.png',
      s3Key: 'users/1/style/style.png',
    );
  }

  @override
  Future<ProfileImagePresignResult> createFaceImagePresignedUrl({
    String contentType = 'image/jpeg',
  }) async {
    faceContentType = contentType;
    return const ProfileImagePresignResult(
      presignedUrl: 'https://mock-upload.example.com/face.webp',
      s3Key: 'users/1/face/face.webp',
    );
  }

  @override
  Future<void> uploadBytesToPresignedUrl({
    required String presignedUrl,
    required List<int> bytes,
    required String contentType,
  }) async {
    uploadedBytes = List<int>.from(bytes);
  }
}

class _RecordingProfileRepository extends MockProfileRepository {
  String? submittedMbti;
  String? submittedSelfIntroduction;
  String? submittedMainStylePhotoKey;
  List<String>? submittedSubStylePhotoKeys;
  String? submittedMainFacePhotoKey;
  List<String>? submittedSubFacePhotoKeys;

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
    submittedSubStylePhotoKeys = List<String>.of(subStylePhotoKeys);
    submittedMainFacePhotoKey = mainFacePhotoKey;
    submittedSubFacePhotoKeys = List<String>.of(subFacePhotoKeys);
  }
}

class _BlockingProfilePhotoFileRepository extends MockFileRepository {
  final List<Completer<ProfileImagePresignResult>> _stylePresignCompleters = [];
  final List<Completer<void>> _uploadCompleters = [];

  int get stylePresignRequestCount => _stylePresignCompleters.length;

  int get uploadRequestCount => _uploadCompleters.length;

  @override
  Future<ProfileImagePresignResult> createStyleImagePresignedUrl({
    String contentType = 'image/jpeg',
  }) {
    final completer = Completer<ProfileImagePresignResult>();
    _stylePresignCompleters.add(completer);
    return completer.future;
  }

  @override
  Future<void> uploadBytesToPresignedUrl({
    required String presignedUrl,
    required List<int> bytes,
    required String contentType,
  }) {
    final completer = Completer<void>();
    _uploadCompleters.add(completer);
    return completer.future;
  }

  void completeStylePresign({required int index, required String s3Key}) {
    _stylePresignCompleters[index].complete(
      ProfileImagePresignResult(
        presignedUrl: 'https://mock-upload.example.com/$index.webp',
        s3Key: s3Key,
      ),
    );
  }

  void completeRawUpload({required int index}) {
    _uploadCompleters[index].complete();
  }
}

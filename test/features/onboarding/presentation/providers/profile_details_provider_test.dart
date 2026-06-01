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
import 'package:wingle/features/onboarding/domain/model/file/file_models.dart';
import 'package:wingle/features/onboarding/presentation/models/profile_details_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/file_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_details_provider.dart';

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

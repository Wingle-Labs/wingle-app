import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/data/mock/mock_file_repository.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/domain/model/file/file_models.dart';
import 'package:wingle/features/onboarding/presentation/models/education_profile_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/education_profile_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/file_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/university_codebook_provider.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    await HiveUtil.initialize(HiveAesCipher(Hive.generateSecureKey()));
    await HiveUtil.write(
      key: HiveLoginBox.profileStatus,
      value: LoginProfileStatus.jobInfoCompleted.apiValue,
    );
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('코드북에 정확히 일치하는 학교는 university code로 제출한다', () async {
    final repository = _RecordingProfileRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    final notifier = container.read(educationProfileProvider.notifier);
    notifier.selectEducationLevel(EducationLevel.university);
    notifier.updateSchoolName('한국대학교');

    final success = await notifier.submitEducation();

    expect(success, isTrue);
    expect(repository.university, 'U001');
    expect(repository.customUniversityName, isNull);
    expect(repository.educationLevel, 'UNIVERSITY');
    expect(
      HiveUtil.read(HiveLoginBox.profileStatus),
      LoginProfileStatus.educationInfoCompleted.apiValue,
    );
  });

  test('코드북에 없는 학교는 customUniversityName으로 제출한다', () async {
    final repository = _RecordingProfileRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    final notifier = container.read(educationProfileProvider.notifier);
    notifier.selectEducationLevel(EducationLevel.university);
    notifier.updateSchoolName('새로운대학교');

    final success = await notifier.submitEducation();

    expect(success, isTrue);
    expect(repository.university, isNull);
    expect(repository.customUniversityName, '새로운대학교');
    expect(repository.educationLevel, 'UNIVERSITY');
  });

  test('인증번호 확인 실패는 인증번호 입력 오류로 저장한다', () async {
    final repository = _RecordingProfileRepository(failConfirm: true);
    final container = _container(repository);
    addTearDown(container.dispose);

    final notifier = container.read(educationProfileProvider.notifier);
    notifier.updateEmail('name@snu.ac.kr');
    notifier.updateVerificationCode('123456');

    final success = await notifier.confirmVerificationCode();
    final state = container.read(educationProfileProvider);

    expect(success, isFalse);
    expect(state.emailVerificationErrorMessage, isNull);
    expect(
      state.verificationCodeErrorMessage,
      ApiErrorMessages.verifyEducationEmailFailed,
    );
  });

  test('학적 증명서 업로드 성공은 certificationKey를 등록한다', () async {
    final repository = _RecordingProfileRepository();
    final fileRepository = _RecordingFileRepository();
    final container = _container(repository, fileRepository: fileRepository);
    addTearDown(container.dispose);

    final notifier = container.read(educationProfileProvider.notifier);
    final selected = notifier.selectCertificationFile(
      name: 'certification.png',
      contentType: 'image/png',
      bytes: const [1, 2, 3],
    );
    final success = await notifier.submitCertification();
    final state = container.read(educationProfileProvider);

    expect(selected, isTrue);
    expect(success, isTrue);
    expect(fileRepository.uploadedBytes, const [1, 2, 3]);
    expect(fileRepository.uploadedContentType, 'image/png');
    expect(
      repository.certificationKey,
      'users/1/certification/certification.png',
    );
    expect(state.certificationSubmitted, isTrue);
  });
}

ProviderContainer _container(
  _RecordingProfileRepository repository, {
  MockFileRepository? fileRepository,
}) {
  return ProviderContainer(
    overrides: [
      profileRepositoryProvider.overrideWithValue(repository),
      if (fileRepository != null)
        fileRepositoryProvider.overrideWithValue(fileRepository),
      universityCodebookEntriesProvider.overrideWithValue(const [
        CodebookEntry(code: 'U001', codeName: '한국대학교', displayOrder: 0),
      ]),
    ],
  );
}

class _RecordingProfileRepository extends MockProfileRepository {
  final bool failConfirm;

  String? university;
  String? customUniversityName;
  String? educationLevel;
  String? certificationKey;

  _RecordingProfileRepository({this.failConfirm = false});

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
  Future<void> verifyEducationEmail({required String email}) async {}

  @override
  Future<void> confirmEducationEmail({
    required String email,
    required int verificationCode,
  }) async {
    if (failConfirm) {
      throw Exception('invalid code');
    }
  }

  @override
  Future<void> submitEducationCertification({
    required String certificationKey,
  }) async {
    this.certificationKey = certificationKey;
  }
}

class _RecordingFileRepository extends MockFileRepository {
  List<int>? uploadedBytes;
  String? uploadedContentType;

  @override
  Future<ProfileImagePresignResult> createCertificationPresignedUrl({
    String contentType = 'image/jpeg',
  }) async {
    return const ProfileImagePresignResult(
      presignedUrl: 'https://mock-upload.example.com/certification.png',
      s3Key: 'users/1/certification/certification.png',
    );
  }

  @override
  Future<void> uploadBytesToPresignedUrl({
    required String presignedUrl,
    required List<int> bytes,
    required String contentType,
  }) async {
    uploadedBytes = List<int>.from(bytes);
    uploadedContentType = contentType;
  }
}

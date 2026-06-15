import 'dart:convert';
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
    final persistedProfile =
        jsonDecode(HiveUtil.read(HiveLoginBox.educationProfile)!) as Map;
    expect(persistedProfile['educationLevel'], 'UNIVERSITY');
    expect(persistedProfile['schoolName'], '한국대학교');
    expect(persistedProfile['universityCode'], 'U001');
    expect(
      HiveUtil.read(HiveLoginBox.profileStatus),
      LoginProfileStatus.educationInfoCompleted.apiValue,
    );
  });

  test('코드북 학교를 선택하면 학교명과 universityCode를 상태에 저장한다', () {
    final repository = _RecordingProfileRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    final notifier = container.read(educationProfileProvider.notifier);
    notifier.selectEducationLevel(EducationLevel.university);
    notifier.selectUniversityEntry(
      const CodebookEntry(code: 'U001', codeName: '한국대학교', displayOrder: 0),
    );

    final state = container.read(educationProfileProvider);
    expect(state.schoolName, '한국대학교');
    expect(state.universityCode, 'U001');
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

  test('기타 학력은 학교명 없이 educationLevel만 제출한다', () async {
    final repository = _RecordingProfileRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    final notifier = container.read(educationProfileProvider.notifier);
    notifier.selectEducationLevel(EducationLevel.other);

    final success = await notifier.submitEducation();

    expect(success, isTrue);
    expect(repository.university, isNull);
    expect(repository.customUniversityName, isNull);
    expect(repository.educationLevel, 'OTHER');
  });

  test('거절 상태에서 학교 정보를 저장하면 수정 API를 호출하고 반려 상태를 유지한다', () async {
    await HiveUtil.write(
      key: HiveLoginBox.profileStatus,
      value: LoginProfileStatus.profileRejected.apiValue,
    );
    final repository = _RecordingProfileRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    final notifier = container.read(educationProfileProvider.notifier);
    notifier.selectEducationLevel(EducationLevel.highSchool);
    notifier.updateSchoolName('서울고등학교');

    final success = await notifier.submitEducation();

    expect(success, isTrue);
    expect(repository.didSubmitEducation, isFalse);
    expect(repository.didUpdateEducation, isTrue);
    expect(repository.educationLevel, 'HIGH_SCHOOL');
    expect(repository.customUniversityName, '서울고등학교');
    expect(
      HiveUtil.read(HiveLoginBox.profileStatus),
      LoginProfileStatus.profileRejected.apiValue,
    );
  });

  test('학교 정보 제출 시 선택한 학력과 학교명은 로컬 학교 프로필로 저장된다', () async {
    final repository = _RecordingProfileRepository();
    final container = _container(repository);

    final notifier = container.read(educationProfileProvider.notifier);
    notifier.selectEducationLevel(EducationLevel.master);
    notifier.updateSchoolName('한국대학원');

    final success = await notifier.submitEducation();

    expect(success, isTrue);

    final persistedProfile =
        jsonDecode(HiveUtil.read(HiveLoginBox.educationProfile)!) as Map;
    expect(persistedProfile['educationLevel'], 'MASTER');
    expect(persistedProfile['schoolName'], '한국대학원');

    container.dispose();
    final restoredContainer = _container(repository);
    addTearDown(restoredContainer.dispose);

    final restoredState = restoredContainer.read(educationProfileProvider);
    expect(restoredState.educationLevel, EducationLevel.master);
    expect(restoredState.schoolName, '한국대학원');
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

  test('학적 증명서 파일 업로드 실패는 업로드 오류로 저장한다', () async {
    final repository = _RecordingProfileRepository();
    final fileRepository = _RecordingFileRepository(failUpload: true);
    final container = _container(repository, fileRepository: fileRepository);
    addTearDown(container.dispose);

    final notifier = container.read(educationProfileProvider.notifier);
    notifier.selectCertificationFile(
      name: 'certification.png',
      contentType: 'image/png',
      bytes: const [1, 2, 3],
    );

    final success = await notifier.submitCertification();
    final state = container.read(educationProfileProvider);

    expect(success, isFalse);
    expect(repository.certificationKey, isNull);
    expect(state.certificationSubmitted, isFalse);
    expect(state.certificationErrorMessage, ApiErrorMessages.uploadFileFailed);
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
  bool didSubmitEducation = false;
  bool didUpdateEducation = false;

  _RecordingProfileRepository({this.failConfirm = false});

  @override
  Future<void> submitEducation({
    required String? university,
    required String? customUniversityName,
    required String educationLevel,
  }) async {
    didSubmitEducation = true;
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
    didUpdateEducation = true;
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
  final bool failUpload;

  List<int>? uploadedBytes;
  String? uploadedContentType;

  _RecordingFileRepository({this.failUpload = false});

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
    if (failUpload) {
      throw Exception(ApiErrorMessages.uploadFileFailed);
    }

    uploadedBytes = List<int>.from(bytes);
    uploadedContentType = contentType;
  }
}

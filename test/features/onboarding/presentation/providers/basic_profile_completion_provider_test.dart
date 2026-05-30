import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:wingle/app/providers/current_user_gender_provider.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_basic_profile.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';

class _RecordingProfileRepository extends MockProfileRepository {
  String? nickname;
  ResidenceCode? residence;
  int? height;
  String? bodyTypeCode;
  int submitCount = 0;
  int updateCount = 0;

  @override
  Future<void> submitBasicProfile({
    required String nickname,
    required ResidenceCode residence,
    required int height,
    required String bodyTypeCode,
  }) async {
    this.nickname = nickname;
    this.residence = residence;
    this.height = height;
    this.bodyTypeCode = bodyTypeCode;
    submitCount += 1;
  }

  @override
  Future<void> updateBasicProfile({
    required String nickname,
    required ResidenceCode residence,
    required int height,
    required String bodyTypeCode,
  }) async {
    this.nickname = nickname;
    this.residence = residence;
    this.height = height;
    this.bodyTypeCode = bodyTypeCode;
    updateCount += 1;
  }
}

void main() {
  late Directory tempDir;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    final key = Hive.generateSecureKey();
    final cipher = HiveAesCipher(key);
    await HiveUtil.initialize(cipher);
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('기본 프로필 정보를 업로드하고 승인 대기 상태를 저장한다', () async {
    final repository = _RecordingProfileRepository();
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(repository),
        currentUserGenderProvider.overrideWithValue('male'),
      ],
    );
    addTearDown(container.dispose);

    final subscription = container.listen(basicProfileProvider, (_, _) {});
    addTearDown(subscription.close);

    await container.read(basicProfileProvider.notifier).loadNickname();
    container
        .read(basicProfileProvider.notifier)
        .updateResidenceQuery('서울특별시 강남구');
    container.read(basicProfileProvider.notifier).updateHeight('175');
    container.read(basicProfileProvider.notifier).selectBodyShape('BT_M_001');

    final success = await container
        .read(basicProfileProvider.notifier)
        .submit();

    expect(success, isTrue);
    expect(repository.nickname, MockProfileRepository.mockNickname);
    expect(repository.residence, isNotNull);
    expect(repository.height, 175);
    expect(repository.bodyTypeCode, 'BT_M_001');
    expect(
      HiveUtil.read(HiveLoginBox.profileStatus),
      LoginProfileStatus.basicInfoCompleted.apiValue,
    );
    final persistedProfile =
        jsonDecode(HiveUtil.read(HiveLoginBox.basicProfile)!) as Map;
    expect(persistedProfile['nickname'], MockProfileRepository.mockNickname);
    expect(persistedProfile['height'], 175);
    expect(persistedProfile['bodyTypeCode'], 'BT_M_001');
  });

  test('로그인 응답의 기본 프로필 정보로 입력 상태를 복원한다', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container
        .read(basicProfileProvider.notifier)
        .restoreFromLogin(
          const LoginBasicProfile(
            nickname: '반반한 라벤더',
            residenceCode: 'R_31193620',
            height: 175,
            bodyTypeCode: 'BT_M_001',
          ),
        );

    final state = container.read(basicProfileProvider);

    expect(state.nickname, '반반한 라벤더');
    expect(state.residenceCode?.level1, 'R_31');
    expect(state.residenceCode?.level2, 'R_31193');
    expect(state.residenceCode?.level3, 'R_31193620');
    expect(state.height, '175');
    expect(state.bodyShapeCode, 'BT_M_001');
  });

  test('Hive에 저장된 기본 프로필 정보로 초기 상태를 복원한다', () async {
    await HiveUtil.write(
      key: HiveLoginBox.basicProfile,
      value: jsonEncode(
        const LoginBasicProfile(
          nickname: '저장된 닉네임',
          residenceCode: 'R_11060840',
          height: 168,
          bodyTypeCode: 'BT_F_002',
        ).toJson(),
      ),
    );

    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(basicProfileProvider);

    expect(state.nickname, '저장된 닉네임');
    expect(state.residenceCode?.level1, 'R_11');
    expect(state.residenceCode?.level2, 'R_11060');
    expect(state.residenceCode?.level3, 'R_11060840');
    expect(state.height, '168');
    expect(state.bodyShapeCode, 'BT_F_002');
  });

  test('서버 내 프로필 스냅샷이 있으면 기본 프로필 상태를 갱신한다', () async {
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(
          const MockProfileRepository(
            basicProfile: LoginBasicProfile(
              nickname: '서버 닉네임',
              residenceCode: 'R_31193620',
              height: 175,
              bodyTypeCode: 'BT_M_001',
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(basicProfileProvider.notifier)
        .restoreFromServerProfileIfAvailable();

    final state = container.read(basicProfileProvider);
    expect(state.nickname, '서버 닉네임');
    expect(state.residenceCode?.level3, 'R_31193620');
    expect(state.height, '175');
    expect(state.bodyShapeCode, 'BT_M_001');
    expect(HiveUtil.read(HiveLoginBox.basicProfile), contains('서버 닉네임'));
  });

  test('기본 프로필 완료 상태에서는 PUT으로 기본 프로필을 수정한다', () async {
    await HiveUtil.write(
      key: HiveLoginBox.profileStatus,
      value: LoginProfileStatus.basicInfoCompleted.apiValue,
    );

    final repository = _RecordingProfileRepository();
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(repository),
        currentUserGenderProvider.overrideWithValue('male'),
      ],
    );
    addTearDown(container.dispose);

    final subscription = container.listen(basicProfileProvider, (_, _) {});
    addTearDown(subscription.close);

    await container.read(basicProfileProvider.notifier).loadNickname();
    container
        .read(basicProfileProvider.notifier)
        .updateResidenceQuery('서울특별시 강남구');
    container.read(basicProfileProvider.notifier).updateHeight('175');
    container.read(basicProfileProvider.notifier).selectBodyShape('BT_M_001');

    final success = await container
        .read(basicProfileProvider.notifier)
        .submit();

    expect(success, isTrue);
    expect(repository.submitCount, 0);
    expect(repository.updateCount, 1);
    expect(repository.bodyTypeCode, 'BT_M_001');
    expect(
      HiveUtil.read(HiveLoginBox.profileStatus),
      LoginProfileStatus.basicInfoCompleted.apiValue,
    );
  });
}

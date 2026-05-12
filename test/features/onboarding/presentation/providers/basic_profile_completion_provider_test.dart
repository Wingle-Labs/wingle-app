import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:wingle/app/providers/current_user_gender_provider.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';

class _RecordingProfileRepository extends MockProfileRepository {
  String? nickname;
  ResidenceCode? residence;
  int? height;
  String? bodyType;

  @override
  Future<void> submitBasicProfile({
    required String nickname,
    required ResidenceCode residence,
    required int height,
    required String bodyType,
  }) async {
    this.nickname = nickname;
    this.residence = residence;
    this.height = height;
    this.bodyType = bodyType;
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
    container.read(basicProfileProvider.notifier).selectBodyShape('slim');

    final success = await container
        .read(basicProfileProvider.notifier)
        .submit();

    expect(success, isTrue);
    expect(repository.nickname, MockProfileRepository.mockNickname);
    expect(repository.residence, isNotNull);
    expect(repository.height, 175);
    expect(repository.bodyType, '슬림');
    expect(
      HiveUtil.read(HiveLoginBox.profileStatus),
      LoginProfileStatus.basicInfoCompleted.apiValue,
    );
  });
}

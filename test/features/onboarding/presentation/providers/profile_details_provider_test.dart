import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_profile_details.dart';
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
}

class _MemoryProfileDetailsPersistence implements ProfileDetailsPersistence {
  LoginProfileDetails? profile;

  @override
  LoginProfileDetails? readProfileDetails() => profile;

  @override
  Future<void> saveProfileDetails(LoginProfileDetails? profile) async {
    this.profile = profile;
  }
}

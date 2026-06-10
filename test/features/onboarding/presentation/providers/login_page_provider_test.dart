import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/data/mock/mock_login_repository.dart';
import 'package:wingle/features/auth/domain/models/login_basic_profile.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/auth/domain/models/my_profile_snapshot.dart';
import 'package:wingle/features/auth/presentation/providers/login_repository_provider.dart';
import 'package:wingle/features/notification/application/fcm_token_service.dart';
import 'package:wingle/features/notification/domain/repository/fcm_token_repository.dart';
import 'package:wingle/features/notification/presentation/providers/fcm_token_service_provider.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/login_page_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';

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

  group('LoginPageProvider', () {
    test('controller 변경이 provider state에 반영된다', () {
      final container = ProviderContainer(
        overrides: [
          profileRepositoryProvider.overrideWithValue(
            const MockProfileRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(loginPageProvider.notifier);

      notifier.phoneController.text = '010-9256-6504';
      notifier.passwordController.text = 'abc123!@';

      final state = container.read(loginPageProvider);

      expect(state.phone, '010-9256-6504');
      expect(state.password, 'abc123!@');
      expect(state.canLogin, isTrue);
    });

    test('clear/reset이 controller와 state를 함께 초기화한다', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(loginPageProvider.notifier);

      notifier.updatePhone('010-9256-6504');
      notifier.updatePassword('abc123!@');
      notifier.togglePasswordVisibility();

      notifier.clearPhone();

      expect(notifier.phoneController.text, isEmpty);
      expect(container.read(loginPageProvider).phone, isEmpty);

      notifier.reset();

      final state = container.read(loginPageProvider);

      expect(notifier.phoneController.text, isEmpty);
      expect(notifier.passwordController.text, isEmpty);
      expect(state.phone, isEmpty);
      expect(state.password, isEmpty);
      expect(state.isPasswordVisible, isFalse);
    });

    test('submit 성공 시 토큰을 저장한다', () async {
      final container = ProviderContainer(
        overrides: [
          profileRepositoryProvider.overrideWithValue(
            const MockProfileRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(loginPageProvider, (_, _) {});
      addTearDown(subscription.close);

      final notifier = container.read(loginPageProvider.notifier);

      notifier.updatePhone('010-9256-6504');
      notifier.updatePassword('!abc1010');

      final result = await notifier.submit();

      expect(result, isTrue);
      expect(HiveUtil.read(HiveLoginBox.userId), '010-9256-6504');
      expect(HiveUtil.read(HiveLoginBox.accessToken), 'mock-access-token');
      expect(HiveUtil.read(HiveLoginBox.refreshToken), 'mock-refresh-token');
      expect(HiveUtil.read(HiveLoginBox.gender), 'male');
      expect(
        HiveUtil.read(HiveLoginBox.profileStatus),
        LoginProfileStatus.signupCompleted.apiValue,
      );
    });

    test('submit 성공 시 FCM 토큰 등록을 시작한다', () async {
      final fcmRepository = _RecordingFcmTokenRepository();
      final fcmService = FcmTokenService(
        repository: fcmRepository,
        requestPermission: () async {},
        readToken: () async => 'fcm-token',
        tokenRefreshStream: const Stream<String>.empty(),
        logger: (_) {},
      );
      addTearDown(fcmService.dispose);
      final container = ProviderContainer(
        overrides: [
          profileRepositoryProvider.overrideWithValue(
            const MockProfileRepository(),
          ),
          fcmTokenServiceProvider.overrideWithValue(fcmService),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(loginPageProvider, (_, _) {});
      addTearDown(subscription.close);

      final notifier = container.read(loginPageProvider.notifier);

      notifier.updatePhone('010-9256-6504');
      notifier.updatePassword('!abc1010');

      final result = await notifier.submit();
      await Future<void>.delayed(Duration.zero);

      expect(result, isTrue);
      expect(fcmRepository.tokens, ['fcm-token']);
    });

    test('submit 성공 시 로그인 응답의 기본 프로필 정보를 복원한다', () async {
      final container = ProviderContainer(
        overrides: [
          loginRepositoryProvider.overrideWithValue(
            const MockLoginRepository(
              profileStatus: LoginProfileStatus.basicInfoCompleted,
              basicProfile: LoginBasicProfile(
                nickname: '설레는 크리스탈',
                residenceCode: 'R_11060840',
                height: 168,
                bodyTypeCode: 'BT_F_002',
              ),
              gender: 'female',
            ),
          ),
          profileRepositoryProvider.overrideWithValue(
            const MockProfileRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(loginPageProvider, (_, _) {});
      addTearDown(subscription.close);

      final notifier = container.read(loginPageProvider.notifier);

      notifier.updatePhone('010-9256-6504');
      notifier.updatePassword('!abc1010');

      final result = await notifier.submit();
      final basicProfile = container.read(basicProfileProvider);

      expect(result, isTrue);
      expect(basicProfile.nickname, '설레는 크리스탈');
      expect(basicProfile.residenceCode?.level3, 'R_11060840');
      expect(basicProfile.height, '168');
      expect(basicProfile.bodyShapeCode, 'BT_F_002');
      expect(HiveUtil.read(HiveLoginBox.gender), 'female');

      final persistedProfile =
          jsonDecode(HiveUtil.read(HiveLoginBox.basicProfile)!) as Map;
      expect(persistedProfile['nickname'], '설레는 크리스탈');
      expect(persistedProfile['residenceCode'], 'R_11060840');
      expect(persistedProfile['height'], 168);
      expect(persistedProfile['bodyTypeCode'], 'BT_F_002');
    });

    test('submit 성공 응답에 기본 프로필이 없으면 같은 사용자의 로컬 스냅샷을 유지한다', () async {
      await HiveUtil.write(key: HiveLoginBox.userId, value: '010-9256-6504');
      await HiveUtil.write(
        key: HiveLoginBox.basicProfile,
        value: jsonEncode({
          'userId': '010-9256-6504',
          'nickname': '저장된 닉네임',
          'residenceCode': 'R_31193620',
          'height': 175,
          'bodyTypeCode': 'BT_M_001',
        }),
      );

      final container = ProviderContainer(
        overrides: [
          profileRepositoryProvider.overrideWithValue(
            const MockProfileRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(loginPageProvider, (_, _) {});
      addTearDown(subscription.close);

      final notifier = container.read(loginPageProvider.notifier);

      notifier.updatePhone('010-9256-6504');
      notifier.updatePassword('!abc1010');

      final result = await notifier.submit();
      final persistedProfile =
          jsonDecode(HiveUtil.read(HiveLoginBox.basicProfile)!) as Map;

      expect(result, isTrue);
      expect(persistedProfile['nickname'], '저장된 닉네임');
      expect(persistedProfile['residenceCode'], 'R_31193620');
      expect(persistedProfile['height'], 175);
      expect(persistedProfile['bodyTypeCode'], 'BT_M_001');
    });

    test('submit 성공 후 /profiles/me 스냅샷이 있으면 기본 프로필을 복원한다', () async {
      final container = ProviderContainer(
        overrides: [
          profileRepositoryProvider.overrideWithValue(
            const MockProfileRepository(
              profileSnapshot: MyProfileSnapshot(
                basicProfile: LoginBasicProfile(
                  nickname: '서버 닉네임',
                  residenceCode: 'R_31193620',
                  height: 175,
                  bodyTypeCode: 'BT_M_001',
                ),
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(loginPageProvider, (_, _) {});
      addTearDown(subscription.close);

      final notifier = container.read(loginPageProvider.notifier);

      notifier.updatePhone('010-9256-6504');
      notifier.updatePassword('!abc1010');

      final result = await notifier.submit();
      final basicProfile = container.read(basicProfileProvider);

      expect(result, isTrue);
      expect(basicProfile.nickname, '서버 닉네임');
      expect(basicProfile.residenceCode?.level3, 'R_31193620');
      expect(basicProfile.height, '175');
      expect(basicProfile.bodyShapeCode, 'BT_M_001');
    });

    test('submit 실패 시 에러 메시지를 보관한다', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final subscription = container.listen(loginPageProvider, (_, _) {});
      addTearDown(subscription.close);

      final notifier = container.read(loginPageProvider.notifier);

      notifier.updatePhone('010-9256-6504');
      notifier.updatePassword('abc123!@');

      final result = await notifier.submit();
      final state = container.read(loginPageProvider);

      expect(result, isFalse);
      expect(state.errorMessage, 'common.error.api.invalidLoginCredentials');
    });
  });
}

class _RecordingFcmTokenRepository implements FcmTokenRepository {
  final List<String> tokens = <String>[];

  @override
  Future<void> registerToken({required String token}) async {
    tokens.add(token.trim());
  }
}

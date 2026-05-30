import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:wingle/app/bootstrap/initializers/auth_session_initializer.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/auth_session_state.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/exceptions/auth_exception.dart';
import 'package:wingle/features/auth/domain/models/auth_token.dart';
import 'package:wingle/features/auth/domain/models/login_basic_profile.dart';
import 'package:wingle/features/auth/domain/models/login_job_profile.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/auth/domain/models/login_result.dart';
import 'package:wingle/features/auth/domain/models/my_profile_snapshot.dart';
import 'package:wingle/features/auth/domain/models/password.dart';
import 'package:wingle/features/auth/domain/models/phone_number.dart';
import 'package:wingle/features/auth/domain/repositories/login_repository.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';

class _FakeLoginRepository implements LoginRepository {
  Future<AuthToken> Function(String refreshToken)? onReissue;
  Future<LoginResult> Function(PhoneNumber phoneNumber, Password password)?
  onLogin;
  int reissueCount = 0;
  int loginCount = 0;

  @override
  Future<LoginResult> login({
    required PhoneNumber phoneNumber,
    required Password password,
  }) async {
    loginCount += 1;
    final handler = onLogin;
    if (handler == null) {
      throw const AuthException('login failed');
    }
    return handler(phoneNumber, password);
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AuthToken> reissue({required String refreshToken}) async {
    reissueCount += 1;
    final handler = onReissue;
    if (handler == null) {
      throw const AuthException('reissue failed');
    }
    return handler(refreshToken);
  }
}

void main() {
  late Directory tempDir;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    AuthSessionState.notifyChanged();
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    await HiveUtil.initialize(HiveAesCipher(Hive.generateSecureKey()));
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('refresh token이 있으면 부팅 시 토큰을 재발급한다', () async {
    await HiveUtil.write(key: HiveLoginBox.refreshToken, value: 'old-refresh');
    final repository = _FakeLoginRepository()
      ..onReissue = (refreshToken) async {
        expect(refreshToken, 'old-refresh');
        return const AuthToken(
          accessToken: 'new-access',
          refreshToken: 'new-refresh',
        );
      };
    final initializer = AuthSessionInitializer(
      loginRepository: repository,
      logger: (_) {},
    );

    final result = await initializer.initialize();

    expect(result.status, AuthSessionInitializeStatus.refreshed);
    expect(repository.reissueCount, 1);
    expect(repository.loginCount, 0);
    expect(HiveUtil.read(HiveLoginBox.accessToken), 'new-access');
    expect(HiveUtil.read(HiveLoginBox.refreshToken), 'new-refresh');
    expect(AuthSessionState.shouldRedirectToLogin, isFalse);
  });

  test('refresh token 재발급 후 /profiles/me 스냅샷이 있으면 로컬 프로필을 갱신한다', () async {
    await HiveUtil.write(key: HiveLoginBox.userId, value: '010-9256-6504');
    await HiveUtil.write(key: HiveLoginBox.refreshToken, value: 'old-refresh');
    final repository = _FakeLoginRepository()
      ..onReissue = (_) async {
        return const AuthToken(
          accessToken: 'new-access',
          refreshToken: 'new-refresh',
        );
      };
    final initializer = AuthSessionInitializer(
      loginRepository: repository,
      profileRepository: const MockProfileRepository(
        profileSnapshot: MyProfileSnapshot(
          onboardingStatus: LoginProfileStatus.jobInfoCompleted,
          basicProfile: LoginBasicProfile(
            nickname: '서버 닉네임',
            residenceCode: 'R_31193620',
            height: 175,
            bodyTypeCode: 'BT_M_001',
          ),
          jobProfile: LoginJobProfile(
            company: '삼성전자',
            occupationCode: 'J103',
            occupationName: '사무직',
            emailVerified: true,
          ),
        ),
      ),
      logger: (_) {},
    );

    final result = await initializer.initialize();

    expect(result.status, AuthSessionInitializeStatus.refreshed);
    expect(HiveUtil.read(HiveLoginBox.basicProfile), contains('서버 닉네임'));
    expect(HiveUtil.read(HiveLoginBox.basicProfile), contains('BT_M_001'));
    expect(HiveUtil.read(HiveLoginBox.jobProfile), contains('삼성전자'));
    expect(HiveUtil.read(HiveLoginBox.jobProfile), contains('J103'));
    expect(
      HiveUtil.read(HiveLoginBox.profileStatus),
      LoginProfileStatus.jobInfoCompleted.apiValue,
    );
  });

  test('refresh 실패 시 저장된 아이디와 비밀번호로 재로그인한다', () async {
    await HiveUtil.write(key: HiveLoginBox.userId, value: '010-9256-6504');
    await HiveUtil.write(key: HiveLoginBox.userPassword, value: '!abc1010');
    await HiveUtil.write(key: HiveLoginBox.refreshToken, value: 'expired');
    final repository = _FakeLoginRepository()
      ..onReissue = (_) async {
        throw const AuthException('expired refresh');
      }
      ..onLogin = (phoneNumber, password) async {
        expect(phoneNumber.apiValue, '010-9256-6504');
        expect(password.value, '!abc1010');
        return const LoginResult(
          accessToken: 'login-access',
          refreshToken: 'login-refresh',
          profileStatus: LoginProfileStatus.basicInfoCompleted,
          gender: 'female',
          basicProfile: LoginBasicProfile(
            nickname: '복구된 닉네임',
            residenceCode: 'R_11060840',
            height: 168,
            bodyTypeCode: 'BT_F_002',
          ),
        );
      };
    final initializer = AuthSessionInitializer(
      loginRepository: repository,
      logger: (_) {},
    );

    final result = await initializer.initialize();

    expect(result.status, AuthSessionInitializeStatus.reloggedIn);
    expect(repository.reissueCount, 1);
    expect(repository.loginCount, 1);
    expect(HiveUtil.read(HiveLoginBox.accessToken), 'login-access');
    expect(HiveUtil.read(HiveLoginBox.refreshToken), 'login-refresh');
    expect(HiveUtil.read(HiveLoginBox.profileStatus), 'BASIC_INFO_COMPLETED');
    expect(HiveUtil.read(HiveLoginBox.gender), 'female');
    expect(HiveUtil.read(HiveLoginBox.basicProfile), contains('BT_F_002'));
    expect(AuthSessionState.shouldRedirectToLogin, isFalse);
  });

  test('refresh와 저장된 계정 복구가 모두 불가하면 로그인 정보가 삭제된다', () async {
    await HiveUtil.write(key: HiveLoginBox.refreshToken, value: 'expired');
    await HiveUtil.write(
      key: HiveLoginBox.profileStatus,
      value: LoginProfileStatus.basicInfoCompleted.apiValue,
    );
    final repository = _FakeLoginRepository()
      ..onReissue = (_) async {
        throw const AuthException('expired refresh');
      };
    final initializer = AuthSessionInitializer(
      loginRepository: repository,
      logger: (_) {},
    );

    final result = await initializer.initialize();

    expect(result.status, AuthSessionInitializeStatus.signedOut);
    expect(repository.reissueCount, 1);
    expect(repository.loginCount, 0);
    expect(HiveUtil.read(HiveLoginBox.refreshToken), isNull);
    expect(HiveUtil.read(HiveLoginBox.profileStatus), isNull);
    expect(AuthSessionState.shouldRedirectToLogin, isTrue);
  });
}

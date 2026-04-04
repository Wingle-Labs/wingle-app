import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/presentation/providers/login_page_provider.dart';

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
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(loginPageProvider.notifier);

      notifier.phoneController.text = '010-1234-5678';
      notifier.passwordController.text = 'abc123!@';

      final state = container.read(loginPageProvider);

      expect(state.phone, '010-1234-5678');
      expect(state.password, 'abc123!@');
      expect(state.canLogin, isTrue);
    });

    test('clear/reset이 controller와 state를 함께 초기화한다', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(loginPageProvider.notifier);

      notifier.updatePhone('010-1234-5678');
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
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final subscription = container.listen(loginPageProvider, (_, _) {});
      addTearDown(subscription.close);

      final notifier = container.read(loginPageProvider.notifier);

      notifier.updatePhone('010-1234-5678');
      notifier.updatePassword('!abc1010');

      final result = await notifier.submit();

      expect(result, isTrue);
      expect(HiveUtil.read(HiveLoginBox.userId), '010-1234-5678');
      expect(HiveUtil.read(HiveLoginBox.accessToken), 'mock-access-token');
      expect(HiveUtil.read(HiveLoginBox.refreshToken), 'mock-refresh-token');
      expect(
        HiveUtil.read(HiveLoginBox.profileStatus),
        LoginProfileStatus.firstApprovalApproved.apiValue,
      );
    });

    test('submit 실패 시 에러 메시지를 보관한다', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final subscription = container.listen(loginPageProvider, (_, _) {});
      addTearDown(subscription.close);

      final notifier = container.read(loginPageProvider.notifier);

      notifier.updatePhone('010-1234-5678');
      notifier.updatePassword('abc123!@');

      final result = await notifier.submit();
      final state = container.read(loginPageProvider);

      expect(result, isFalse);
      expect(state.errorMessage, 'common.error.api.invalidLoginCredentials');
    });
  });
}

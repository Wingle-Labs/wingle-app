import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/onboarding/presentation/providers/login_page_provider.dart';

void main() {
  group('LoginPageProvider', () {
    test('controller 변경이 provider state에 반영된다', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(loginPageProvider.notifier);

      notifier.phoneController.text = '01023456789';
      notifier.passwordController.text = 'Password1!';

      final state = container.read(loginPageProvider);

      expect(state.phone, '01023456789');
      expect(state.password, 'Password1!');
      expect(state.canLogin, isTrue);
    });

    test('clear/reset이 controller와 state를 함께 초기화한다', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(loginPageProvider.notifier);

      notifier.updatePhone('01023456789');
      notifier.updatePassword('Password1!');
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
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/features/auth/data/mock/mock_login_repository.dart';
import 'package:wingle/features/auth/domain/exceptions/auth_exception.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/auth/domain/models/password.dart';
import 'package:wingle/features/auth/domain/models/phone_number.dart';

void main() {
  test('MockLoginRepository는 12개 상태를 모두 반환할 수 있다', () async {
    for (final status in LoginProfileStatus.values) {
      final repository = MockLoginRepository(profileStatus: status);
      final result = await repository.login(
        phoneNumber: PhoneNumber(MockLoginRepository.mockPhoneNumber),
        password: Password(MockLoginRepository.mockPassword),
      );

      expect(result.accessToken, 'mock-access-token');
      expect(result.refreshToken, 'mock-refresh-token');
      expect(result.profileStatus, status);
      expect(result.gender, 'male');
    }
  });

  test('MockLoginRepository는 잘못된 자격 증명에 대해 예외를 던진다', () async {
    final repository = MockLoginRepository();

    expect(
      () => repository.login(
        phoneNumber: PhoneNumber('01012345678'),
        password: Password('wrong-password'),
      ),
      throwsA(
        isA<AuthException>().having(
          (e) => e.message,
          'message',
          ApiErrorMessages.invalidLoginCredentials,
        ),
      ),
    );
  });
}

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/onboarding/data/mock/mock_pass_repository.dart';
import 'package:wingle/features/onboarding/data/mock/mock_signup_repository.dart';
import 'package:wingle/features/onboarding/data/signup_repository_impl.dart';
import 'package:wingle/features/onboarding/presentation/providers/pass_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/signup_repository_provider.dart';

void main() {
  void loadApiEnv(String source) {
    dotenv.loadFromString(
      envString:
          '''
        API_BASE_URL=https://api.example.com
        API_SOURCE=$source
      ''',
    );
  }

  test('LIVE 환경에서도 PASS 인증 결과 조회만 mock으로 유지한다', () {
    loadApiEnv('LIVE');
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final repository = container.read(passRepositoryProvider);

    expect(repository, isA<MockPassRepository>());
  });

  test('LIVE 환경에서는 비밀번호 설정 등 회원가입 API를 live repository로 처리한다', () {
    loadApiEnv('LIVE');
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final repository = container.read(signupRepositoryProvider);

    expect(repository, isA<SignupRepositoryImpl>());
  });

  test('MOCK 환경에서는 회원가입 API도 mock repository로 처리한다', () {
    loadApiEnv('MOCK');
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final repository = container.read(signupRepositoryProvider);

    expect(repository, isA<MockSignupRepository>());
  });
}

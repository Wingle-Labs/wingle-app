import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/onboarding/data/pass_repository_impl.dart';

void main() {
  test('PassRepositoryImpl은 아직 구현되지 않은 상태다', () {
    final repository = PassRepositoryImpl();

    expect(
      () => repository.fetchVerificationResult('imp_123'),
      throwsA(isA<UnimplementedError>()),
    );
  });
}


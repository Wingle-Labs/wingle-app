import 'package:wingle/features/onboarding/domain/repository/health_repository.dart';

/// 서버 상태 Repository Mock 구현.
class MockHealthRepository implements HealthRepository {
  /// 생성자
  const MockHealthRepository();

  @override
  Future<String> healthcheck() async => 'OK';
}

/// 서버 상태 Repository.
abstract class HealthRepository {
  /// 서버 상태를 확인한다.
  Future<String> healthcheck();
}

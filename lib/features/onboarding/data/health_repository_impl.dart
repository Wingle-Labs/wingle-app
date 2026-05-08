import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/api_paths.dart';
import 'package:wingle/features/onboarding/domain/repository/health_repository.dart';

/// 서버 상태 Repository HTTP 구현.
class HealthRepositoryImpl implements HealthRepository {
  final http.Client _client;
  final String _baseUrl;

  /// 생성자
  HealthRepositoryImpl({required http.Client client, required String baseUrl})
    : _client = client,
      _baseUrl = baseUrl;

  @override
  Future<String> healthcheck() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl${ApiEndpoints.healthcheck}'),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(ApiErrorMessages.healthcheckFailed);
    }

    return response.body;
  }
}

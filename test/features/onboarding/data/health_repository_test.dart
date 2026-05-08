import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wingle/features/onboarding/data/health_repository_impl.dart';

void main() {
  test('서버 상태를 확인한다', () async {
    final client = MockClient((request) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/api/v1/healthcheck');
      return http.Response('OK', 200);
    });

    final repository = HealthRepositoryImpl(
      client: client,
      baseUrl: 'https://api.example.com',
    );

    expect(await repository.healthcheck(), 'OK');
  });
}

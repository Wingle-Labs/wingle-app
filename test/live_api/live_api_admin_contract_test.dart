import 'package:flutter_test/flutter_test.dart';

import '../support/live_api/live_api_assertions.dart';
import '../support/live_api/live_api_client.dart';
import '../support/live_api/live_api_env.dart';

String? _skipIfMissing(Iterable<String> keys) {
  final missing = keys.where((key) => LiveApiEnv.get(key) == null).toList();
  if (missing.isEmpty) {
    return null;
  }
  return LiveApiEnv.missingConfigMessage(missing);
}

void main() {
  final adminSkipReason = _skipIfMissing([
    LiveApiEnv.baseUrlKey,
    LiveApiEnv.accessTokenKey,
    LiveApiEnv.accountIdKey,
    LiveApiEnv.accountPasswordKey,
    LiveApiEnv.adminAccessTokenKey,
  ]);

  group('Live API - admin contract', () {
    test('승인 대기 목록 조회', skip: adminSkipReason, () async {
      final client = LiveApiClient.fromEnv();
      final response = await client.get('/api/v1/admin/approvals', admin: true);

      LiveApiAssertions.expectStatus(response.statusCode, 200);
      expect(response.body, isNotEmpty);
    });

    test('온보딩 요약 조회', skip: adminSkipReason, () async {
      final client = LiveApiClient.fromEnv();
      final response = await client.get(
        '/api/v1/admin/onboarding/summary',
        admin: true,
      );

      LiveApiAssertions.expectStatus(response.statusCode, 200);
      final json = LiveApiAssertions.expectJsonMap(response.decoded);
      expect(json.keys, contains('signupCompleted'));
      expect(json.keys, contains('onboardingCompleted'));
    });

    test('온보딩 유저 목록 조회', skip: adminSkipReason, () async {
      final client = LiveApiClient.fromEnv();
      final response = await client.get(
        '/api/v1/admin/onboarding/users',
        admin: true,
        queryParameters: {'status': 'ALL'},
      );

      LiveApiAssertions.expectStatus(response.statusCode, 200);
      expect(response.body, isNotEmpty);
    });

    test('거절 사유 코드 목록 조회', skip: adminSkipReason, () async {
      final client = LiveApiClient.fromEnv();
      final response = await client.get(
        '/api/v1/admin/rejection-reason-codes',
        admin: true,
      );

      LiveApiAssertions.expectStatus(response.statusCode, 200);
      expect(response.body, isNotEmpty);
    });

    test(
      '유저 프로필 상세 조회',
      skip: _skipIfMissing([
        LiveApiEnv.baseUrlKey,
        LiveApiEnv.accessTokenKey,
        LiveApiEnv.adminAccessTokenKey,
        LiveApiEnv.adminUserIdKey,
      ]),
      () async {
        final client = LiveApiClient.fromEnv();
        final userId = LiveApiEnv.getInt(LiveApiEnv.adminUserIdKey)!;
        final response = await client.get(
          '/api/v1/admin/users/$userId/profile',
          admin: true,
        );

        LiveApiAssertions.expectStatus(response.statusCode, 200);
        expect(response.body, isNotEmpty);
      },
    );

    test(
      '유저 교육 인증은 fixture가 준비된 경우에만 수행한다',
      skip: _skipIfMissing([
        LiveApiEnv.baseUrlKey,
        LiveApiEnv.accessTokenKey,
        LiveApiEnv.adminAccessTokenKey,
        LiveApiEnv.adminUserIdKey,
        LiveApiEnv.adminDestructiveOkKey,
      ]),
      () async {
        final client = LiveApiClient.fromEnv();
        final userId = LiveApiEnv.getInt(LiveApiEnv.adminUserIdKey)!;
        final response = await client.post(
          '/api/v1/admin/users/$userId/education/verify',
          admin: true,
        );

        LiveApiAssertions.expectStatus(response.statusCode, 200);
      },
    );

    test(
      '유저 삭제는 destructive fixture가 있을 때만 수행한다',
      skip: _skipIfMissing([
        LiveApiEnv.baseUrlKey,
        LiveApiEnv.accessTokenKey,
        LiveApiEnv.adminAccessTokenKey,
        LiveApiEnv.adminUserIdKey,
        LiveApiEnv.adminDestructiveOkKey,
      ]),
      () async {
        final client = LiveApiClient.fromEnv();
        final userId = LiveApiEnv.getInt(LiveApiEnv.adminUserIdKey)!;
        final response = await client.delete(
          '/api/v1/admin/users/$userId',
          admin: true,
        );

        LiveApiAssertions.expectStatus(response.statusCode, 200);
      },
    );
  });
}

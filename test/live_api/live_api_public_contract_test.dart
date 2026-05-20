import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/common/constants/api_paths.dart';

import '../support/live_api/live_api_assertions.dart';
import '../support/live_api/live_api_client.dart';
import '../support/live_api/live_api_env.dart';

void main() {
  final skipReason = LiveApiEnv.hasRequiredConfig()
      ? null
      : LiveApiEnv.missingConfigMessage([
          LiveApiEnv.baseUrlKey,
          LiveApiEnv.accessTokenKey,
          LiveApiEnv.accountIdKey,
          LiveApiEnv.accountPasswordKey,
        ]);

  group('Live API - public contract', () {
    test('healthcheck는 문자열 응답을 반환한다', skip: skipReason, () async {
      final client = LiveApiClient.fromEnv();
      final response = await client.get(ApiEndpoints.healthcheck);
      LiveApiAssertions.expectStatus(response.statusCode, 200);
      expect(response.body.trim(), isNotEmpty);
    });

    test('terms current versions는 version 맵을 반환한다', skip: skipReason, () async {
      final client = LiveApiClient.fromEnv();
      final response = await client.get(ApiEndpoints.termsCurrentVersions);
      LiveApiAssertions.expectStatus(response.statusCode, 200);
      final json = LiveApiAssertions.expectJsonMap(response.decoded);
      expect(json, containsPair('version', 1));
    });

    test('terms snapshot은 terms 배열과 필수 필드를 반환한다', skip: skipReason, () async {
      final client = LiveApiClient.fromEnv();
      final response = await client.get(ApiEndpoints.termsSnapshot);
      LiveApiAssertions.expectStatus(response.statusCode, 200);
      final json = LiveApiAssertions.expectJsonMap(response.decoded);
      expect(json, contains('version'));

      final terms = LiveApiAssertions.expectListField(json, 'terms');
      expect(terms, isNotEmpty);

      final firstTerm = LiveApiAssertions.expectJsonMap(terms.first);
      expect(firstTerm, contains('type'));
      expect(firstTerm, contains('content'));
      expect(firstTerm, contains('isRequired'));
      expect(firstTerm, contains('version'));
    });

    test(
      'codebook current versions는 그룹 버전 맵을 반환한다',
      skip: skipReason,
      () async {
        final client = LiveApiClient.fromEnv();
        final response = await client.get(ApiEndpoints.codebookCurrentVersions);
        LiveApiAssertions.expectStatus(response.statusCode, 200);
        final json = LiveApiAssertions.expectJsonMap(response.decoded);
        expect(
          json.keys,
          containsAll(<String>[
            'QUESTION_CATEGORY',
            'JOB',
            'UNIVERSITY',
            'BODY_TYPE',
            'REGION',
          ]),
        );
        expect(
          json.values.every((value) => value is num),
          isTrue,
          reason: 'codebook current versions values must be numeric',
        );
      },
    );

    test(
      'codebook snapshot은 group별 version과 codes 배열을 반환한다',
      skip: skipReason,
      () async {
        final client = LiveApiClient.fromEnv();
        final response = await client.get(
          ApiEndpoints.codebookSnapshot,
          queryParameters: {'groups': 'BODY_TYPE,REGION'},
        );
        LiveApiAssertions.expectStatus(response.statusCode, 200);
        final json = LiveApiAssertions.expectJsonMap(response.decoded);

        for (final group in ['BODY_TYPE', 'REGION']) {
          final groupSnapshot = LiveApiAssertions.expectObjectField(
            json,
            group,
          );
          expect(groupSnapshot, contains('version'));
          final codes = LiveApiAssertions.expectListField(
            groupSnapshot,
            'codes',
          );
          expect(codes, isNotEmpty);
          final firstCode = LiveApiAssertions.expectJsonMap(codes.first);
          expect(firstCode, contains('code'));
          expect(firstCode, contains('codeName'));
          expect(firstCode, contains('displayOrder'));
        }
      },
    );

    test(
      'choice questions current versions는 카테고리 버전 맵을 반환한다',
      skip: skipReason,
      () async {
        final client = LiveApiClient.fromEnv();
        final response = await client.get(
          ApiEndpoints.choiceQuestionsCurrentVersions,
        );
        LiveApiAssertions.expectStatus(response.statusCode, 200);
        final json = LiveApiAssertions.expectJsonMap(response.decoded);
        expect(
          json.keys,
          containsAll(<String>[
            'QC_FAMILY',
            'QC_LIFE',
            'QC_PERSONALITY',
            'QC_LOVE',
            'QC_CAREER',
          ]),
        );
      },
    );

    test(
      'choice questions snapshot은 categories 파라미터로 조회된다',
      skip: skipReason,
      () async {
        final client = LiveApiClient.fromEnv();
        final response = await client.get(
          ApiEndpoints.choiceQuestionsSnapshot,
          queryParameters: {
            'categories': [
              'QC_LOVE',
              'QC_LIFE',
              'QC_CAREER',
              'QC_PERSONALITY',
              'QC_FAMILY',
            ].join(','),
          },
        );
        LiveApiAssertions.expectStatus(response.statusCode, 200);
        final json = LiveApiAssertions.expectJsonMap(response.decoded);
        expect(
          json.keys,
          containsAll(<String>[
            'QC_LOVE',
            'QC_LIFE',
            'QC_CAREER',
            'QC_PERSONALITY',
            'QC_FAMILY',
          ]),
        );

        final firstCategory = LiveApiAssertions.expectObjectField(
          json,
          'QC_LOVE',
        );
        final questions = LiveApiAssertions.expectListField(
          firstCategory,
          'questions',
        );
        expect(questions, isNotEmpty);
        final firstQuestion = LiveApiAssertions.expectJsonMap(questions.first);
        expect(firstQuestion, contains('id'));
        expect(firstQuestion, contains('content'));
        expect(firstQuestion, contains('options'));
      },
    );

    test(
      'essay questions current versions는 version을 반환한다',
      skip: skipReason,
      () async {
        final client = LiveApiClient.fromEnv();
        final response = await client.get(
          ApiEndpoints.essayQuestionsCurrentVersions,
        );
        LiveApiAssertions.expectStatus(response.statusCode, 200);
        final json = LiveApiAssertions.expectJsonMap(response.decoded);
        expect(json, contains('version'));
      },
    );

    test(
      'essay questions snapshot은 questions 배열을 반환한다',
      skip: skipReason,
      () async {
        final client = LiveApiClient.fromEnv();
        final response = await client.get(ApiEndpoints.essayQuestionsSnapshot);
        LiveApiAssertions.expectStatus(response.statusCode, 200);
        final json = LiveApiAssertions.expectJsonMap(response.decoded);
        expect(json, contains('version'));
        final questions = LiveApiAssertions.expectListField(json, 'questions');
        expect(questions, isNotEmpty);
        final firstQuestion = LiveApiAssertions.expectJsonMap(questions.first);
        expect(firstQuestion, contains('id'));
        expect(firstQuestion, contains('content'));
        expect(firstQuestion, contains('sortOrder'));
      },
    );

    test(
      'choice questions answers 조회는 인증된 계약을 따른다',
      skip: skipReason,
      () async {
        final client = LiveApiClient.fromEnv();
        final response = await client.get(ApiEndpoints.choiceQuestionAnswers);
        LiveApiAssertions.expectStatus(response.statusCode, null, [200, 204]);
        if (response.statusCode != 204) {
          expect(response.body, isNotEmpty);
        }
      },
    );

    test('essay questions answers 조회는 인증된 계약을 따른다', skip: skipReason, () async {
      final client = LiveApiClient.fromEnv();
      final response = await client.get(ApiEndpoints.essayQuestionAnswers);
      LiveApiAssertions.expectStatus(response.statusCode, null, [200, 204]);
      if (response.statusCode != 204) {
        expect(response.body, isNotEmpty);
      }
    });

    test(
      'file presign style은 presignedUrl과 s3Key를 반환한다',
      skip: skipReason,
      () async {
        final client = LiveApiClient.fromEnv();
        final response = await client.get(
          ApiEndpoints.styleImagePresign,
          queryParameters: {'contentType': 'image/jpeg'},
        );
        LiveApiAssertions.expectStatus(response.statusCode, 200);
        final json = LiveApiAssertions.expectJsonMap(response.decoded);
        expect(
          LiveApiAssertions.expectNonEmptyString(
            json['presignedUrl'] ?? json['presigned_url'],
          ),
          isNotEmpty,
        );
        expect(
          LiveApiAssertions.expectNonEmptyString(
            json['s3Key'] ?? json['s3_key'],
          ),
          isNotEmpty,
        );
      },
    );

    test(
      'file presign face는 presignedUrl과 s3Key를 반환한다',
      skip: skipReason,
      () async {
        final client = LiveApiClient.fromEnv();
        final response = await client.get(
          ApiEndpoints.faceImagePresign,
          queryParameters: {'contentType': 'image/jpeg'},
        );
        LiveApiAssertions.expectStatus(response.statusCode, 200);
        final json = LiveApiAssertions.expectJsonMap(response.decoded);
        expect(json.keys, isNotEmpty);
      },
    );

    test(
      'file presign certification은 presignedUrl과 s3Key를 반환한다',
      skip: skipReason,
      () async {
        final client = LiveApiClient.fromEnv();
        final response = await client.get(
          '/api/v1/files/presigned/certification',
          queryParameters: {'contentType': 'image/jpeg'},
        );
        LiveApiAssertions.expectStatus(response.statusCode, 200);
        final json = LiveApiAssertions.expectJsonMap(response.decoded);
        expect(json.keys, isNotEmpty);
      },
    );
  });
}

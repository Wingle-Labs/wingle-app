import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/common/constants/api_paths.dart';

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

Future<Map<String, dynamic>> _loadCodebookSnapshot(LiveApiClient client) async {
  final response = await client.get(
    ApiEndpoints.codebookSnapshot,
    queryParameters: {'groups': 'BODY_TYPE,REGION,JOB,UNIVERSITY'},
  );
  LiveApiAssertions.expectStatus(response.statusCode, 200);
  return LiveApiAssertions.expectJsonMap(response.decoded);
}

Future<Map<String, dynamic>> _loadTermsSnapshot(LiveApiClient client) async {
  final response = await client.get(ApiEndpoints.termsSnapshot);
  LiveApiAssertions.expectStatus(response.statusCode, 200);
  return LiveApiAssertions.expectJsonMap(response.decoded);
}

void main() {
  final skipReason = LiveApiEnv.hasRequiredConfig()
      ? null
      : LiveApiEnv.missingConfigMessage([
          LiveApiEnv.baseUrlKey,
          LiveApiEnv.accessTokenKey,
          LiveApiEnv.accountIdKey,
          LiveApiEnv.accountPasswordKey,
        ]);

  group('Live API - authenticated contract', () {
    test(
      'login은 phoneNumber/password payload를 받는다',
      skip: _skipIfMissing([
        LiveApiEnv.loginPhoneNumberKey,
        LiveApiEnv.loginPasswordKey,
      ]),
      () async {
        final client = LiveApiClient.fromEnv();
        final response = await client.post(
          ApiEndpoints.authLogin,
          includeAuth: false,
          body: {
            'phoneNumber': LiveApiEnv.get(LiveApiEnv.loginPhoneNumberKey),
            'password': LiveApiEnv.get(LiveApiEnv.loginPasswordKey),
          },
        );

        LiveApiAssertions.expectStatus(response.statusCode, 200);
        final json = LiveApiAssertions.expectJsonMap(response.decoded);
        expect(json.keys, contains('accessToken'));
        expect(json.keys, contains('refreshToken'));
      },
    );

    test(
      'reissue는 refresh token으로 토큰을 재발급한다',
      skip: _skipIfMissing([LiveApiEnv.refreshTokenKey]),
      () async {
        final client = LiveApiClient.fromEnv();
        final response = await client.post(
          ApiEndpoints.authReissue,
          includeAuth: false,
          headers: {
            'Authorization':
                'Bearer ${LiveApiEnv.get(LiveApiEnv.refreshTokenKey)}',
          },
        );

        LiveApiAssertions.expectStatus(response.statusCode, 200);
        final json = LiveApiAssertions.expectJsonMap(response.decoded);
        expect(json.keys, contains('accessToken'));
        expect(json.keys, contains('refreshToken'));
      },
    );

    test(
      'signup terms는 UUID와 agreements 배열을 전송한다',
      skip: _skipIfMissing([LiveApiEnv.signupUuidKey]),
      () async {
        final client = LiveApiClient.fromEnv();
        final terms = await _loadTermsSnapshot(client);
        final agreements = LiveApiAssertions.expectListField(terms, 'terms')
            .take(2)
            .map((term) {
              final json = LiveApiAssertions.expectJsonMap(term);
              return {
                'type': json['type'],
                'version': LiveApiAssertions.expectInt(json['version']),
                'isRequired': json['isRequired'],
                'agreed': true,
              };
            })
            .toList();

        final response = await client.post(
          ApiEndpoints.signupTerms,
          body: {
            'UUID': LiveApiEnv.get(LiveApiEnv.signupUuidKey),
            'agreements': agreements,
          },
        );

        LiveApiAssertions.expectStatus(response.statusCode, 200);
      },
    );

    test(
      'signup profile은 nickname/residenceCode/height/bodyTypeCode를 받는다',
      skip: skipReason,
      () async {
        final client = LiveApiClient.fromEnv();
        final codebook = await _loadCodebookSnapshot(client);
        final bodyTypeSnapshot = LiveApiAssertions.expectObjectField(
          codebook,
          'BODY_TYPE',
        );
        final codes = LiveApiAssertions.expectListField(
          bodyTypeSnapshot,
          'codes',
        );
        final firstBodyType = LiveApiAssertions.expectJsonMap(codes.first);
        final regionSnapshot = LiveApiAssertions.expectObjectField(
          codebook,
          'REGION',
        );
        final regionCodes = LiveApiAssertions.expectListField(
          regionSnapshot,
          'codes',
        );
        final firstRegion = LiveApiAssertions.expectJsonMap(regionCodes.first);

        final nicknameResponse = await client.get(
          ApiEndpoints.signupNicknameRandom,
        );
        LiveApiAssertions.expectStatus(nicknameResponse.statusCode, 200);
        final nicknameJson = LiveApiAssertions.expectJsonMap(
          nicknameResponse.decoded,
        );
        final nickname = LiveApiAssertions.expectNonEmptyString(
          nicknameJson['nickname'],
        );

        final response = await client.post(
          ApiEndpoints.signupProfile,
          body: {
            'nickname': nickname,
            'residenceCode': firstRegion['code'],
            'height': 170,
            'bodyTypeCode': firstBodyType['code'],
          },
        );

        LiveApiAssertions.expectStatus(response.statusCode, 200);
      },
    );

    test(
      'signup password는 UUID와 password를 받는다',
      skip: _skipIfMissing([
        LiveApiEnv.signupUuidKey,
        LiveApiEnv.signupPasswordKey,
      ]),
      () async {
        final client = LiveApiClient.fromEnv();
        final response = await client.post(
          ApiEndpoints.signupPassword,
          body: {
            'UUID': LiveApiEnv.get(LiveApiEnv.signupUuidKey),
            'password': LiveApiEnv.get(LiveApiEnv.signupPasswordKey),
          },
        );

        LiveApiAssertions.expectStatus(response.statusCode, null, [200, 201]);
      },
    );

    test(
      'signup identity verification은 본인인증 정보를 저장한다',
      skip: _skipIfMissing([
        LiveApiEnv.signupUuidKey,
        LiveApiEnv.identityNameKey,
        LiveApiEnv.identityPhoneNumberKey,
        LiveApiEnv.identityCiKey,
        LiveApiEnv.identityGenderKey,
        LiveApiEnv.identityBirthKey,
        LiveApiEnv.identityAgeKey,
      ]),
      () async {
        final client = LiveApiClient.fromEnv();
        final response = await client.post(
          ApiEndpoints.signupIdentityVerification,
          body: {
            'name': LiveApiEnv.get(LiveApiEnv.identityNameKey),
            'isForeigner': false,
            'phoneNumber': LiveApiEnv.get(LiveApiEnv.identityPhoneNumberKey),
            'CI': LiveApiEnv.get(LiveApiEnv.identityCiKey),
            'gender': LiveApiEnv.get(LiveApiEnv.identityGenderKey),
            'UUID': LiveApiEnv.get(LiveApiEnv.signupUuidKey),
            'age': LiveApiEnv.getInt(LiveApiEnv.identityAgeKey),
            'birth': LiveApiEnv.get(LiveApiEnv.identityBirthKey),
          },
        );

        LiveApiAssertions.expectStatus(response.statusCode, 200);
      },
    );

    test(
      'user profile 수정은 SignupProfileRequest 형태를 따른다',
      skip: skipReason,
      () async {
        final client = LiveApiClient.fromEnv();
        final codebook = await _loadCodebookSnapshot(client);
        final bodyTypeSnapshot = LiveApiAssertions.expectObjectField(
          codebook,
          'BODY_TYPE',
        );
        final bodyTypeCodes = LiveApiAssertions.expectListField(
          bodyTypeSnapshot,
          'codes',
        );
        final firstBodyType = LiveApiAssertions.expectJsonMap(
          bodyTypeCodes.first,
        );
        final regionSnapshot = LiveApiAssertions.expectObjectField(
          codebook,
          'REGION',
        );
        final regionCodes = LiveApiAssertions.expectListField(
          regionSnapshot,
          'codes',
        );
        final firstRegion = LiveApiAssertions.expectJsonMap(regionCodes.first);

        final response = await client.put(
          ApiEndpoints.userProfile,
          body: {
            'nickname':
                LiveApiEnv.get(LiveApiEnv.profileNicknameKey) ?? '테스트닉네임',
            'residenceCode':
                LiveApiEnv.get(LiveApiEnv.profileResidenceCodeKey) ??
                firstRegion['code'],
            'height': LiveApiEnv.getInt(LiveApiEnv.profileHeightKey) ?? 170,
            'bodyTypeCode':
                LiveApiEnv.get(LiveApiEnv.profileBodyTypeCodeKey) ??
                firstBodyType['code'],
          },
        );

        LiveApiAssertions.expectStatus(response.statusCode, 200);
      },
    );

    test('job profile 등록은 company/occupation을 받는다', skip: skipReason, () async {
      final client = LiveApiClient.fromEnv();
      final response = await client.post(
        ApiEndpoints.profileJob,
        body: {
          'company': LiveApiEnv.get(LiveApiEnv.profileCompanyKey) ?? '테스트회사',
          'occupation':
              LiveApiEnv.get(LiveApiEnv.profileOccupationKey) ?? 'J103',
        },
      );
      LiveApiAssertions.expectStatus(response.statusCode, null, [200, 201]);
    });

    test(
      'education profile 등록은 educationLevel을 받는다',
      skip: skipReason,
      () async {
        final client = LiveApiClient.fromEnv();
        final response = await client.post(
          ApiEndpoints.profileEducation,
          body: {
            'educationLevel':
                LiveApiEnv.get(LiveApiEnv.profileEducationLevelKey) ??
                'UNIVERSITY',
            if (LiveApiEnv.get(LiveApiEnv.profileUniversityKey) != null)
              'university': LiveApiEnv.get(LiveApiEnv.profileUniversityKey),
          },
        );
        LiveApiAssertions.expectStatus(response.statusCode, null, [200, 201]);
      },
    );

    test(
      'profile detail 등록은 mbti/selfIntroduction/photo keys를 받는다',
      skip: skipReason,
      () async {
        final client = LiveApiClient.fromEnv();
        final response = await client.post(
          ApiEndpoints.profileDetail,
          body: {
            'mbti': LiveApiEnv.get(LiveApiEnv.profileMbtiKey) ?? 'ENFP',
            'selfIntroduction':
                LiveApiEnv.get(LiveApiEnv.profileIntroductionKey) ??
                'live contract test',
            'subStylePhotoKeys': <String>[],
            'subFacePhotoKeys': <String>[],
          },
        );

        LiveApiAssertions.expectStatus(response.statusCode, 200);
      },
    );

    test('approval request는 인증된 사용자에 대해 동작한다', skip: skipReason, () async {
      final client = LiveApiClient.fromEnv();
      final response = await client.post(ApiEndpoints.profileApprovalRequest);
      LiveApiAssertions.expectStatus(response.statusCode, 200);
    });

    test('reapply는 인증된 사용자에 대해 동작한다', skip: skipReason, () async {
      final client = LiveApiClient.fromEnv();
      final response = await client.post(ApiEndpoints.profileReapply);
      LiveApiAssertions.expectStatus(response.statusCode, 200);
    });

    test(
      'choice answers 저장은 snapshot 기반 payload를 허용한다',
      skip: skipReason,
      () async {
        final client = LiveApiClient.fromEnv();
        final snapshot = await client.get(
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
        LiveApiAssertions.expectStatus(snapshot.statusCode, 200);
        final json = LiveApiAssertions.expectJsonMap(snapshot.decoded);
        final firstCategory = LiveApiAssertions.expectObjectField(
          json,
          'QC_LOVE',
        );
        final questions = LiveApiAssertions.expectListField(
          firstCategory,
          'questions',
        );
        final firstQuestion = LiveApiAssertions.expectJsonMap(questions.first);
        final firstOption = LiveApiAssertions.expectJsonMap(
          LiveApiAssertions.expectListField(firstQuestion, 'options').first,
        );

        final response = await client.post(
          ApiEndpoints.choiceQuestionAnswers,
          body: {
            'answers': [
              {
                'questionId': LiveApiAssertions.expectInt(firstQuestion['id']),
                'optionId': LiveApiAssertions.expectInt(firstOption['id']),
              },
            ],
          },
        );

        LiveApiAssertions.expectStatus(response.statusCode, 200);
      },
    );

    test(
      'essay answers 저장은 snapshot 기반 payload를 허용한다',
      skip: skipReason,
      () async {
        final client = LiveApiClient.fromEnv();
        final snapshot = await client.get(ApiEndpoints.essayQuestionsSnapshot);
        LiveApiAssertions.expectStatus(snapshot.statusCode, 200);
        final json = LiveApiAssertions.expectJsonMap(snapshot.decoded);
        final questions = LiveApiAssertions.expectListField(json, 'questions');
        final firstQuestion = LiveApiAssertions.expectJsonMap(questions.first);

        final response = await client.post(
          ApiEndpoints.essayQuestionAnswers,
          body: {
            'answers': [
              {
                'questionId': LiveApiAssertions.expectInt(firstQuestion['id']),
                'content': 'live contract test answer',
              },
            ],
          },
        );

        LiveApiAssertions.expectStatus(response.statusCode, 200);
      },
    );

    test(
      'contacts 업로드는 phoneNumbers 배열을 받는다',
      skip: _skipIfMissing([LiveApiEnv.contactPhoneNumbersKey]),
      () async {
        final client = LiveApiClient.fromEnv();
        final phoneNumbers = LiveApiEnv.get(LiveApiEnv.contactPhoneNumbersKey)!
            .split(',')
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toList(growable: false);

        final response = await client.post(
          ApiEndpoints.contacts,
          body: {'phoneNumbers': phoneNumbers},
        );

        LiveApiAssertions.expectStatus(response.statusCode, 200);
      },
    );

    test(
      'FCM 토큰 등록은 token 문자열을 받는다',
      skip: _skipIfMissing([LiveApiEnv.fcmTokenKey]),
      () async {
        final client = LiveApiClient.fromEnv();
        final token = LiveApiEnv.get(LiveApiEnv.fcmTokenKey)!;

        final response = await client.post(
          ApiEndpoints.notificationToken,
          body: {'token': token},
        );

        LiveApiAssertions.expectStatus(response.statusCode, 200);
      },
    );
  });
}

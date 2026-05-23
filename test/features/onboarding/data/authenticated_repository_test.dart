import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/onboarding/data/file_repository_impl.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/data/profile_repository_impl.dart';
import 'package:wingle/features/onboarding/data/question_repository_impl.dart';
import 'package:wingle/features/onboarding/data/signup_repository_impl.dart';
import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';
import 'package:wingle/features/onboarding/domain/model/question/question_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const baseUrl = 'https://api.example.com';
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('wingle-auth-headers-test');
    Hive.init(tempDir.path);

    final key = Hive.generateSecureKey();
    await HiveUtil.initialize(HiveAesCipher(key));
    await HiveUtil.write(
      key: HiveLoginBox.accessToken,
      value: 'test-access-token',
    );
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('SignupRepositoryImpl은 인증 헤더를 붙여 비밀번호를 등록한다', () async {
    late Map<String, dynamic> body;

    final client = MockClient((request) async {
      expect(request.headers['Authorization'], 'Bearer test-access-token');
      expect(request.method, 'POST');
      expect(request.url.path, '/api/v1/auth/signup/password');

      body = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response('', 200);
    });

    final repository = SignupRepositoryImpl(client: client, baseUrl: baseUrl);

    await repository.submitPassword(uuid: 'device-uuid', password: '!abc1234');

    expect(body, {'password': '!abc1234', 'UUID': 'device-uuid'});
  });

  test('ProfileRepositoryImpl은 인증 헤더를 붙여 닉네임을 조회한다', () async {
    final client = MockClient((request) async {
      expect(request.headers['Authorization'], 'Bearer test-access-token');
      expect(request.method, 'GET');
      expect(request.url.path, '/api/v1/auth/signup/nickname/random');
      return http.Response.bytes(
        utf8.encode('{"nickname":"${MockProfileRepository.mockNickname}"}'),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });

    final repository = ProfileRepositoryImpl(client: client, baseUrl: baseUrl);

    final nickname = await repository.fetchRandomNickname();

    expect(nickname, MockProfileRepository.mockNickname);
  });

  test('ProfileRepositoryImpl은 인증 헤더를 붙여 기본 프로필을 등록한다', () async {
    late Map<String, dynamic> body;

    final client = MockClient((request) async {
      expect(request.headers['Authorization'], 'Bearer test-access-token');
      expect(request.method, 'POST');
      expect(request.url.path, '/api/v1/auth/signup/profile');
      body = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response('', 200);
    });

    final repository = ProfileRepositoryImpl(client: client, baseUrl: baseUrl);

    await repository.submitBasicProfile(
      nickname: MockProfileRepository.mockNickname,
      residence: const ResidenceCode(
        level1: '370',
        level2: '37080',
        level3: '37080412',
      ),
      height: 170,
      bodyTypeCode: 'BT_M_002',
    );

    expect(body, {
      'nickname': MockProfileRepository.mockNickname,
      'residenceCode': '37080412',
      'height': 170,
      'bodyTypeCode': 'BT_M_002',
    });
  });

  test('QuestionRepositoryImpl은 인증 헤더를 붙여 질문 목록을 조회한다', () async {
    final client = MockClient((request) async {
      expect(request.headers['Authorization'], 'Bearer test-access-token');
      expect(request.method, 'GET');
      expect(request.url.path, '/api/v1/choice-questions/snapshot');
      return http.Response.bytes(
        utf8.encode(
          jsonEncode({
            'QC_LOVE': {
              'version': 1,
              'questions': [
                {
                  'id': 1,
                  'content': '여름 vs 겨울',
                  'options': [
                    {'id': 1, 'content': '여름'},
                    {'id': 2, 'content': '겨울'},
                  ],
                },
              ],
            },
          }),
        ),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });

    final repository = QuestionRepositoryImpl(client: client, baseUrl: baseUrl);

    final questions = await repository.fetchQuestions(
      type: QuestionType.objective,
    );

    expect(questions, hasLength(1));
    expect(questions.first.id, '1');
  });

  test('QuestionRepositoryImpl은 인증 헤더를 붙여 객관식 답변을 등록한다', () async {
    late Map<String, dynamic> body;

    final client = MockClient((request) async {
      expect(request.headers['Authorization'], 'Bearer test-access-token');
      expect(request.method, 'POST');
      expect(request.url.path, '/api/v1/choice-questions/answers');
      body = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response('', 200);
    });

    final repository = QuestionRepositoryImpl(client: client, baseUrl: baseUrl);

    await repository.submitObjectiveAnswers(
      answers: const ObjectiveQuestionAnswers(
        datingAnswers: [
          ObjectiveQuestionAnswer(questionId: 1, selectedOptionId: 2),
        ],
        lifeStyleAnswers: [
          ObjectiveQuestionAnswer(questionId: 5, selectedOptionId: 3),
        ],
        careerFinanceAnswers: [
          ObjectiveQuestionAnswer(questionId: 11, selectedOptionId: 4),
        ],
        personalityAnswers: [
          ObjectiveQuestionAnswer(questionId: 17, selectedOptionId: 2),
        ],
        familyAnswers: [
          ObjectiveQuestionAnswer(questionId: 23, selectedOptionId: 5),
        ],
      ),
    );

    expect(body, {
      'answers': [
        {'questionId': 1, 'optionId': 2},
        {'questionId': 5, 'optionId': 3},
        {'questionId': 11, 'optionId': 4},
        {'questionId': 17, 'optionId': 2},
        {'questionId': 23, 'optionId': 5},
      ],
    });
  });

  test('FileRepositoryImpl은 인증 헤더를 붙여 프로필 이미지 presign을 발급한다', () async {
    final client = MockClient((request) async {
      expect(request.headers['Authorization'], 'Bearer test-access-token');
      expect(request.method, 'GET');
      expect(request.url.path, '/api/v1/files/presigned/style');
      expect(request.url.queryParameters['contentType'], 'image/png');
      return http.Response(
        jsonEncode({
          'presigned_url': 'https://mock-upload.example.com/profile.png',
          's3_key': 'users/1/profile/original/profile.png',
        }),
        200,
      );
    });

    final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

    final result = await repository.createProfileImagePresignedUrl(
      contentType: 'image/png',
    );

    expect(result.presignedUrl, 'https://mock-upload.example.com/profile.png');
  });

  test('FileRepositoryImpl은 Swagger에 없는 업로드 presign을 호출하지 않는다', () async {
    final client = MockClient((_) async => http.Response('', 500));
    final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

    expect(
      () => repository.createUploadPresign(
        fileName: 'profile.jpg',
        contentType: 'image/jpeg',
        size: 345678,
        purpose: 'PROFILE_IMAGE',
      ),
      throwsUnsupportedError,
    );
  });

  test('FileRepositoryImpl은 Swagger에 없는 조회용 presigned url을 호출하지 않는다', () async {
    final client = MockClient((_) async => http.Response('', 500));
    final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

    expect(
      () => repository.createPresignedUrl(fileId: 'file_01', expiresIn: 120),
      throwsUnsupportedError,
    );
  });

  test('FileRepositoryImpl은 Swagger에 없는 파일 삭제를 호출하지 않는다', () async {
    final client = MockClient((_) async => http.Response('', 500));
    final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

    expect(() => repository.deleteFile('file_01'), throwsUnsupportedError);
  });
}

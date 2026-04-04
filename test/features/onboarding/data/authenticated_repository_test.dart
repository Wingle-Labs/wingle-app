import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/onboarding/data/file_repository_impl.dart';
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
      expect(request.url.path, '/api/v1/signup/nickname/random');
      return http.Response.bytes(
        utf8.encode('{"nickname":"달콤한 사탕 멜론"}'),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });

    final repository = ProfileRepositoryImpl(client: client, baseUrl: baseUrl);

    final nickname = await repository.fetchRandomNickname();

    expect(nickname, '달콤한 사탕 멜론');
  });

  test('ProfileRepositoryImpl은 인증 헤더를 붙여 기본 프로필을 등록한다', () async {
    late Map<String, dynamic> body;

    final client = MockClient((request) async {
      expect(request.headers['Authorization'], 'Bearer test-access-token');
      expect(request.method, 'POST');
      expect(request.url.path, '/api/v1/signup/profile');
      body = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response('', 200);
    });

    final repository = ProfileRepositoryImpl(client: client, baseUrl: baseUrl);

    await repository.submitBasicProfile(
      nickname: '달콤한 사탕 멜론',
      residence: const ResidenceCode(
        level1: '370',
        level2: '37080',
        level3: '37080412',
      ),
      height: 170,
      bodyType: '보통',
    );

    expect(body, {
      'nickname': '달콤한 사탕 멜론',
      'residence': {'level1': '370', 'level2': '37080', 'level3': '37080412'},
      'height': 170,
      'bodyType': '보통',
    });
  });

  test('QuestionRepositoryImpl은 인증 헤더를 붙여 질문 목록을 조회한다', () async {
    final client = MockClient((request) async {
      expect(request.headers['Authorization'], 'Bearer test-access-token');
      expect(request.method, 'GET');
      expect(request.url.path, '/api/v1/questions');
      expect(request.url.queryParameters['type'], 'OBJECTIVE');
      return http.Response.bytes(
        utf8.encode(
          jsonEncode({
            'questions': [
              {
                'id': '1',
                'type': 'OBJECTIVE',
                'category': 'love',
                'content': '여름 vs 겨울',
                'options': [
                  {'id': 1, 'order': 1, 'content': '여름'},
                  {'id': 2, 'order': 2, 'content': '겨울'},
                ],
              },
            ],
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
      expect(request.url.path, '/api/v1/users/objective_questions/answer');
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
      'datingAnswers': [
        {'questionId': 1, 'selectedOptionId': 2},
      ],
      'lifeStyleAnswers': [
        {'questionId': 5, 'selectedOptionId': 3},
      ],
      'careerFinanceAnswers': [
        {'questionId': 11, 'selectedOptionId': 4},
      ],
      'personalityAnswers': [
        {'questionId': 17, 'selectedOptionId': 2},
      ],
      'familyAnswers': [
        {'questionId': 23, 'selectedOptionId': 5},
      ],
    });
  });

  test('FileRepositoryImpl은 인증 헤더를 붙여 프로필 이미지 presign을 발급한다', () async {
    final client = MockClient((request) async {
      expect(request.headers['Authorization'], 'Bearer test-access-token');
      expect(request.method, 'POST');
      expect(request.url.path, '/api/v1/files/presigned/profile');
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

  test('FileRepositoryImpl은 인증 헤더를 붙여 업로드 presign을 발급한다', () async {
    late Map<String, dynamic> body;

    final client = MockClient((request) async {
      expect(request.headers['Authorization'], 'Bearer test-access-token');
      expect(request.method, 'POST');
      expect(request.url.path, '/api/v1/files/uploads/presign');
      body = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response(
        jsonEncode({
          'uploadId': 'up_01',
          'method': 'PUT',
          'uploadUrl': 'https://mock-upload.example.com/up_01',
          'headers': {'Content-Type': 'image/jpeg'},
          'key': 'users/1/profile/original/profile.jpg',
          'expiresAt': '2026-02-02T10:20:00+09:00',
        }),
        200,
      );
    });

    final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

    final result = await repository.createUploadPresign(
      fileName: 'profile.jpg',
      contentType: 'image/jpeg',
      size: 345678,
      purpose: 'PROFILE_IMAGE',
      checksum: 'checksum-123',
    );

    expect(body, {
      'fileName': 'profile.jpg',
      'contentType': 'image/jpeg',
      'size': 345678,
      'purpose': 'PROFILE_IMAGE',
      'checksum': 'checksum-123',
    });
    expect(result.uploadId, 'up_01');
  });

  test('FileRepositoryImpl은 인증 헤더를 붙여 조회용 presigned url을 발급한다', () async {
    final client = MockClient((request) async {
      expect(request.headers['Authorization'], 'Bearer test-access-token');
      expect(request.method, 'GET');
      expect(request.url.path, '/api/v1/files/file_01/presigned-url');
      expect(request.url.queryParameters['expiresIn'], '120');
      return http.Response(
        jsonEncode({
          'fileId': 'file_01',
          'url': 'https://mock-download.example.com/file_01',
          'expiresAt': '2026-02-02T09:55:00+09:00',
          'contentType': 'image/jpeg',
          'size': 345678,
        }),
        200,
      );
    });

    final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

    final result = await repository.createPresignedUrl(
      fileId: 'file_01',
      expiresIn: 120,
    );

    expect(result.fileId, 'file_01');
    expect(result.url, 'https://mock-download.example.com/file_01');
  });

  test('FileRepositoryImpl은 인증 헤더를 붙여 파일을 삭제한다', () async {
    final client = MockClient((request) async {
      expect(request.headers['Authorization'], 'Bearer test-access-token');
      expect(request.method, 'DELETE');
      expect(request.url.path, '/api/v1/files/file_01');
      return http.Response(
        jsonEncode({
          'fileId': 'file_01',
          'status': 'SOFT_DELETED',
          'deletedAt': '2026-02-02T10:05:12+09:00',
        }),
        200,
      );
    });

    final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

    final result = await repository.deleteFile('file_01');

    expect(result.fileId, 'file_01');
    expect(result.status, 'SOFT_DELETED');
  });
}

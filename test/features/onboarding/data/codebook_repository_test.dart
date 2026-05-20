import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wingle/features/onboarding/data/codebook_repository_impl.dart';

void main() {
  const baseUrl = 'https://api.example.com';

  group('CodebookRepositoryImpl', () {
    test('약관 스냅샷을 조회한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/terms/snapshot');
        return http.Response.bytes(
          utf8.encode(
            jsonEncode({
              'version': 1,
              'terms': [
                {
                  'type': 'TOS',
                  'content': '# 이용약관',
                  'isRequired': true,
                  'version': 1,
                },
              ],
            }),
          ),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final repository = CodebookRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      final snapshot = await repository.fetchTermsSnapshot();

      expect(snapshot.version, 1);
      expect(snapshot.terms.single.type, 'TOS');
    });

    test('공통 코드 스냅샷을 조회한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/codebook/snapshot');
        expect(request.url.queryParameters['groups'], 'BODY_TYPE');
        return http.Response.bytes(
          utf8.encode(
            jsonEncode({
              'BODY_TYPE': {
                'version': 1,
                'codes': [
                  {
                    'code': 'BT_F_001',
                    'codeName': '보통',
                    'parentCode': 'BT_FEMALE',
                  },
                ],
              },
            }),
          ),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final repository = CodebookRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      final snapshot = await repository.fetchCodebookSnapshot(
        groups: ['BODY_TYPE'],
      );

      expect(snapshot['BODY_TYPE']!.codes.single.code, 'BT_F_001');
    });

    test('객관식 질문 스냅샷을 조회한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/choice-questions/snapshot');
        expect(request.url.queryParameters['categories'], 'QC_LOVE');
        return http.Response.bytes(
          utf8.encode(
            jsonEncode({
              'QC_LOVE': {
                'version': 1,
                'questions': [
                  {
                    'id': 1,
                    'content': '좋아하는 데이트 장소는?',
                    'options': [
                      {'id': 1, 'content': '카페'},
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

      final repository = CodebookRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      final snapshot = await repository.fetchChoiceQuestionSnapshot(
        categories: ['QC_LOVE'],
      );

      expect(
        snapshot['QC_LOVE']!.questions.single.options.single.content,
        '카페',
      );
    });

    test('주관식 질문 스냅샷을 조회한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/essay-questions/snapshot');
        return http.Response.bytes(
          utf8.encode(
            jsonEncode({
              'version': 1,
              'questions': [
                {
                  'id': 1,
                  'content': '자신을 소개해주세요.',
                  'isRequire': true,
                  'sortOrder': 1,
                },
              ],
            }),
          ),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final repository = CodebookRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      final snapshot = await repository.fetchEssayQuestionSnapshot();

      expect(snapshot.questions.single.isRequired, isTrue);
    });
  });
}

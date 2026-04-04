import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wingle/features/onboarding/data/term_repository_impl.dart';
import 'package:wingle/features/onboarding/presentation/models/agreement_item.dart';

void main() {
  const baseUrl = 'https://api.example.com';

  test('submitAgreements는 UUID 대문자 키와 약관 배열을 전송한다', () async {
    late Map<String, dynamic> body;

    final client = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/api/v1/auth/signup/terms');
      body = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response('', 200);
    });

    final repository = TermRepositoryImpl(client: client, baseUrl: baseUrl);

    final result = await repository.submitAgreements(
      uuid: 'device-uuid',
      agreements: [
        AgreementItemModel(
          id: 1,
          title: '개인정보 처리방침',
          content: '내용',
          isRequired: true,
          version: '1.3',
          isChecked: true,
        ),
      ],
    );

    expect(result, isTrue);
    expect(body, {
      'UUID': 'device-uuid',
      'agreements': [
        {'Id': 1, 'version': '1.3', 'isRequired': true, 'agreed': true},
      ],
    });
  });
}

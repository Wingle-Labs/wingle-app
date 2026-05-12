import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wingle/features/onboarding/data/contact_repository_impl.dart';

void main() {
  test('연락처를 정규화해서 업로드한다', () async {
    late Map<String, dynamic> body;

    final client = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/api/v1/contacts');
      body = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response('', 200);
    });

    final repository = ContactRepositoryImpl(
      client: client,
      baseUrl: 'https://api.example.com',
    );

    await repository.uploadContacts(
      phoneNumbers: [' 010-9256-6504 ', '010-9256-6504'],
    );

    expect(body, {
      'phoneNumbers': ['010-9256-6504'],
    });
  });

  test('연락처 목록이 비어 있으면 업로드하지 않는다', () async {
    final client = MockClient((request) async {
      fail('invalid contact request should not hit network');
    });

    final repository = ContactRepositoryImpl(
      client: client,
      baseUrl: 'https://api.example.com',
    );

    expect(
      () => repository.uploadContacts(phoneNumbers: const <String>[]),
      throwsException,
    );
  });

  test('010-XXXX-XXXX 형식이 아니면 업로드하지 않는다', () async {
    final client = MockClient((request) async {
      fail('invalid contact request should not hit network');
    });

    final repository = ContactRepositoryImpl(
      client: client,
      baseUrl: 'https://api.example.com',
    );

    expect(
      () => repository.uploadContacts(phoneNumbers: ['01012345678']),
      throwsException,
    );
  });
}

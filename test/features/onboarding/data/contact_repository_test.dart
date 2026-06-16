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
      phoneNumbers: [' 010-9256-6504 ', '01092566504', '+82 10 9256 6504'],
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

  test('연락처 차단을 건너뛴다', () async {
    final client = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/api/v1/contacts/skip');
      expect(request.body, isEmpty);
      return http.Response('', 200);
    });

    final repository = ContactRepositoryImpl(
      client: client,
      baseUrl: 'https://api.example.com',
    );

    await repository.skipContacts();
  });

  test('유효하지 않은 번호는 제외하고 업로드한다', () async {
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
      phoneNumbers: ['invalid', '02-123-4567', '01012345678'],
    );

    expect(body, {
      'phoneNumbers': ['010-1234-5678'],
    });
  });

  test('정규화 가능한 번호가 하나도 없으면 업로드하지 않는다', () async {
    final client = MockClient((request) async {
      fail('invalid contact request should not hit network');
    });

    final repository = ContactRepositoryImpl(
      client: client,
      baseUrl: 'https://api.example.com',
    );

    expect(
      () => repository.uploadContacts(phoneNumbers: ['invalid']),
      throwsException,
    );
  });
}

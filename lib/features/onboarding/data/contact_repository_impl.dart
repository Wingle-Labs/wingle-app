import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/api_paths.dart';
import 'package:wingle/common/utils/api_request_headers.dart';
import 'package:wingle/features/onboarding/domain/repository/contact_repository.dart';

/// 연락처 Repository HTTP 구현.
class ContactRepositoryImpl implements ContactRepository {
  static final RegExp _phoneNumberPattern = RegExp(r'^010-\d{4}-\d{4}$');

  final http.Client _client;
  final String _baseUrl;

  /// 생성자
  ContactRepositoryImpl({required http.Client client, required String baseUrl})
    : _client = client,
      _baseUrl = baseUrl;

  @override
  Future<void> uploadContacts({required List<String> phoneNumbers}) async {
    final normalizedPhoneNumbers = _normalizePhoneNumbers(phoneNumbers);

    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiEndpoints.contacts}'),
      headers: ApiRequestHeaders.json(includeAuth: true),
      body: jsonEncode({'phoneNumbers': normalizedPhoneNumbers}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(ApiErrorMessages.uploadContactsFailed);
    }
  }

  @override
  Future<void> skipContacts() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiEndpoints.contactsSkip}'),
      headers: ApiRequestHeaders.auth(),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(ApiErrorMessages.uploadContactsFailed);
    }
  }

  List<String> _normalizePhoneNumbers(List<String> phoneNumbers) {
    final normalized = phoneNumbers.map((phoneNumber) => phoneNumber.trim());
    final uniquePhoneNumbers = normalized.toSet().toList(growable: false);

    if (uniquePhoneNumbers.isEmpty || uniquePhoneNumbers.length > 500) {
      throw Exception(ApiErrorMessages.uploadContactsFailed);
    }

    final hasInvalidPhoneNumber = uniquePhoneNumbers.any(
      (phoneNumber) => !_phoneNumberPattern.hasMatch(phoneNumber),
    );

    if (hasInvalidPhoneNumber) {
      throw Exception(ApiErrorMessages.uploadContactsFailed);
    }

    return uniquePhoneNumbers;
  }
}

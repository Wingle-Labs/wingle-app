import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/api_paths.dart';
import 'package:wingle/common/utils/api_error_response.dart';
import 'package:wingle/common/utils/api_request_headers.dart';
import 'package:wingle/features/onboarding/domain/repository/contact_repository.dart';

/// 연락처 Repository HTTP 구현.
class ContactRepositoryImpl implements ContactRepository {
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
      throw apiExceptionFromResponse(
        response,
        fallbackMessage: ApiErrorMessages.uploadContactsFailed,
      );
    }
  }

  @override
  Future<void> skipContacts() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiEndpoints.contactsSkip}'),
      headers: ApiRequestHeaders.auth(),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw apiExceptionFromResponse(
        response,
        fallbackMessage: ApiErrorMessages.uploadContactsFailed,
      );
    }
  }

  List<String> _normalizePhoneNumbers(List<String> phoneNumbers) {
    final uniquePhoneNumbers = phoneNumbers
        .map(_normalizePhoneNumber)
        .whereType<String>()
        .toSet()
        .toList(growable: false);

    if (uniquePhoneNumbers.isEmpty || uniquePhoneNumbers.length > 500) {
      throw Exception(ApiErrorMessages.uploadContactsFailed);
    }

    return uniquePhoneNumbers;
  }

  String? _normalizePhoneNumber(String phoneNumber) {
    final digits = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    late final String localNumber;

    if (digits.length == 11 && digits.startsWith('010')) {
      localNumber = digits;
    } else if (digits.length == 12 && digits.startsWith('8210')) {
      localNumber = '0${digits.substring(2)}';
    } else {
      return null;
    }

    return '${localNumber.substring(0, 3)}-'
        '${localNumber.substring(3, 7)}-'
        '${localNumber.substring(7)}';
  }
}

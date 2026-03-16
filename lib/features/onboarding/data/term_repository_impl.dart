import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/api_paths.dart';
import 'package:wingle/features/onboarding/data/term_dto.dart';
import 'package:wingle/features/onboarding/data/term_mapper.dart';
import 'package:wingle/features/onboarding/domain/repository/term_repository.dart';
import 'package:wingle/features/onboarding/presentation/models/agreement_item.dart';

/// [TermRepository]의 HTTP 기반 구현체.
///
/// - 서버로부터 약관 데이터를 조회한다.
/// - DTO → Presentation 모델 변환을 내부에서 수행한다.
class TermRepositoryImpl implements TermRepository {
  final http.Client _client;
  final String _baseUrl;

  /// 생성자.
  ///
  /// [client] : HTTP 통신 객체
  /// [baseUrl] : API Base URL
  TermRepositoryImpl({required http.Client client, required String baseUrl})
    : _client = client,
      _baseUrl = baseUrl;

  @override
  Future<List<AgreementItemModel>> fetchTerms() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl${ApiEndpoints.terms}'),
    );

    if (response.statusCode != 200) {
      throw Exception(ApiErrorMessages.fetchTermsFailed);
    }

    final Map<String, dynamic> decoded =
        jsonDecode(response.body) as Map<String, dynamic>;

    final List<dynamic> rawTerms = decoded['terms'] as List<dynamic>;

    final dtos = rawTerms
        .map((e) => TermDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return dtos.map(TermMapper.toAgreementItem).toList();
  }

  @override
  Future<bool> submitAgreements({
    required String uuid,
    required List<AgreementItemModel> agreements,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/auth/signup/terms');

    final body = {
      "UUID": uuid,
      "agreements": agreements.map((e) {
        return {
          "Id": e.id,
          "version": e.version,
          "isRequired": e.isRequired,
          "agreed": e.isChecked,
        };
      }).toList(),
    };

    final response = await _client.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception(ApiErrorMessages.submitTermsFailed);
    }

    return true;
  }
}

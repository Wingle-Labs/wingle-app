import 'package:dio/dio.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/api_paths.dart';
import 'package:wingle/common/utils/api_request_headers.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_group.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_snapshot.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_version_map.dart';

/// 코드북 원격 데이터소스.
class CodebookRemoteDataSource {
  final Dio _dio;
  final String _baseUrl;
  final void Function(String message)? _logger;

  /// 생성자
  const CodebookRemoteDataSource({
    required Dio dio,
    required String baseUrl,
    void Function(String message)? logger,
  }) : _dio = dio,
       _baseUrl = baseUrl,
       _logger = logger;

  /// 현재 버전 조회.
  Future<CodebookVersionMap> fetchCurrentVersions() async {
    final response = await _getJson(ApiEndpoints.codebookCurrentVersions);
    return CodebookVersionMap.fromRemoteMap(response);
  }

  /// 스냅샷 조회.
  Future<Map<CodebookGroup, CodebookSnapshot>> fetchSnapshots(
    List<CodebookGroup> groups,
  ) async {
    final results = await Future.wait(
      groups.map((group) async {
        try {
          final response = await _getJson(
            ApiEndpoints.codebookSnapshot,
            queryParameters: {
              'groups': [group.code],
            },
          );
          final snapshot = response[group.code];
          if (snapshot is! Map) {
            return null;
          }
          return MapEntry(
            group,
            CodebookSnapshot.fromJson(
              Map<String, dynamic>.from(snapshot),
            ),
          );
        } catch (error) {
          _log(
            '[CodebookSync] snapshot fetch failed for ${group.code}: $error',
          );
          return null;
        }
      }),
    );

    final snapshots = <CodebookGroup, CodebookSnapshot>{};
    for (final entry in results) {
      if (entry != null) {
        snapshots[entry.key] = entry.value;
      }
    }

    if (snapshots.isEmpty && groups.isNotEmpty) {
      throw Exception(ApiErrorMessages.fetchCodebookFailed);
    }

    return snapshots;
  }

  Future<Map<String, dynamic>> _getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_baseUrl$path',
      queryParameters: queryParameters,
      options: Options(headers: ApiRequestHeaders.auth()),
    );

    final data = response.data;
    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300 ||
        data == null) {
      throw Exception(ApiErrorMessages.fetchCodebookFailed);
    }

    return data;
  }

  void _log(String message) {
    _logger?.call(message);
  }
}

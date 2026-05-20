import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_remote_datasource.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_group.dart';

class _FakeAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) onFetch;

  _FakeAdapter(this.onFetch);

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return onFetch(options);
  }
}

void main() {
  test('CodebookRemoteDataSource는 current versions와 snapshot을 가져온다', () async {
    final dio = Dio();
    dio.httpClientAdapter = _FakeAdapter((options) async {
      if (options.path.endsWith('/current-versions')) {
        return ResponseBody.fromString(
          jsonEncode({'BODY_TYPE': 2}),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      }

      expect(options.queryParameters['groups'], 'BODY_TYPE');
      return ResponseBody.fromString(
        jsonEncode({
          'BODY_TYPE': {
            'version': 2,
            'codes': [
              {
                'code': 'BT_1',
                'codeName': 'A',
                'parentCode': null,
                'displayOrder': 1,
              },
            ],
          },
        }),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    });

    final dataSource = CodebookRemoteDataSource(
      dio: dio,
      baseUrl: 'https://api.example.com',
    );

    final versions = await dataSource.fetchCurrentVersions();
    final snapshots = await dataSource.fetchSnapshots([CodebookGroup.bodyType]);

    expect(versions.versions[CodebookGroup.bodyType], 2);
    expect(snapshots[CodebookGroup.bodyType]!.codes.single.code, 'BT_1');
  });
}

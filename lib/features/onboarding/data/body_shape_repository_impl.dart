import 'package:http/http.dart' as http;
import 'package:wingle/features/onboarding/data/codebook/codebook_local_datasource.dart';
import 'package:wingle/features/onboarding/domain/model/body_shape/body_shape_models.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_group.dart';
import 'package:wingle/features/onboarding/domain/repository/body_shape_repository.dart';

/// 체형 코드북 Repository HTTP 구현.
class BodyShapeRepositoryImpl implements BodyShapeRepository {
  final http.Client _client;
  final String _baseUrl;
  final CodebookLocalDataSource _localDataSource;

  /// 생성자
  BodyShapeRepositoryImpl({
    required http.Client client,
    required String baseUrl,
    CodebookLocalDataSource? localDataSource,
  }) : _client = client,
       _baseUrl = baseUrl,
       _localDataSource = localDataSource ?? CodebookLocalDataSource();

  @override
  BodyShapeCodebook fetchBodyShapeCodebook() {
    _client;
    _baseUrl;
    final codes = _localDataSource.loadCodes(CodebookGroup.bodyType);
    final codebook = BodyShapeCodebook.fromCodebookEntries(codes);

    if (codebook.maleOptions.isEmpty && codebook.femaleOptions.isEmpty) {
      throw StateError('BODY_TYPE codebook snapshot is empty.');
    }

    return codebook;
  }
}

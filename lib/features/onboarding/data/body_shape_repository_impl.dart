import 'package:http/http.dart' as http;
import 'package:wingle/features/onboarding/domain/model/body_shape/body_shape_models.dart';
import 'package:wingle/features/onboarding/domain/repository/body_shape_repository.dart';

/// 체형 코드북 Repository HTTP 구현.
///
/// 현재는 코드북 API가 확정되지 않아 mock 데이터와 동일한 구조를 반환한다.
class BodyShapeRepositoryImpl implements BodyShapeRepository {
  final http.Client _client;
  final String _baseUrl;

  /// 생성자
  BodyShapeRepositoryImpl({
    required http.Client client,
    required String baseUrl,
  }) : _client = client,
       _baseUrl = baseUrl;

  @override
  BodyShapeCodebook fetchBodyShapeCodebook() {
    // TODO: 코드북 API가 확정되면 네트워크 호출로 교체한다.
    // 현재는 UI 검증용 목업 구조를 유지한다.
    _client;
    _baseUrl;
    return BodyShapeCodebook.mock();
  }
}

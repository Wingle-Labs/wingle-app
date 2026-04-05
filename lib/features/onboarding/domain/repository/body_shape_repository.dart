import 'package:wingle/features/onboarding/domain/model/body_shape/body_shape_models.dart';

/// 체형 코드북 Repository 인터페이스.
abstract class BodyShapeRepository {
  /// 체형 코드북을 조회한다.
  BodyShapeCodebook fetchBodyShapeCodebook();
}

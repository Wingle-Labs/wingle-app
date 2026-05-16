import 'package:wingle/features/onboarding/domain/model/body_shape/body_shape_models.dart';
import 'package:wingle/features/onboarding/domain/repository/body_shape_repository.dart';

/// 체형 코드북 Repository Mock 구현.
class MockBodyShapeRepository implements BodyShapeRepository {
  @override
  BodyShapeCodebook fetchBodyShapeCodebook() {
    return BodyShapeCodebook.mock();
  }
}

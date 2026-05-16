import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/onboarding/data/mock/mock_body_shape_repository.dart';

void main() {
  test('MockBodyShapeRepository는 성별별 체형 옵션을 제공한다', () {
    final repository = MockBodyShapeRepository();
    final codebook = repository.fetchBodyShapeCodebook();

    expect(codebook.optionsForGender('male').map((e) => e.label).toList(), [
      '슬림',
      '보통',
      '탄탄',
      '체격 있음',
      '공개 안함',
    ]);
    expect(codebook.optionsForGender('female').map((e) => e.label).toList(), [
      '슬림',
      '보통',
      '볼륨',
      '체구 있음',
      '공개 안함',
    ]);
  });
}

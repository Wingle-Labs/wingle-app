import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/onboarding/domain/model/body_shape/body_shape_models.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_provider.dart';

void main() {
  test('BodyShapeCodebook는 성별에 따라 서로 다른 옵션을 반환한다', () {
    final codebook = BodyShapeCodebook.mock();

    expect(codebook.labelForGenderAndCode('male', 'slim'), '슬림');
    expect(codebook.labelForGenderAndCode('female', 'voluminous'), '볼륨');
    expect(codebook.optionsForGender('female').map((option) => option.label), [
      '슬림',
      '보통',
      '볼륨',
      '체구 있음',
      '공개 안함',
    ]);
    expect(codebook.optionsForGender('male').map((option) => option.label), [
      '슬림',
      '보통',
      '탄탄',
      '체격 있음',
      '공개 안함',
    ]);
  });

  test('basicProfileProvider는 체형 선택과 초기화를 지원한다', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(basicProfileProvider.notifier);

    expect(container.read(basicProfileProvider).bodyShapeCode, isNull);

    notifier.selectBodyShape('slim');
    expect(container.read(basicProfileProvider).bodyShapeCode, 'slim');

    notifier.reset();
    expect(container.read(basicProfileProvider).bodyShapeCode, isNull);
  });
}

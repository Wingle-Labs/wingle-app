import 'package:wingle/features/onboarding/domain/model/body_shape/body_shape_models.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';

/// BODY_TYPE 코드북을 실제 체형 컴포넌트용 모델로 변환한다.
BodyShapeCodebook mapBodyTypeCodebook(CodeSnapshot snapshot) {
  final maleOptions = <BodyShapeOption>[];
  final femaleOptions = <BodyShapeOption>[];

  for (var index = 0; index < snapshot.codes.length; index++) {
    final code = snapshot.codes[index];
    final order = code.displayOrder > 0 ? code.displayOrder : index + 1;
    final option = BodyShapeOption(
      code: code.code,
      label: code.codeName,
      order: order,
    );

    final parent = code.parentCode?.toUpperCase();
    if (parent == 'BT_MALE' || code.code.toUpperCase().startsWith('BT_M_')) {
      maleOptions.add(option);
    } else if (parent == 'BT_FEMALE' ||
        code.code.toUpperCase().startsWith('BT_F_')) {
      femaleOptions.add(option);
    }
  }

  maleOptions.sort((left, right) => left.order.compareTo(right.order));
  femaleOptions.sort((left, right) => left.order.compareTo(right.order));

  return BodyShapeCodebook(
    maleOptions: maleOptions,
    femaleOptions: femaleOptions,
  );
}

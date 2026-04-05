/// 체형 코드북 옵션.
class BodyShapeOption {
  /// 코드
  final String code;

  /// 표시 문구
  final String label;

  /// 표시 순서
  final int order;

  /// 생성자
  const BodyShapeOption({
    required this.code,
    required this.label,
    required this.order,
  });
}

/// 체형 코드북.
class BodyShapeCodebook {
  /// 남성 옵션 목록
  final List<BodyShapeOption> maleOptions;

  /// 여성 옵션 목록
  final List<BodyShapeOption> femaleOptions;

  /// 생성자
  const BodyShapeCodebook({
    required this.maleOptions,
    required this.femaleOptions,
  });

  /// 목업 코드북을 생성한다.
  factory BodyShapeCodebook.mock() {
    return const BodyShapeCodebook(
      maleOptions: [
        BodyShapeOption(code: 'slim', label: '슬림', order: 1),
        BodyShapeOption(code: 'normal', label: '보통', order: 2),
        BodyShapeOption(code: 'toned', label: '탄탄', order: 3),
        BodyShapeOption(code: 'built', label: '체격 있음', order: 4),
        BodyShapeOption(code: 'hidden', label: '공개 안함', order: 5),
      ],
      femaleOptions: [
        BodyShapeOption(code: 'slim', label: '슬림', order: 1),
        BodyShapeOption(code: 'normal', label: '보통', order: 2),
        BodyShapeOption(code: 'voluminous', label: '볼륨', order: 3),
        BodyShapeOption(code: 'petite', label: '체구 있음', order: 4),
        BodyShapeOption(code: 'hidden', label: '공개 안함', order: 5),
      ],
    );
  }

  /// 성별에 맞는 옵션 목록을 반환한다.
  List<BodyShapeOption> optionsForGender(String? gender) {
    final options = switch (gender?.toLowerCase()) {
      'female' => femaleOptions,
      'male' => maleOptions,
      _ => maleOptions,
    };

    final sorted = List<BodyShapeOption>.from(options);
    sorted.sort((left, right) => left.order.compareTo(right.order));
    return sorted;
  }

  /// 성별과 코드에 맞는 옵션을 반환한다.
  BodyShapeOption? optionForGenderAndCode(String? gender, String? code) {
    if (code == null || code.isEmpty) return null;

    for (final option in optionsForGender(gender)) {
      if (option.code == code) return option;
    }

    return null;
  }

  /// 성별과 코드에 맞는 라벨을 반환한다.
  String? labelForGenderAndCode(String? gender, String? code) {
    return optionForGenderAndCode(gender, code)?.label;
  }
}

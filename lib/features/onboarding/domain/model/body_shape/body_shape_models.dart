import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';

const String _maleBodyTypeParentCode = 'BT_MALE';
const String _femaleBodyTypeParentCode = 'BT_FEMALE';
const String _maleBodyTypeCodePrefix = 'BT_M_';
const String _femaleBodyTypeCodePrefix = 'BT_F_';

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

  /// BODY_TYPE 코드북 항목으로부터 체형 코드북을 생성한다.
  factory BodyShapeCodebook.fromCodebookEntries(
    Iterable<CodebookEntry> entries,
  ) {
    final maleOptions = <BodyShapeOption>[];
    final femaleOptions = <BodyShapeOption>[];

    for (final entry in entries) {
      final option = BodyShapeOption(
        code: entry.code,
        label: entry.codeName,
        order: _orderOf(entry),
      );

      if (_isMaleEntry(entry)) {
        maleOptions.add(option);
      } else if (_isFemaleEntry(entry)) {
        femaleOptions.add(option);
      }
    }

    return BodyShapeCodebook(
      maleOptions: maleOptions,
      femaleOptions: femaleOptions,
    );
  }

  /// 목업 코드북을 생성한다.
  factory BodyShapeCodebook.mock() {
    return const BodyShapeCodebook(
      maleOptions: [
        BodyShapeOption(code: 'BT_M_001', label: '슬림', order: 1),
        BodyShapeOption(code: 'BT_M_002', label: '보통', order: 2),
        BodyShapeOption(code: 'BT_M_003', label: '탄탄', order: 3),
        BodyShapeOption(code: 'BT_M_004', label: '체격 있음', order: 4),
        BodyShapeOption(code: 'BT_M_005', label: '공개 안함', order: 5),
      ],
      femaleOptions: [
        BodyShapeOption(code: 'BT_F_001', label: '슬림', order: 1),
        BodyShapeOption(code: 'BT_F_002', label: '보통', order: 2),
        BodyShapeOption(code: 'BT_F_003', label: '볼륨', order: 3),
        BodyShapeOption(code: 'BT_F_004', label: '체구 있음', order: 4),
        BodyShapeOption(code: 'BT_F_005', label: '공개 안함', order: 5),
      ],
    );
  }

  /// 성별에 맞는 옵션 목록을 반환한다.
  List<BodyShapeOption> optionsForGender(String? gender) {
    final options = switch (_normalizeGender(gender)) {
      _BodyShapeGender.female => femaleOptions,
      _BodyShapeGender.male => maleOptions,
      _ => maleOptions,
    };

    final sorted = List<BodyShapeOption>.from(options);
    sorted.sort((left, right) => left.order.compareTo(right.order));
    return sorted;
  }

  static bool _isMaleEntry(CodebookEntry entry) {
    return entry.parentCode == _maleBodyTypeParentCode ||
        entry.code.toUpperCase().startsWith(_maleBodyTypeCodePrefix);
  }

  static bool _isFemaleEntry(CodebookEntry entry) {
    return entry.parentCode == _femaleBodyTypeParentCode ||
        entry.code.toUpperCase().startsWith(_femaleBodyTypeCodePrefix);
  }

  static int _orderOf(CodebookEntry entry) {
    if (entry.displayOrder > 0) return entry.displayOrder;

    final lastSegment = entry.code.split('_').last;
    return int.tryParse(lastSegment) ?? 0;
  }

  static _BodyShapeGender? _normalizeGender(String? gender) {
    return switch (gender?.trim().toLowerCase()) {
      'female' || 'f' || 'woman' || '여' || '여성' => _BodyShapeGender.female,
      'male' || 'm' || 'man' || '남' || '남성' => _BodyShapeGender.male,
      _ => null,
    };
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

enum _BodyShapeGender { male, female }

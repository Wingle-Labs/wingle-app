import 'package:wingle/features/auth/common/constrants/auth_constrants.dart';

/// 전화번호 모델
class PhoneNumber {
  /// 전화번호
  final String value;

  /// 생성자
  const PhoneNumber(this.value);

  /// 010으로 시작하는지 확인
  bool get startsWith010 => value.startsWith('010');

  /// 010 포함 총 11자리인지 확인
  bool get hasExactLength => value.length == AuthConstrants.phoneMaxLength;

  /// 전화번호가 유효한지 확인
  bool get isValid {
    if (value.isEmpty) return false;
    return RegExp(AuthConstrants.phoneRegex).hasMatch(value);
  }
}

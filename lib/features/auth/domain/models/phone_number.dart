import 'package:wingle/features/auth/common/constrants/auth_constrants.dart';

/// 전화번호 모델
class PhoneNumber {
  /// 전화번호
  final String value;

  /// 생성자
  const PhoneNumber(this.value);

  /// 전화번호가 유효한지 확인
  bool get isValid {
    if (value.isEmpty) return false;
    return RegExp(AuthConstrants.phoneRegex).hasMatch(value);
  }
}

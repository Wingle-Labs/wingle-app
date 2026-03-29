import 'package:wingle/features/auth/common/constrants/auth_constrants.dart';

/// 전화번호 모델
class PhoneNumber {
  /// 전화번호
  final String value;

  /// 생성자
  const PhoneNumber(this.value);

  /// 숫자만 남긴 값
  String get digitsOnly => normalize(value);

  /// API 전송용 전화번호
  String get apiValue => format(digitsOnly);

  /// 010으로 시작하는지 확인
  bool get startsWith010 => digitsOnly.startsWith('010');

  /// 010 포함 총 11자리인지 확인
  bool get hasExactLength => digitsOnly.length == AuthConstrants.phoneMaxLength;

  /// 전화번호가 유효한지 확인
  bool get isValid {
    if (digitsOnly.isEmpty) return false;
    return RegExp(AuthConstrants.phoneRegex).hasMatch(digitsOnly);
  }

  /// 문자열에서 숫자만 남긴다.
  static String normalize(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// 한국형 휴대폰 번호 포맷으로 변환한다.
  static String format(String value) {
    final digits = normalize(value);

    if (digits.length <= 3) {
      return digits;
    }

    if (digits.length <= 7) {
      return '${digits.substring(0, 3)}-${digits.substring(3)}';
    }

    final middle = digits.substring(3, 7);
    final end = digits.substring(7);
    return '${digits.substring(0, 3)}-$middle-$end';
  }
}

import 'package:wingle/features/auth/common/constrants/auth_constrants.dart';

/// 비밀번호 값 객체
class Password {
  /// 비밀번호 원문
  final String value;

  /// 생성자
  const Password(this.value);

  /// 공백 포함 여부
  bool get containsWhitespace => value.contains(RegExp(r'\s'));

  /// 영문 포함 여부
  bool get containsLetter => value.contains(RegExp(r'[A-Za-z]'));

  /// 숫자 포함 여부
  bool get containsNumber => value.contains(RegExp(r'\d'));

  /// 허용 특수문자 포함 여부
  bool get containsSpecialCharacter =>
      value.contains(RegExp(r'[!@#\$%\^*+=-]'));

  /// 허용된 문자만 사용했는지 확인
  bool get containsOnlyAllowedCharacters =>
      value.contains(RegExp(r'^[A-Za-z\d!@#\$%\^*+=-]+$'));

  /// 길이 조건 충족 여부
  bool get hasValidLength =>
      value.length >= AuthConstrants.passwordMinLength &&
      value.length <= AuthConstrants.passwordMaxLength;

  /// 비밀번호 유효성
  bool get isValid {
    if (value.isEmpty) return false;
    if (containsWhitespace) return false;
    return AuthConstrants.passwordRegex.hasMatch(value);
  }

  /// 검증 메시지
  String? get errorText {
    if (value.isEmpty) return null;
    if (!hasValidLength) {
      return 'common.validation.password.length';
    }
    if (containsWhitespace) {
      return 'common.validation.password.whitespace';
    }
    if (!containsOnlyAllowedCharacters) {
      return 'common.validation.password.allowedSpecialCharacters';
    }
    if (!containsLetter || !containsNumber || !containsSpecialCharacter) {
      return 'common.validation.password.composition';
    }
    return null;
  }
}

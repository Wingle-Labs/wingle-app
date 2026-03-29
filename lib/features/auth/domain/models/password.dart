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
      return '8자 이상 32자 이하로 입력해주세요';
    }
    if (containsWhitespace) {
      return '공백을 포함할 수 없습니다';
    }
    if (!containsOnlyAllowedCharacters) {
      return '허용된 특수문자 !@#\$%^*+=- 만 사용할 수 있습니다';
    }
    if (!containsLetter || !containsNumber || !containsSpecialCharacter) {
      return '영문, 숫자, 특수문자를 모두 포함해야 합니다';
    }
    return null;
  }
}

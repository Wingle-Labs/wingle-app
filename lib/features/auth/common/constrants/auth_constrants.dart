import 'package:flutter/services.dart';
import 'package:wingle/features/auth/common/formatters/korean_phone_number_input_formatter.dart';

/// 전화번호 인증에 사용되는 상수 정의
class AuthConstrants {
  /// 전화번호 정규식
  static const String phoneRegex = r'^010\d{8}$';

  /// 전화번호 숫자 길이
  static const int phoneMaxLength = 11;

  /// 전화번호 입력 길이
  static const int phoneTextMaxLength = 13;

  /// SMS 인증번호 길이
  static const int smsCodeLength = 6;

  /// 비밀번호 최소 길이
  static const int passwordMinLength = 8;

  /// 비밀번호 최대 길이
  static const int passwordMaxLength = 32;

  /// 허용 특수문자
  static const String passwordSpecialCharacters = r'!@#$%^*+=-';

  /// 비밀번호 정규식
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$%\^*+=-])[A-Za-z\d!@#\$%\^*+=-]{8,32}$',
  );

  /// Formatter
  static final List<TextInputFormatter> phoneFormatter = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(phoneMaxLength),
    KoreanPhoneNumberInputFormatter(),
  ];
}

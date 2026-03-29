import 'package:wingle/features/auth/domain/models/password.dart';
import 'package:wingle/features/auth/domain/models/phone_number.dart';

/// 로그인 페이지 모델
class LoginPageModel {
  static const Object _unset = Object();

  /// 휴대폰 번호
  final String phone;

  /// 비밀번호
  final String password;

  /// 비밀번호 표시 여부
  final bool isPasswordVisible;

  /// 로딩 여부
  final bool isLoading;

  /// 에러 메시지
  final String? errorMessage;

  /// 생성자
  const LoginPageModel({
    this.phone = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
  });

  /// 전화번호 값 객체
  PhoneNumber get phoneNumber => PhoneNumber(phone);

  /// 비밀번호 값 객체
  Password get passwordValue => Password(password);

  /// 휴대폰 번호가 유효한지 확인
  bool get isPhoneValid => phoneNumber.isValid;

  /// 휴대폰 번호 검증 메시지
  String? get phoneErrorText {
    if (phone.isEmpty) return null;
    if (isPhoneValid) return null;
    if (!phoneNumber.startsWith010) {
      return '010으로 시작하는 번호를 입력하세요';
    }
    if (!phoneNumber.hasExactLength) {
      return '010을 포함해 총 11자리로 입력하세요';
    }
    return '010으로 시작하는 11자리 숫자를 입력하세요';
  }

  /// 비밀번호가 유효한지 확인
  bool get isPasswordValid => passwordValue.isValid;

  /// 로그인 가능한지 확인
  bool get canLogin => isPhoneValid && isPasswordValid && !isLoading;

  /// 복사
  LoginPageModel copyWith({
    String? phone,
    String? password,
    bool? isPasswordVisible,
    bool? isLoading,
    Object? errorMessage = _unset,
  }) {
    return LoginPageModel(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

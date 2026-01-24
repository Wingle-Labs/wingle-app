/// 로그인 페이지 모델
class LoginPageModel {
  /// 휴대폰 번호
  final String phone;

  /// 비밀번호
  final String password;

  /// 생성자
  const LoginPageModel({this.phone = '', this.password = ''});

  /// 휴대폰 번호가 유효한지 확인
  bool get isPhoneValid => RegExp(r'^010\d{8}$').hasMatch(phone);

  /// 비밀번호가 유효한지 확인
  bool get isPasswordValid {
    if (password.length < 8) {
      return false;
    }
    return true;
  }

  /// 로그인 가능한지 확인
  bool get canLogin => isPhoneValid && isPasswordValid;

  /// 복사
  LoginPageModel copyWith({String? phone, String? password}) {
    return LoginPageModel(
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }
}

/// 로그인/프로필 조회 응답에 포함될 수 있는 직장 프로필 정보.
class LoginJobProfile {
  /// 회사명.
  final String? company;

  /// 직업 코드.
  final String? occupationCode;

  /// 직업 표시명.
  final String? occupationName;

  /// 직장 이메일 인증 완료 여부.
  final bool? emailVerified;

  /// 생성자.
  const LoginJobProfile({
    this.company,
    this.occupationCode,
    this.occupationName,
    this.emailVerified,
  });

  /// JSON 객체에서 직장 프로필 정보를 만든다.
  factory LoginJobProfile.fromJson(Map<String, dynamic> json) {
    return LoginJobProfile(
      company: _string(json['company']),
      occupationCode: _string(
        json['occupationCode'] ?? json['occupation_code'] ?? json['occupation'],
      ),
      occupationName: _string(
        json['occupationName'] ?? json['occupation_name'],
      ),
      emailVerified: _bool(json['emailVerified'] ?? json['email_verified']),
    );
  }

  /// 복원할 직장 프로필 정보가 하나라도 있는지 여부.
  bool get hasAnyValue =>
      _hasText(company) || _hasText(occupationCode) || _hasText(occupationName);

  /// Hive 저장용 JSON 객체로 변환한다.
  Map<String, dynamic> toJson() => {
    if (_hasText(company)) 'company': company!.trim(),
    if (_hasText(occupationCode)) 'occupationCode': occupationCode!.trim(),
    if (_hasText(occupationName)) 'occupationName': occupationName!.trim(),
    if (emailVerified != null) 'emailVerified': emailVerified,
  };

  static String? _string(Object? value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  static bool? _bool(Object? value) {
    if (value is bool) return value;
    final text = value?.toString().trim().toLowerCase();
    if (text == null || text.isEmpty) return null;
    if (text == 'true') return true;
    if (text == 'false') return false;
    return null;
  }

  static bool _hasText(String? value) =>
      value != null && value.trim().isNotEmpty;
}

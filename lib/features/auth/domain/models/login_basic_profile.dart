/// 로그인 응답에 포함될 수 있는 기본 프로필 정보.
class LoginBasicProfile {
  /// 닉네임.
  final String? nickname;

  /// 거주지 코드.
  final String? residenceCode;

  /// 키.
  final int? height;

  /// 체형 코드.
  final String? bodyTypeCode;

  /// 생성자.
  const LoginBasicProfile({
    this.nickname,
    this.residenceCode,
    this.height,
    this.bodyTypeCode,
  });

  /// JSON 객체에서 기본 프로필 정보를 만든다.
  factory LoginBasicProfile.fromJson(Map<String, dynamic> json) {
    return LoginBasicProfile(
      nickname: _string(json['nickname']),
      residenceCode: _string(json['residenceCode'] ?? json['residence_code']),
      height: _int(json['height']),
      bodyTypeCode: _string(json['bodyTypeCode'] ?? json['body_type_code']),
    );
  }

  /// 복원할 기본 프로필 정보가 하나라도 있는지 여부.
  bool get hasAnyValue =>
      _hasText(nickname) ||
      _hasText(residenceCode) ||
      height != null ||
      _hasText(bodyTypeCode);

  /// Hive 저장용 JSON 객체로 변환한다.
  Map<String, dynamic> toJson() => {
    if (_hasText(nickname)) 'nickname': nickname!.trim(),
    if (_hasText(residenceCode)) 'residenceCode': residenceCode!.trim(),
    if (height != null) 'height': height,
    if (_hasText(bodyTypeCode)) 'bodyTypeCode': bodyTypeCode!.trim(),
  };

  static String? _string(Object? value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  static int? _int(Object? value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  static bool _hasText(String? value) =>
      value != null && value.trim().isNotEmpty;
}

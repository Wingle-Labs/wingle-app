/// 로그인/프로필 조회 응답에 포함될 수 있는 학교 프로필 정보.
class LoginEducationProfile {
  /// 학력 수준 API enum 값.
  final String? educationLevel;

  /// 앱에서 마지막으로 입력한 학교명.
  final String? schoolName;

  /// 학교 코드.
  final String? universityCode;

  /// 코드북에 없는 학교명.
  final String? customUniversityName;

  /// 학교 이메일 인증 완료 여부.
  final bool? emailVerified;

  /// 생성자.
  const LoginEducationProfile({
    this.educationLevel,
    this.schoolName,
    this.universityCode,
    this.customUniversityName,
    this.emailVerified,
  });

  /// JSON 객체에서 학교 프로필 정보를 만든다.
  factory LoginEducationProfile.fromJson(Map<String, dynamic> json) {
    final educationJson = _asStringKeyedMap(json['education']);
    final source = educationJson ?? json;
    final university = _asStringKeyedMap(source['university']);
    final rawUniversity = source['university'];
    final customUniversityName = _string(
      source['customUniversityName'] ?? source['custom_university_name'],
    );
    final universityName = _string(
      source['universityName'] ??
          source['university_name'] ??
          university?['codeName'] ??
          university?['code_name'] ??
          university?['name'],
    );

    return LoginEducationProfile(
      educationLevel: _string(
        source['educationLevel'] ?? source['education_level'],
      ),
      schoolName:
          _string(source['schoolName'] ?? source['school_name']) ??
          customUniversityName ??
          universityName,
      universityCode: _string(
        source['universityCode'] ??
            source['university_code'] ??
            university?['code'] ??
            (rawUniversity is Map ? null : rawUniversity),
      ),
      customUniversityName: customUniversityName,
      emailVerified: _bool(
        source['emailVerified'] ??
            source['email_verified'] ??
            source['educationEmailVerified'] ??
            source['education_email_verified'],
      ),
    );
  }

  /// 복원할 학교 프로필 정보가 하나라도 있는지 여부.
  bool get hasAnyValue =>
      _hasText(educationLevel) ||
      _hasText(schoolName) ||
      _hasText(universityCode) ||
      _hasText(customUniversityName);

  /// Hive 저장용 JSON 객체로 변환한다.
  Map<String, dynamic> toJson() => {
    if (_hasText(educationLevel)) 'educationLevel': educationLevel!.trim(),
    if (_hasText(schoolName)) 'schoolName': schoolName!.trim(),
    if (_hasText(universityCode)) 'universityCode': universityCode!.trim(),
    if (_hasText(customUniversityName))
      'customUniversityName': customUniversityName!.trim(),
    if (emailVerified != null) 'emailVerified': emailVerified,
  };

  static Map<String, dynamic>? _asStringKeyedMap(Object? value) {
    if (value is! Map) return null;
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

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

/// 로그인/프로필 조회 응답에 포함될 수 있는 상세 프로필 정보.
class LoginProfileDetails {
  /// MBTI 값.
  final String? mbti;

  /// 자기소개.
  final String? selfIntroduction;

  /// 대표 스타일 사진 key.
  final String? mainStylePhotoKey;

  /// 보조 스타일 사진 key 목록.
  final List<String> subStylePhotoKeys;

  /// 대표 얼굴 사진 key.
  final String? mainFacePhotoKey;

  /// 보조 얼굴 사진 key 목록.
  final List<String> subFacePhotoKeys;

  /// 생성자.
  const LoginProfileDetails({
    this.mbti,
    this.selfIntroduction,
    this.mainStylePhotoKey,
    this.subStylePhotoKeys = const <String>[],
    this.mainFacePhotoKey,
    this.subFacePhotoKeys = const <String>[],
  });

  /// JSON 객체에서 상세 프로필 정보를 만든다.
  factory LoginProfileDetails.fromJson(Map<String, dynamic> json) {
    final detailJson = _asStringKeyedMap(json['profileDetails']);
    final snakeDetailJson = _asStringKeyedMap(json['profile_details']);
    final source = detailJson ?? snakeDetailJson ?? json;

    return LoginProfileDetails(
      mbti: _normalizeMbti(source['mbti']),
      selfIntroduction: _string(
        source['selfIntroduction'] ?? source['self_introduction'],
      ),
      mainStylePhotoKey: _string(
        source['mainStylePhotoKey'] ?? source['main_style_photo_key'],
      ),
      subStylePhotoKeys: _stringList(
        source['subStylePhotoKeys'] ?? source['sub_style_photo_keys'],
      ),
      mainFacePhotoKey: _string(
        source['mainFacePhotoKey'] ?? source['main_face_photo_key'],
      ),
      subFacePhotoKeys: _stringList(
        source['subFacePhotoKeys'] ?? source['sub_face_photo_keys'],
      ),
    );
  }

  /// 복원할 상세 프로필 정보가 하나라도 있는지 여부.
  bool get hasAnyValue =>
      _hasText(mbti) ||
      _hasText(selfIntroduction) ||
      _hasText(mainStylePhotoKey) ||
      subStylePhotoKeys.isNotEmpty ||
      _hasText(mainFacePhotoKey) ||
      subFacePhotoKeys.isNotEmpty;

  /// Hive 저장용 JSON 객체로 변환한다.
  Map<String, dynamic> toJson() => {
    if (_hasText(mbti)) 'mbti': mbti!.trim().toUpperCase(),
    if (_hasText(selfIntroduction))
      'selfIntroduction': selfIntroduction!.trim(),
    if (_hasText(mainStylePhotoKey))
      'mainStylePhotoKey': mainStylePhotoKey!.trim(),
    if (subStylePhotoKeys.isNotEmpty) 'subStylePhotoKeys': subStylePhotoKeys,
    if (_hasText(mainFacePhotoKey))
      'mainFacePhotoKey': mainFacePhotoKey!.trim(),
    if (subFacePhotoKeys.isNotEmpty) 'subFacePhotoKeys': subFacePhotoKeys,
  };

  static Map<String, dynamic>? _asStringKeyedMap(Object? value) {
    if (value is! Map) return null;
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  static String? _normalizeMbti(Object? value) {
    final text = _string(value)?.toUpperCase();
    if (text == null || !RegExp(r'^[EI][NS][TF][JP]$').hasMatch(text)) {
      return null;
    }

    return text;
  }

  static String? _string(Object? value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  static List<String> _stringList(Object? value) {
    if (value is! Iterable) return const <String>[];

    return List<String>.unmodifiable(value.map(_string).whereType<String>());
  }

  static bool _hasText(String? value) =>
      value != null && value.trim().isNotEmpty;
}

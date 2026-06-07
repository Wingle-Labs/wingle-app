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
    final stylePhotoKeys = _photoKeys(
      source['stylePhotos'] ?? source['style_photos'],
    );
    final facePhotoKeys = _photoKeys(
      source['facePhotos'] ?? source['face_photos'],
    );
    final mainStylePhotoKey = _string(
      source['mainStylePhotoKey'] ?? source['main_style_photo_key'],
    );
    final subStylePhotoKeys = _stringList(
      source['subStylePhotoKeys'] ?? source['sub_style_photo_keys'],
    );
    final mainFacePhotoKey = _string(
      source['mainFacePhotoKey'] ?? source['main_face_photo_key'],
    );
    final subFacePhotoKeys = _stringList(
      source['subFacePhotoKeys'] ?? source['sub_face_photo_keys'],
    );

    return LoginProfileDetails(
      mbti: _normalizeMbti(source['mbti']),
      selfIntroduction: _string(
        source['selfIntroduction'] ?? source['self_introduction'],
      ),
      mainStylePhotoKey: mainStylePhotoKey ?? _firstOrNull(stylePhotoKeys),
      subStylePhotoKeys: subStylePhotoKeys.isNotEmpty
          ? subStylePhotoKeys
          : _tail(stylePhotoKeys),
      mainFacePhotoKey: mainFacePhotoKey ?? _firstOrNull(facePhotoKeys),
      subFacePhotoKeys: subFacePhotoKeys.isNotEmpty
          ? subFacePhotoKeys
          : _tail(facePhotoKeys),
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

  static List<String> _photoKeys(Object? value) {
    if (value is! Iterable) return const <String>[];

    final photos = <_ParsedPhoto>[];
    var index = 0;
    for (final item in value) {
      final photo = _ParsedPhoto.from(item, index);
      if (photo != null) {
        photos.add(photo);
      }
      index += 1;
    }

    photos.sort((a, b) {
      if (a.isMain != b.isMain) {
        return a.isMain ? -1 : 1;
      }

      final sortOrder = a.sortOrder.compareTo(b.sortOrder);
      if (sortOrder != 0) {
        return sortOrder;
      }

      return a.index.compareTo(b.index);
    });

    return List<String>.unmodifiable(photos.map((photo) => photo.key));
  }

  static String? _photoKey(Object? value) {
    final text = switch (value) {
      final Map<dynamic, dynamic> map =>
        _string(map['s3Key'] ?? map['s3_key']) ??
            _string(map['key']) ??
            _string(map['photoKey'] ?? map['photo_key']) ??
            _string(map['objectKey'] ?? map['object_key']) ??
            _string(map['presignedUrl'] ?? map['presigned_url']) ??
            _string(map['url']),
      _ => _string(value),
    };
    if (text == null) return null;

    final usersIndex = text.indexOf('users/');
    if (usersIndex >= 0) {
      return text.substring(usersIndex).split('?').first;
    }

    final uri = Uri.tryParse(text);
    if (uri != null && uri.hasAbsolutePath) {
      final segments = uri.pathSegments;
      final userSegmentIndex = segments.indexOf('users');
      if (userSegmentIndex >= 0) {
        return segments.sublist(userSegmentIndex).join('/');
      }
      if (segments.length > 1) {
        return segments.skip(1).join('/');
      }
    }

    return text.split('?').first;
  }

  static String? _firstOrNull(List<String> values) {
    return values.isEmpty ? null : values.first;
  }

  static List<String> _tail(List<String> values) {
    return values.length <= 1
        ? const <String>[]
        : List<String>.unmodifiable(values.skip(1));
  }

  static bool _hasText(String? value) =>
      value != null && value.trim().isNotEmpty;
}

class _ParsedPhoto {
  final String key;
  final bool isMain;
  final int sortOrder;
  final int index;

  const _ParsedPhoto({
    required this.key,
    required this.isMain,
    required this.sortOrder,
    required this.index,
  });

  static _ParsedPhoto? from(Object? value, int index) {
    final key = LoginProfileDetails._photoKey(value);
    if (key == null || key.isEmpty) {
      return null;
    }

    final map = LoginProfileDetails._asStringKeyedMap(value);
    return _ParsedPhoto(
      key: key,
      isMain: map?['isMain'] == true || map?['is_main'] == true,
      sortOrder: _int(map?['sortOrder'] ?? map?['sort_order']) ?? index,
      index: index,
    );
  }

  static int? _int(Object? value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}

import 'dart:typed_data';

const Object _undefined = Object();

/// 상세 프로필 사진 입력 종류.
enum ProfilePhotoType {
  /// 스타일 사진.
  style,

  /// 얼굴 사진.
  face,
}

/// 자기소개 성실도 표시 상태.
enum SelfIntroductionQuality {
  /// 입력된 내용이 없음.
  empty,

  /// 짧은 글.
  short,

  /// 보통 길이의 글.
  normal,

  /// 충분한 길이의 글.
  appropriate,
}

/// 상세 프로필 사진 입력값.
class ProfilePhotoInput {
  /// S3 object key.
  final String s3Key;

  /// 업로드한 파일명.
  final String name;

  /// 업로드한 파일 content-type.
  final String contentType;

  /// 현재 세션에서 선택한 이미지 미리보기 바이트.
  final Uint8List? previewBytes;

  /// 서버에서 내려준 기존 사진 미리보기 URL.
  final String? remoteUrl;

  /// 생성자.
  const ProfilePhotoInput({
    required this.s3Key,
    required this.name,
    required this.contentType,
    this.previewBytes,
    this.remoteUrl,
  });

  /// 값 복사.
  ProfilePhotoInput copyWith({Uint8List? previewBytes, String? remoteUrl}) {
    return ProfilePhotoInput(
      s3Key: s3Key,
      name: name,
      contentType: contentType,
      previewBytes: previewBytes ?? this.previewBytes,
      remoteUrl: remoteUrl ?? this.remoteUrl,
    );
  }
}

/// 상세 프로필 입력 상태.
class ProfileDetailsModel {
  /// 자기소개 최대 글자 수.
  static const int selfIntroductionMaxLength = 1000;

  /// 자기소개 보통 상태 기준 글자 수.
  static const int selfIntroductionNormalMinLength = 50;

  /// 자기소개 적정 상태 기준 글자 수.
  static const int selfIntroductionAppropriateMinLength = 200;

  /// 첫 번째 MBTI 축: E/I.
  final String? energy;

  /// 두 번째 MBTI 축: N/S.
  final String? perception;

  /// 세 번째 MBTI 축: F/T.
  final String? decision;

  /// 네 번째 MBTI 축: P/J.
  final String? lifestyle;

  /// 자기소개.
  final String selfIntroduction;

  /// 스타일 사진 목록. 첫 번째 항목이 대표 사진이다.
  final List<ProfilePhotoInput> stylePhotos;

  /// 얼굴 사진 목록. 첫 번째 항목이 대표 사진이다.
  final List<ProfilePhotoInput> facePhotos;

  /// 제출/저장 중 여부.
  final bool isSubmitting;

  /// 제출/저장 실패 메시지.
  final String? submitErrorMessage;

  /// 생성자.
  const ProfileDetailsModel({
    this.energy,
    this.perception,
    this.decision,
    this.lifestyle,
    this.selfIntroduction = '',
    this.stylePhotos = const <ProfilePhotoInput>[],
    this.facePhotos = const <ProfilePhotoInput>[],
    this.isSubmitting = false,
    this.submitErrorMessage,
  });

  /// MBTI 입력 단계 진행 가능 여부.
  bool get canContinueMbti =>
      energy != null &&
      perception != null &&
      decision != null &&
      lifestyle != null;

  /// 완성된 MBTI 문자열.
  String? get mbti {
    if (!canContinueMbti) return null;

    return '$energy$perception$decision$lifestyle';
  }

  /// 스타일 사진 입력 단계 진행 가능 여부.
  bool get canContinueStylePhotos => stylePhotos.isNotEmpty;

  /// 얼굴 사진 입력 단계 진행 가능 여부.
  bool get canContinueFacePhotos => facePhotos.isNotEmpty;

  /// 자기소개 입력 단계 진행 가능 여부.
  bool get canContinueSelfIntroduction {
    final text = selfIntroduction.trim();
    return text.isNotEmpty && text.length <= selfIntroductionMaxLength;
  }

  /// 자기소개 글자 수.
  int get selfIntroductionLength => selfIntroduction.length;

  /// 자기소개 성실도 표시 상태.
  SelfIntroductionQuality get selfIntroductionQuality {
    final length = selfIntroduction.trim().length;
    if (length == 0) return SelfIntroductionQuality.empty;
    if (length < selfIntroductionNormalMinLength) {
      return SelfIntroductionQuality.short;
    }
    if (length < selfIntroductionAppropriateMinLength) {
      return SelfIntroductionQuality.normal;
    }
    return SelfIntroductionQuality.appropriate;
  }

  /// 대표 스타일 사진 key.
  String? get mainStylePhotoKey =>
      stylePhotos.isEmpty ? null : stylePhotos.first.s3Key;

  /// 보조 스타일 사진 key 목록.
  List<String> get subStylePhotoKeys =>
      stylePhotos.skip(1).map((photo) => photo.s3Key).toList(growable: false);

  /// 대표 얼굴 사진 key.
  String? get mainFacePhotoKey =>
      facePhotos.isEmpty ? null : facePhotos.first.s3Key;

  /// 보조 얼굴 사진 key 목록.
  List<String> get subFacePhotoKeys =>
      facePhotos.skip(1).map((photo) => photo.s3Key).toList(growable: false);

  /// 값 복사.
  ProfileDetailsModel copyWith({
    Object? energy = _undefined,
    Object? perception = _undefined,
    Object? decision = _undefined,
    Object? lifestyle = _undefined,
    String? selfIntroduction,
    List<ProfilePhotoInput>? stylePhotos,
    List<ProfilePhotoInput>? facePhotos,
    bool? isSubmitting,
    String? submitErrorMessage,
  }) {
    return ProfileDetailsModel(
      energy: energy == _undefined ? this.energy : energy as String?,
      perception: perception == _undefined
          ? this.perception
          : perception as String?,
      decision: decision == _undefined ? this.decision : decision as String?,
      lifestyle: lifestyle == _undefined
          ? this.lifestyle
          : lifestyle as String?,
      selfIntroduction: selfIntroduction ?? this.selfIntroduction,
      stylePhotos: stylePhotos == null
          ? this.stylePhotos
          : List.unmodifiable(stylePhotos),
      facePhotos: facePhotos == null
          ? this.facePhotos
          : List.unmodifiable(facePhotos),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitErrorMessage: submitErrorMessage,
    );
  }
}

import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';

/// 기본 프로필 입력 상태 모델.
class BasicProfileModel {
  static const Object _unset = Object();

  /// 랜덤 닉네임
  final String nickname;

  /// 닉네임 로딩 여부
  final bool isNicknameLoading;

  /// 닉네임 조회 에러 메시지
  final String? nicknameErrorMessage;

  /// 거주지 검색어
  final String residenceQuery;

  /// 매핑된 거주지 코드
  final ResidenceCode? residenceCode;

  /// 키
  final String height;

  /// 체형 코드
  final String? bodyShapeCode;

  /// 업로드 로딩 여부
  final bool isSubmitting;

  /// 업로드 에러 메시지
  final String? submitErrorMessage;

  /// 생성자
  const BasicProfileModel({
    this.nickname = '',
    this.isNicknameLoading = false,
    this.nicknameErrorMessage,
    this.residenceQuery = '',
    this.residenceCode,
    this.height = '',
    this.bodyShapeCode,
    this.isSubmitting = false,
    this.submitErrorMessage,
  });

  /// 닉네임 단계 진행 가능 여부
  bool get canContinueNickname => nickname.isNotEmpty && !isNicknameLoading;

  /// 닉네임 조회 중 최초 로딩 상태인지 여부
  bool get shouldShowNicknameLoading => isNicknameLoading && nickname.isEmpty;

  /// 거주지 단계 진행 가능 여부
  bool get canContinueResidence => residenceCode != null;

  /// 키 단계 진행 가능 여부
  bool get canContinueHeight => height.length == 3;

  /// 체형 단계 진행 가능 여부
  bool get canContinueBodyShape => bodyShapeCode != null;

  /// 최종 제출 가능 여부
  bool get canSubmit =>
      nickname.trim().isNotEmpty &&
      residenceCode != null &&
      canContinueHeight &&
      bodyShapeCode != null &&
      !isSubmitting;

  /// 복사
  BasicProfileModel copyWith({
    String? nickname,
    bool? isNicknameLoading,
    Object? nicknameErrorMessage = _unset,
    String? residenceQuery,
    Object? residenceCode = _unset,
    String? height,
    Object? bodyShapeCode = _unset,
    bool? isSubmitting,
    Object? submitErrorMessage = _unset,
  }) {
    return BasicProfileModel(
      nickname: nickname ?? this.nickname,
      isNicknameLoading: isNicknameLoading ?? this.isNicknameLoading,
      nicknameErrorMessage: identical(nicknameErrorMessage, _unset)
          ? this.nicknameErrorMessage
          : nicknameErrorMessage as String?,
      residenceQuery: residenceQuery ?? this.residenceQuery,
      residenceCode: identical(residenceCode, _unset)
          ? this.residenceCode
          : residenceCode as ResidenceCode?,
      height: height ?? this.height,
      bodyShapeCode: identical(bodyShapeCode, _unset)
          ? this.bodyShapeCode
          : bodyShapeCode as String?,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitErrorMessage: identical(submitErrorMessage, _unset)
          ? this.submitErrorMessage
          : submitErrorMessage as String?,
    );
  }
}

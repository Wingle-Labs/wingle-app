/// 시스템 텍스트 크기 정책에 따른 UI 내 텍스트 크기 조정 정책
enum TextScalePolicy {
  /// 시스템 텍스트 크기 그대로 사용
  system,

  /// 시스템 텍스트 크기 1.0 ~ 1.1로 제한
  cappedSmall,

  /// 시스템 텍스트 크기 1.0 ~ 1.3로 제한
  cappedMedium,

  /// 시스템 텍스트 크기 1.0 ~ 1.6로 제한
  cappedLarge,

  /// 시스템 텍스트 크기 1.0 고정
  fixed,
}

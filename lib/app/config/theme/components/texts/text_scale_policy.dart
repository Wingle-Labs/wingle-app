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

/// TextScalePolicy 확장
extension TextScalePolicyExtension on TextScalePolicy {
  /// 시스템 텍스트 크기에 따른 UI 내 텍스트 크기 조정
  double getScaleFactor(double systemScale) {
    switch (this) {
      case TextScalePolicy.system:
        return systemScale;
      case TextScalePolicy.cappedSmall:
        return systemScale.clamp(1.0, 1.1);
      case TextScalePolicy.cappedMedium:
        return systemScale.clamp(1.0, 1.3);
      case TextScalePolicy.cappedLarge:
        return systemScale.clamp(1.0, 1.6);
      case TextScalePolicy.fixed:
        return 1.0;
    }
  }
}

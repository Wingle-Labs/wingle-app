// app/config/theme/color/app_colors.dart
import 'package:flutter/material.dart';

import 'app_color_scheme.dart';

/// 애플리케이션 컬러.
///
/// [AppColorScheme]을 구현하는 컬러 스키마를 사용하여 컬러를 정의하는 인터페이스.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  /// 컬러 스키마.
  final AppColorScheme scheme;

  /// 컬러 스키마를 사용하여 컬러를 정의하는 인터페이스.
  const AppColors(this.scheme);

  @override
  AppColors copyWith({AppColorScheme? scheme}) {
    return AppColors(scheme ?? this.scheme);
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    // 컬러 보간 필요 없음 (라이트/다크 스위칭은 rebuild로 처리)
    if (other is! AppColors) return this;
    return other;
  }
}

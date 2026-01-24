// common/extensions/context_colors.dart
import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/color/app_color_scheme.dart';
import 'package:wingle/app/config/theme/color/app_colors.dart';
import 'package:wingle/app/config/theme/text/app_typography.dart';

/// 컨텍스트에서 컬러 스키마를 가져오는 확장.
extension AppColorContext on BuildContext {
  /// 컬러 스키마.
  AppColorScheme get colors =>
      (Theme.of(this).extension<AppColors>() as AppColors).scheme;

  /// 텍스트 스타일.
  AppTypography get typography =>
      (Theme.of(this).extension<AppTypography>() as AppTypography);
}

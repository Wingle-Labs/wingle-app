import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/text/app_typography.dart';

/// 컨텍스트에서 텍스트 스타일을 가져오는 확장.
extension AppTypographyContext on BuildContext {
  /// 텍스트 스타일.
  AppTypography get typography =>
      (Theme.of(this).extension<AppTypography>() as AppTypography);
}

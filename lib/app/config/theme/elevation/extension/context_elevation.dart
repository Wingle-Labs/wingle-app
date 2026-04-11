import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/elevation/app_elevation.dart';

/// BuildContext에서 elevation 토큰에 접근하기 위한 extension
extension AppElevationContext on BuildContext {
  /// 현재 theme의 elevation 토큰
  AppElevation get elevation {
    final extension = Theme.of(this).extension<AppElevation>();

    if (extension == null) {
      throw StateError(
        'AppElevation is not registered in ThemeData.extensions.',
      );
    }

    return extension;
  }
}

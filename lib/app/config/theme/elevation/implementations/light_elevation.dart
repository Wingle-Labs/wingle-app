import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/color/color_palette.dart';
import 'package:wingle/app/config/theme/elevation/app_elevation.dart';

/// Light theme elevation 토큰
final AppElevation lightElevation = AppElevation(
  normal: [
    BoxShadow(
      color: AppColorPalette.common100.color.withValues(
        alpha: AppColorPalette.opacity4,
      ),
      offset: .zero,
      blurRadius: 4,
    ),
    BoxShadow(
      color: AppColorPalette.common100.color.withValues(
        alpha: AppColorPalette.opacity8,
      ),
      offset: Offset(0, 1),
      blurRadius: 4,
    ),
  ],
  strong: [
    BoxShadow(
      color: AppColorPalette.common100.color.withValues(
        alpha: AppColorPalette.opacity4,
      ),
      offset: .zero,
      blurRadius: 4,
    ),
    BoxShadow(
      color: AppColorPalette.common100.color.withValues(
        alpha: AppColorPalette.opacity6,
      ),
      offset: Offset(0, 1),
      blurRadius: 6,
    ),
  ],
  heavy: [
    BoxShadow(
      color: AppColorPalette.common100.color.withValues(
        alpha: AppColorPalette.opacity6,
      ),
      offset: .zero,
      blurRadius: 4,
    ),
    BoxShadow(
      color: AppColorPalette.common100.color.withValues(
        alpha: AppColorPalette.opacity4,
      ),
      offset: Offset(0, 4),
      blurRadius: 8,
    ),
  ],
  heavyUpside: [
    BoxShadow(
      color: AppColorPalette.common100.color.withValues(
        alpha: AppColorPalette.opacity6,
      ),
      offset: .zero,
      blurRadius: 8,
    ),
    BoxShadow(
      color: AppColorPalette.common100.color.withValues(
        alpha: AppColorPalette.opacity6,
      ),
      offset: Offset(0, -10),
      blurRadius: 16,
    ),
  ],
);

import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/color/contracts/app_color_scheme.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/weight.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 배지 크기.
enum DefaultBadgeSize {
  /// 작은 배지
  sm,

  /// 중간 배지
  md,

  /// 큰 배지
  lg,
}

/// 배지 타입.
enum DefaultBadgeType {
  /// primary
  primary,

  /// secondary
  secondary,

  /// tertiary
  tertiary,

  /// gray
  gray,
}

/// 텍스트 배지 컴포넌트
class DefaultBadge extends StatelessWidget {
  /// 배지 텍스트
  final String text;

  /// 배지 크기
  final DefaultBadgeSize size;

  /// 배지 타입
  final DefaultBadgeType type;

  /// 생성자
  const DefaultBadge({
    super.key,
    required this.text,
    this.size = DefaultBadgeSize.md,
    this.type = DefaultBadgeType.primary,
  });

  @override
  Widget build(BuildContext context) {
    final spec = _DefaultBadgeSpec.resolve(size);
    final colors = context.colors;

    return Semantics(
      label: text,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _resolveBackground(colors),
          borderRadius: BorderRadius.circular(spec.radius),
        ),
        child: SizedBox(
          height: spec.height,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: spec.verticalPadding,
              horizontal: spec.horizontalPadding,
            ),
            child: Center(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: spec.fontSize,
                  fontWeight: spec.fontWeight,
                  height: spec.lineHeight,
                  letterSpacing: 0,
                  color: _resolveForeground(colors),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _resolveBackground(AppColorScheme colors) {
    return switch (type) {
      DefaultBadgeType.primary => colors.componentBadgePrimaryBackground,
      DefaultBadgeType.secondary => colors.componentBadgeSecondaryBackground,
      DefaultBadgeType.tertiary => colors.componentBadgeTertiaryBackground,
      DefaultBadgeType.gray => colors.componentBadgeGrayBackground,
    };
  }

  Color _resolveForeground(AppColorScheme colors) {
    return switch (type) {
      DefaultBadgeType.primary => colors.componentBadgePrimaryForeground,
      DefaultBadgeType.secondary => colors.componentBadgeSecondaryForeground,
      DefaultBadgeType.tertiary => colors.componentBadgeTertiaryForeground,
      DefaultBadgeType.gray => colors.componentBadgeGrayForeground,
    };
  }
}

class _DefaultBadgeSpec {
  final double height;
  final double radius;
  final double verticalPadding;
  final double horizontalPadding;
  final double fontSize;
  final double lineHeight;
  final FontWeight fontWeight;

  const _DefaultBadgeSpec({
    required this.height,
    required this.radius,
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.fontSize,
    required this.lineHeight,
    required this.fontWeight,
  });

  static _DefaultBadgeSpec resolve(DefaultBadgeSize size) {
    return switch (size) {
      DefaultBadgeSize.sm => const _DefaultBadgeSpec(
        height: AppBadgeHeight.sm,
        radius: AppRadius.badgeSm,
        verticalPadding: AppPadding.badgeSmVertical,
        horizontalPadding: AppPadding.badgeSmHorizontal,
        fontSize: AppBadgeFontSize.sm,
        lineHeight: 1,
        fontWeight: AppFontWeight.medium,
      ),
      DefaultBadgeSize.md => const _DefaultBadgeSpec(
        height: AppBadgeHeight.md,
        radius: AppRadius.badge,
        verticalPadding: AppPadding.badgeMdVertical,
        horizontalPadding: AppPadding.badgeMdHorizontal,
        fontSize: AppBadgeFontSize.lg,
        lineHeight: 1,
        fontWeight: AppFontWeight.semiBold,
      ),
      DefaultBadgeSize.lg => const _DefaultBadgeSpec(
        height: AppBadgeHeight.lg,
        radius: AppRadius.badge,
        verticalPadding: AppPadding.badgeLgVertical,
        horizontalPadding: AppPadding.badgeLgHorizontal,
        fontSize: AppBadgeFontSize.lg,
        lineHeight: 1,
        fontWeight: AppFontWeight.semiBold,
      ),
    };
  }
}

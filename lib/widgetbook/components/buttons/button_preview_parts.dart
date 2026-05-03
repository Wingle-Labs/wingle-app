import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/widgetbook/components/buttons/button_spec_resolver.dart';

/// 버튼 Widgetbook 공용 패널
class ButtonSpecPanel extends StatelessWidget {
  /// 패널 너비
  final double width;

  /// 패널 내부 위젯
  final Widget child;

  /// 생성자
  const ButtonSpecPanel({super.key, required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: width,
      padding: const EdgeInsets.all(AppPadding.card),
      decoration: BoxDecoration(
        color: colors.backgroundAlternative,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: child,
    );
  }
}

/// 버튼 Widgetbook 샘플 카드
class ButtonSampleCard extends StatelessWidget {
  /// 카드 너비
  final double width;

  /// 카드 내부 위젯
  final Widget child;

  /// 생성자
  const ButtonSampleCard({super.key, required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: width,
      padding: const EdgeInsets.all(AppPadding.horizontal),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: colors.strokeStructuralBorder),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: child,
      ),
    );
  }
}

/// 버튼 아이콘 슬롯 플레이스홀더
class ButtonIconPlaceholder extends StatelessWidget {
  /// frame 색상
  final Color frameColor;

  /// frame 크기
  final double frameSize;

  /// glyph 크기
  final double glyphSize;

  /// 생성자
  const ButtonIconPlaceholder({
    super.key,
    this.frameColor = const Color(0xFFFFD7D7),
    this.frameSize = AppIconButtonFrameSize.sm,
    this.glyphSize = AppIconSize.xs,
  });

  @override
  Widget build(BuildContext context) {
    // TODO(widgetbook): frame/glyph 크기가 일부 variant에서 Figma 스펙과 아직 불일치한다.
    return SizedBox.square(
      dimension: frameSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: frameColor,
          borderRadius: BorderRadius.circular(AppRadius.buttonIconSlot),
        ),
        child: Center(
          child: SizedBox.square(
            dimension: glyphSize,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.buttonIconSlot),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 눌림 상태 시각 예시
class ButtonPressedPreview extends StatelessWidget {
  /// 눌림 상태 radius
  final BorderRadius borderRadius;

  /// 프리뷰 대상 위젯
  final Widget child;

  /// 생성자
  const ButtonPressedPreview({
    super.key,
    required this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      children: [
        SizedBox(width: double.infinity, child: child),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.overlayPressed,
                borderRadius: borderRadius,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// resolver가 계산한 버튼 spec 표
class ButtonResolvedSpecCard extends StatelessWidget {
  /// resolver가 계산한 버튼 spec
  final WidgetbookButtonResolvedSpec spec;

  /// 생성자
  const ButtonResolvedSpecCard({super.key, required this.spec});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppPadding.card),
      decoration: BoxDecoration(
        color: colors.backgroundNormal,
        border: Border.all(color: colors.strokeStructuralBorder),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(spec.title, style: typography.main),
          const SizedBox(height: AppSpacing.s16),
          for (final entry in spec.entries) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 128,
                  child: Text(
                    entry.label,
                    style: typography.bodySub.copyWith(
                      color: colors.textAlternative,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (entry.swatchColor != null) ...[
                        Container(
                          width: 12,
                          height: 12,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: entry.swatchColor,
                            border: Border.all(
                              color: colors.strokeStructuralBorder,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.xs),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s8),
                      ],
                      Expanded(
                        child: Text(entry.value, style: typography.bodySub),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (entry != spec.entries.last)
              const SizedBox(height: AppSpacing.s8),
          ],
        ],
      ),
    );
  }
}

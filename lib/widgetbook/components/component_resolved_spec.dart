import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// Widgetbook에서 보여줄 공용 spec row
class WidgetbookResolvedSpecEntry {
  /// spec 항목 라벨
  final String label;

  /// 사람이 읽을 값 문자열
  final String value;

  /// 색상 swatch가 필요한 경우 표시할 색
  final Color? swatchColor;

  /// 생성자
  const WidgetbookResolvedSpecEntry({
    required this.label,
    required this.value,
    this.swatchColor,
  });
}

/// Widgetbook에서 보여줄 공용 spec 카드
class WidgetbookResolvedSpecCard extends StatelessWidget {
  /// 카드 제목
  final String title;

  /// spec row 목록
  final List<WidgetbookResolvedSpecEntry> entries;

  /// 생성자
  const WidgetbookResolvedSpecCard({
    super.key,
    this.title = 'Resolved Spec',
    required this.entries,
  });

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
          Text(title, style: typography.main),
          const SizedBox(height: AppSpacing.s16),
          for (final entry in entries) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 140,
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
            if (entry != entries.last) const SizedBox(height: AppSpacing.s8),
          ],
        ],
      ),
    );
  }
}

/// 색상을 HEX 문자열로 변환한다.
String widgetbookColorToHex(Color color) {
  final argb = color.toARGB32();
  final alpha = ((argb >> 24) & 0xFF).toRadixString(16).padLeft(2, '0');
  final red = ((argb >> 16) & 0xFF).toRadixString(16).padLeft(2, '0');
  final green = ((argb >> 8) & 0xFF).toRadixString(16).padLeft(2, '0');
  final blue = (argb & 0xFF).toRadixString(16).padLeft(2, '0');

  if (alpha.toUpperCase() == 'FF') {
    return '#${red.toUpperCase()}${green.toUpperCase()}${blue.toUpperCase()}';
  }

  return '#${alpha.toUpperCase()}'
      '${red.toUpperCase()}'
      '${green.toUpperCase()}'
      '${blue.toUpperCase()}';
}

/// Widgetbook resolved spec에서 semantic color token과 hex를 함께 표시한다.
String widgetbookTokenValue(String tokenName, Color color) {
  return '$tokenName (${widgetbookColorToHex(color)})';
}

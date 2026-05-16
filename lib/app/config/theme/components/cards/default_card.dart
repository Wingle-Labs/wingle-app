import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/wrappers/smooth_rect.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 기본 카드 컴포넌트
class DefaultCard extends ConsumerWidget {
  /// 카드 높이
  final double? height;

  /// 카드 내부 위젯
  final Widget child;

  /// 생성자
  const DefaultCard({super.key, this.height, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.colors;
    return SmoothRectWrapper(
      child: Container(
        decoration: BoxDecoration(
          color: theme.backgroundNormal,
          borderRadius: .circular(AppRadius.iosStyle),
          border: .all(color: theme.strokeStructuralBorder),
        ),
        padding: .all(AppPadding.card),
        height: height,
        child: child,
      ),
    );
  }
}

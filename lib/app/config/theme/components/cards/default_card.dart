import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/wrappers/smooth_rect.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';

/// 기본 카드 컴포넌트
class DefaultCard extends ConsumerWidget {
  /// 높이
  final double? height;

  /// child
  final Widget child;

  /// 생성자
  const DefaultCard({super.key, this.height, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return SmoothRectWrapper(
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppRadius.iosStyle),
          border: Border.all(color: theme.dividerColor),
        ),
        padding: EdgeInsets.all(AppPadding.card),
        height: height,
        child: child,
      ),
    );
  }
}

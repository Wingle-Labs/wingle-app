import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';

/// SmoothRectWrapper
class SmoothRectWrapper extends ConsumerWidget {
  /// 텍스트
  final Widget child;

  /// 생성자
  const SmoothRectWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipSmoothRect(
      radius: SmoothBorderRadius(
        cornerRadius: AppRadius.iosStyle,
        cornerSmoothing: AppRadius.iosSmoothing,
      ),
      child: child,
    );
  }
}

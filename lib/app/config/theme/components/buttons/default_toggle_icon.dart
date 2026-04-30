import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 상태 변화가 필요한 아이콘에 사용하는 토글 아이콘 컴포넌트
class DefaultToggleIcon extends StatelessWidget {
  /// 활성화 여부
  final bool isActive;

  /// 활성화 변경 콜백
  final ValueChanged<bool>? onChanged;

  /// 접근성 라벨
  final String? semanticLabel;

  /// 텍스트 스케일 정책
  final TextScalePolicy scalePolicy;

  /// 생성자
  const DefaultToggleIcon({
    super.key,
    required this.isActive,
    this.onChanged,
    this.semanticLabel,
    this.scalePolicy = TextScalePolicy.cappedMedium,
  });

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final clampedScale = scalePolicy.getScaleFactor(textScale);
    final iconSize = AppContainerSize.toggleIcon * clampedScale;
    final touchSize = AppIconTouchSize.sm * clampedScale;

    return Semantics(
      label: semanticLabel,
      toggled: isActive,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged?.call(!isActive),
          customBorder: const CircleBorder(),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (states) => _ToggleIconOverlay.resolve(states, false, context),
          ),
          child: SizedBox.square(
            dimension: touchSize,
            child: Center(
              child: SizedBox.square(
                dimension: iconSize,
                child: CustomPaint(
                  painter: _ToggleIconPainter(color: _resolveColor(context)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _resolveColor(BuildContext context) {
    final colors = context.colors;
    return isActive ? colors.primaryNormal : colors.textDisable;
  }
}

class _ToggleIconOverlay {
  static Color? resolve(
    Set<WidgetState> states,
    bool disabled,
    BuildContext context,
  ) {
    if (disabled) {
      return null;
    }

    final colors = context.colors;
    if (states.contains(WidgetState.pressed)) {
      return colors.overlayPressed;
    }

    if (states.contains(WidgetState.focused) ||
        states.contains(WidgetState.hovered)) {
      return colors.overlayInactive;
    }

    return null;
  }
}

class _ToggleIconPainter extends CustomPainter {
  final Color color;

  const _ToggleIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppLineWidth.toggleIconBorder;

    final radius = Radius.circular(AppRadius.toggleIcon);
    final rect = RRect.fromRectAndRadius(Offset.zero & size, radius);
    final path = Path()..addRRect(rect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final nextDistance = distance + AppContainerSize.toggleIconDash;
        canvas.drawPath(metric.extractPath(distance, nextDistance), paint);
        distance = nextDistance + AppContainerSize.toggleIconDashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ToggleIconPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

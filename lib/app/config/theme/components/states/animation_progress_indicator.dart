import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 기본 로딩 인디케이터 (커스텀)
/// 세 개의 점이 파동처럼 움직이는 형태
class AnimationProgressIndicator extends StatefulWidget {
  /// 점 색상
  final Color? color;

  /// 영역 높이
  final double height;

  /// 생성자
  const AnimationProgressIndicator({
    super.key,
    this.color,
    this.height = AppContainerSize.indicatorContainer,
  });

  @override
  State<AnimationProgressIndicator> createState() =>
      _AnimationProgressIndicatorState();
}

class _AnimationProgressIndicatorState extends State<AnimationProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _scale(double t, double start) {
    final progress = (t - start) % 1.0;
    if (progress < 0.5) {
      return 0.6 + progress * 0.8;
    } else {
      return 1.0 - (progress - 0.5) * 0.8;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? context.colors.primaryNormal;

    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dot(color, _scale(t, 0.0)),
              const SizedBox(width: AppPadding.indicator),
              _dot(color, _scale(t, 0.2)),
              const SizedBox(width: AppPadding.indicator),
              _dot(color, _scale(t, 0.4)),
            ],
          );
        },
      ),
    );
  }

  Widget _dot(Color color, double scale) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: AppContainerSize.indicator,
        height: AppContainerSize.indicator,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

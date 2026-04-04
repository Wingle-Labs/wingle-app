import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 디자인 시스템 기본 아이콘 버튼
class DefaultIconButton extends StatelessWidget {
  /// 아이콘
  final Widget icon;

  /// 아이콘 버튼 클릭 시 실행될 콜백
  final VoidCallback? onPressed;

  /// 아이콘 버튼 크기
  final double size;

  /// 아이콘 버튼 색상
  final Color? color;

  /// 아이콘 버튼 테두리
  final BorderSide? borderSide;

  /// 비활성화 여부
  final bool isEnabled;

  /// 생성자
  const DefaultIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = AppIconSize.large,
    this.color,
    this.borderSide,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scale = MediaQuery.textScalerOf(context).scale(1.0);
    final clampedScale = TextScalePolicy.cappedLarge.getScaleFactor(scale);
    return IconButton(
      onPressed: isEnabled ? onPressed : null,
      icon: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Transform.scale(scale: clampedScale, child: icon),
        ),
      ),
      color: color,
      splashColor: colors.overlayPressed,
      hoverColor: colors.overlayPressed,
      disabledColor: colors.overlayDisabled,
    );
  }
}

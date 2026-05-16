import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/icons/default_icon.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';

/// 아이콘 glyph를 frame 안에 배치하는 공용 슬롯
class DefaultIconSlot extends StatelessWidget {
  /// slot/frame 크기
  final double frameSize;

  /// glyph 크기
  final double glyphSize;

  /// 아이콘 데이터
  final IconData? icon;

  /// 직접 주입할 위젯
  final Widget? child;

  /// 아이콘 색상
  final Color color;

  /// 생성자
  const DefaultIconSlot({
    super.key,
    required this.frameSize,
    required this.glyphSize,
    required this.color,
    this.icon,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: frameSize,
      child: Center(
        child: child == null
            ? DefaultIcon(icon: icon as IconData, size: glyphSize, color: color)
            : ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.buttonIconSlot),
                child: child,
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 기본 아이콘 상태
enum DefaultIconState {
  /// 일반 상태
  normal,

  /// 선택 상태
  selected,

  /// 비활성화 상태
  disabled,
}

/// 앱 전역에서 사용하는 기본 아이콘 위젯
class DefaultIcon extends StatelessWidget {
  /// 아이콘 데이터
  final IconData icon;

  /// 아이콘 상태
  final DefaultIconState state;

  /// 아이콘 크기
  final double size;

  /// 직접 지정 색상
  final Color? color;

  /// 접근성 라벨
  final String? semanticLabel;

  /// 생성자
  const DefaultIcon({
    super.key,
    required this.icon,
    this.state = DefaultIconState.normal,
    this.size = AppIconSize.md,
    this.color,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? _resolveColor(context);

    return Icon(
      icon,
      size: size,
      color: resolvedColor,
      semanticLabel: semanticLabel,
    );
  }

  Color _resolveColor(BuildContext context) {
    final colors = context.colors;

    return switch (state) {
      .normal => colors.textAlternative,
      .selected => colors.primaryNormal,
      .disabled => colors.textDisable,
    };
  }
}

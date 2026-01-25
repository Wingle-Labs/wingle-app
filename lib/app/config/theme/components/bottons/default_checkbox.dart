import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 앱 전역에서 사용하는 기본 체크박스 컴포넌트
class DefaultCheckbox extends StatelessWidget {
  /// 체크 여부
  final bool isChecked;

  /// 체크 변경 콜백
  final Function(bool)? onChanged;

  /// 비활성화 여부
  final bool isDisabled;

  /// semantic label
  final String? semanticLabel;

  /// 생성자
  const DefaultCheckbox({
    super.key,
    required this.isChecked,
    this.onChanged,
    this.isDisabled = false,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Transform.scale(
      scale: 4,
      child: Checkbox(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.checkboxRadius),
        ),
        activeColor: colors.primary,
        value: isChecked,
        onChanged: isDisabled
            ? null
            : (value) {
                if (value == null) return;
                onChanged?.call(value);
              },
        semanticLabel: semanticLabel,
      ),
    );
  }
}

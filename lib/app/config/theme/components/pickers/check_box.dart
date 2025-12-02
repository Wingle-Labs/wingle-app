import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/constants/color.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';

/// 기본 체크박스
class DefaultCheckBox extends ConsumerWidget {
  /// 값
  final bool value;

  /// 변경 이벤트
  final ValueChanged<bool?> onChanged;

  /// 생성자
  const DefaultCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Checkbox(
      value: value,
      onChanged: onChanged,
      checkColor: theme.scaffoldBackgroundColor,
      activeColor: AppColor.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.iosStyle),
      ),
    );
  }
}

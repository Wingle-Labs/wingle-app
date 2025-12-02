import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/pickers/check_box.dart';

/// 동의 체크박스 및 텍스트
class AgreementGroup extends ConsumerWidget {
  /// 텍스트
  final String text;

  /// 값
  final bool value;

  /// 변경 이벤트
  final ValueChanged<bool?> onChanged;

  /// 생성자
  const AgreementGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required this.text,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: .start,
      children: [
        DefaultCheckBox(value: value, onChanged: onChanged),
        Expanded(child: Text(text.tr())),
      ],
    );
  }
}

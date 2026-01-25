import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/bottons/default_checkbox.dart';
import 'package:wingle/app/config/theme/components/wrappers/smooth_rect.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';

/// 동의 체크박스 및 텍스트
class AgreementGroup extends ConsumerWidget {
  /// 텍스트
  final String text;

  /// 값
  final bool value;

  /// 변경 이벤트
  final ValueChanged<bool?> onChanged;

  /// 번역 여부
  final bool? isTranslated;

  /// 생성자
  const AgreementGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required this.text,
    this.isTranslated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SmoothRectWrapper(
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: AppRadius.iosStyleRadius,
        child: Row(
          mainAxisAlignment: .start,
          children: [
            DefaultCheckbox(isChecked: value, onChanged: onChanged),
            Expanded(child: Text(isTranslated == true ? text.tr() : text)),
          ],
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/buttons/loadding_text_button.dart';
import 'package:wingle/app/config/theme/constants/color.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';

/// 기본 플로팅 버튼
class DefaultFloatingButton extends ConsumerWidget {
  /// onPressed
  final VoidCallback? onPressed;

  /// label
  final String label;

  /// isLoading
  final bool isLoading;

  /// disabled
  final bool? disabled;

  /// 생성자
  const DefaultFloatingButton({
    super.key,
    this.onPressed,
    required this.label,
    this.isLoading = false,
    this.disabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      elevation: 0,
      backgroundColor: disabled == true
          ? AppColor.disabledDark
          : AppColor.lightPrimary,
      extendedPadding: .zero,
      onPressed: disabled == true ? null : onPressed,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.iosStyleRadius),
      label: LoadingTextButton(label: label.tr(), isLoading: isLoading),
      autofocus: true,
    );
  }
}

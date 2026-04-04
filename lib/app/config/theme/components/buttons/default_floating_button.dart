import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/buttons/loadding_text_button.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/common/extensions/context_colors.dart';

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
    final color = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.scaffold),
      child: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: (disabled == true || isLoading == true)
            ? color.interactionDisable
            : color.primaryNormal,
        splashColor: color.overlayPressed,
        extendedPadding: .zero,
        onPressed: disabled == true || isLoading == true ? null : onPressed,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.iosStyleRadius),
        label: LoadingTextButton(label: label, isLoading: isLoading),
        autofocus: true,
        enableFeedback: true,
      ),
    );
  }
}

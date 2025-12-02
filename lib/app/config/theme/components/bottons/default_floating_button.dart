import 'package:easy_localization/easy_localization.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/bottons/loadding_text_button.dart';
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

  /// 생성자
  const DefaultFloatingButton({
    super.key,
    this.onPressed,
    required this.label,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      elevation: 0,
      backgroundColor: AppColor.primary,
      extendedPadding: .zero,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: AppRadius.iosStyle,
          cornerSmoothing: AppRadius.iosSmoothing,
        ),
      ),
      label: LoadingTextButton(label: label.tr(), isLoading: isLoading),
    );
  }
}

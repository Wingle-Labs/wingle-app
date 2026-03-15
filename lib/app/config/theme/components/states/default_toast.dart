import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 기본 토스트 메시지 표시 클래스
class DefaultToast {
  /// 토스트 메시지를 표시합니다.
  static void show(BuildContext context, String message, {Duration? duration}) {
    final messenger = ScaffoldMessenger.of(context);
    final color = context.colors;

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        backgroundColor: color.backgroundElevatedNormal,
        content: DefaultText(message, color: color.textNormal),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppPadding.card),
        duration: duration ?? const Duration(seconds: 2),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/components/states/keyboard_avoiding_popup.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 기본 로딩 다이얼로그
class DefaultLoaddingDialog {
  /// 로딩 다이얼로그를 표시합니다.
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: context.colors.overlayLoading,
      builder: (_) => const KeyboardAvoidingPopup(
        child: Center(child: AnimationProgressIndicator()),
      ),
    );
  }

  /// 함수 실행 중 로딩 다이얼로그를 표시합니다.
  static Future<T> showWhileExecuting<T>(
    BuildContext context,
    Future<T> Function() function,
  ) async {
    show(context);

    try {
      return await function();
    } finally {
      if (context.mounted) {
        hide(context);
      }
    }
  }

  /// 로딩 다이얼로그를 닫습니다.
  static void hide(BuildContext context) {
    if (context.mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}

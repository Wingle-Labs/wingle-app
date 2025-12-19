import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';

/// 앱 전역에서 사용되는 커스텀 ElevatedButton
class DefaultElevatedButton extends ConsumerWidget {
  /// 버튼 내부 내용
  final Widget child;

  /// 버튼 클릭 시 실행될 콜백
  final VoidCallback onPressed;

  /// 버튼 배경색
  final Color? backgroundColor;

  /// 버튼 전경 색상
  final Color? foregroundColor;

  /// 테두리 스타일
  final BorderSide? borderSide;

  /// 생성자
  const DefaultElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? theme.primaryColor,
        foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
        shadowColor: theme.shadowColor,
        side: borderSide,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.iosStyleRadius),
        minimumSize: const Size(
          AppContainerSize.buttonMinimun,
          AppContainerSize.buttonMinimun,
        ),
        padding: const .all(AppPadding.button),
      ),
      child: child,
    );
  }
}

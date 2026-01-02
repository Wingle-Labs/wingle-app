import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/weight.dart';

/// 디자인 시스템 기본 버튼
class DefaultButton extends ConsumerWidget {
  /// 버튼 내부 내용
  final String label;

  /// 버튼 클릭 시 실행될 콜백
  final VoidCallback? onPressed;

  /// 기본 배경색
  final Color backgroundColor;

  /// 눌렸을 때 배경색 (overlay)
  final Color pressedColor;

  /// 텍스트 색상
  final Color textColor;

  /// 버튼 테두리
  final BorderSide? borderSide;

  /// const 생성자
  const DefaultButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.pressedColor,
    required this.textColor,
    required this.onPressed,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.iosStyleRadius,
        side: borderSide ?? .none,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.iosStyleRadius,
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.pressed)) return pressedColor;
          return null;
        }),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: AppContainerSize.buttonMinimun,
            minHeight: AppContainerSize.buttonMinimun,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppFontSize.button),
            child: Center(
              child: Text(
                label.tr(),
                style: TextStyle(
                  fontSize: AppFontSize.button,
                  fontWeight: AppFontWeight.semiBold,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

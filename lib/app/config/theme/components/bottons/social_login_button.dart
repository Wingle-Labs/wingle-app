import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';

/// 공통 소셜 로그인 버튼
class SocialLoginButton extends ConsumerWidget {
  /// 로그인 버튼의 아이콘
  final Widget symbol;

  /// 아이콘의 색상
  final Color? symbolColor;

  /// 버튼에 표시할 텍스트
  final String text;

  /// 버튼 텍스트 색상
  final Color? textColor;

  /// 버튼을 눌렀을 때 호출되는 콜백 함수
  final VoidCallback onPressed;

  /// 버튼의 배경색
  final Color? bgColor;

  /// 버튼의 정렬 방식
  final bool center;

  /// 테두리 버튼
  final bool outlined;

  /// 테두리 버튼의 색상
  final Color? borderColor;

  /// 생성자
  const SocialLoginButton({
    super.key,
    required this.symbol,
    this.symbolColor,
    required this.text,
    this.textColor,
    required this.onPressed,
    this.bgColor,
    this.center = false,
    this.outlined = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return outlined
        ? _outlinedButton(_child(onPressed, context), onPressed, context)
        : _filledButton(_child(onPressed, context), onPressed, context);
  }

  /// 버튼을 생성하는 메소드
  Widget _child(VoidCallback onPressed, BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: .start,
      children: [
        IconTheme(
          data: IconThemeData(
            color: symbolColor ?? theme.colorScheme.onPrimary,
            size: AppIconSize.large,
          ),
          child: SizedBox(
            width: AppIconSize.large,
            height: AppIconSize.large,
            child: symbol,
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: .symmetric(horizontal: AppPadding.button),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: AppFontSize.medium,
                  color: textColor ?? theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Outlined 버튼을 생성하는 메소드
  Widget _outlinedButton(
    Widget child,
    VoidCallback onPressed,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: bgColor ?? theme.scaffoldBackgroundColor,
        padding: .all(AppPadding.button),
        shape: RoundedRectangleBorder(borderRadius: .circular(AppRadius.md)),
        side: BorderSide(color: borderColor ?? theme.primaryColor),
      ),
      child: child,
    );
  }

  /// Filled 버튼을 생성하는 메소드
  Widget _filledButton(
    Widget child,
    VoidCallback onPressed,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: bgColor ?? theme.primaryColor,
        padding: .all(AppPadding.button),
        shape: RoundedRectangleBorder(borderRadius: .circular(AppRadius.md)),
      ),
      child: child,
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/constants/size.dart';

/// 앱 전역에서 사용할 텍스트 버튼 공통 컴포넌트
class DefaultTextButton extends ConsumerWidget {
  /// 버튼을 누를 시 호출할 함수
  final VoidCallback onPressed;

  /// 버튼에 표시할 텍스트 (localization key)
  final String text;

  /// 버튼의 텍스트 색상
  final Color? textColor;

  /// const 생성자
  const DefaultTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: () => onPressed(),
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? theme.primaryColor,
        minimumSize: Size(
          AppContainerSize.buttonMinimun,
          AppContainerSize.buttonMinimun,
        ),
      ),
      child: Text(text).tr(),
    );
  }
}

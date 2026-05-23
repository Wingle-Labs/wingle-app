import 'package:flutter/material.dart';

const Duration _keyboardInsetAnimationDuration = Duration(milliseconds: 180);
const Curve _keyboardInsetAnimationCurve = Curves.easeOutCubic;

/// 키보드가 올라올 때 팝업이 키보드와 겹치지 않도록 하단 inset을 반영합니다.
class KeyboardAvoidingPopup extends StatelessWidget {
  /// 하단 inset을 적용할 팝업 본문.
  final Widget child;

  /// 생성자.
  const KeyboardAvoidingPopup({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: _keyboardInsetAnimationDuration,
      curve: _keyboardInsetAnimationCurve,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: child,
    );
  }
}

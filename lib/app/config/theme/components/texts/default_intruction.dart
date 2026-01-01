import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/size.dart';

/// 기본 설명 텍스트
class DefaultInstruction extends ConsumerWidget {
  /// localization 키
  final String text;

  /// 생성자
  const DefaultInstruction(this.text, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: .symmetric(vertical: AppPadding.vertical),
      child: Text(text.tr(), style: TextStyle(fontSize: AppFontSize.title)),
    );
  }
}

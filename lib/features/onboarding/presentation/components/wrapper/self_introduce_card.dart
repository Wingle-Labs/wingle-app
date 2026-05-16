import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/cards/default_card.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';

/// 자기소개 그룹
class SelfIntroduceCard extends ConsumerWidget {
  /// 메인 타이틀
  final String title;

  /// 입력 위젯
  final Widget child;

  /// 생성자
  const SelfIntroduceCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultCard(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          DefaultText(title, style: TextStyle(fontSize: AppFontSize.subtitle)),
          Padding(padding: .only(bottom: AppSpacing.s24)),
          child,
        ],
      ),
    );
  }
}

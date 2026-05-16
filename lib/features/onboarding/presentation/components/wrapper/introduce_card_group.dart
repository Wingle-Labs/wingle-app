import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/text_fields/multiline_text_field.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/self_introduce_card.dart';

/// 자기소개 그룹
class IntroduceCardGroup extends ConsumerWidget {
  /// 질문 목록
  final List<String> questions;

  /// 생성자
  const IntroduceCardGroup({super.key, required this.questions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: AppSpacing.s32,
      children: questions
          .map(
            (question) => SelfIntroduceCard(
              title: question,
              child: MultilineTextField(
                helper: 'common.helper.selfIntroMinLength',
              ),
            ),
          )
          .toList(),
    );
  }
}

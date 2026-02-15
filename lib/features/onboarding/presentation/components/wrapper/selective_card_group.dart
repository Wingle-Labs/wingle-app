import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/self_introduce_card.dart';

/// 선택형 자기소개 그룹
class SelectiveCardGroup extends ConsumerWidget {
  /// 질문
  final String question;

  /// 답변 목록
  final List<String> answers;

  /// 답변 상태
  final List<bool> answersState;

  /// 답변 상태 변경 콜백
  final Function(List<bool>) onAnswersStateChange;

  /// 생성자
  const SelectiveCardGroup({
    super.key,
    required this.question,
    required this.answers,
    required this.answersState,
    required this.onAnswersStateChange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SelfIntroduceCard(
      title: question,
      child: Column(
        spacing: AppSpacing.sm,
        // children: answers
        //     .map(
        //       (answer) => AgreementGroup(
        //         value: answersState[answers.indexOf(answer)],
        //         onChanged: (value) {
        //           onAnswersStateChange(
        //             answersState.map((state) => state).toList(),
        //           );
        //         },
        //         text: answer,
        //       ),
        //     )
        //     .toList(),
      ),
    );
  }
}

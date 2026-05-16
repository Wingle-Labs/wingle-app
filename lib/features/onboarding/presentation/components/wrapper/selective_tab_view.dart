import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/selective_card_group.dart';
import 'package:wingle/features/onboarding/presentation/data/selective_self_intro_mock_data.dart';

/// 선택형 자기소개 탭 뷰
class SelectiveTabView extends ConsumerWidget {
  /// 생성자
  const SelectiveTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const .all(AppPadding.scaffold),
      child: Column(
        spacing: AppSpacing.s24,
        children: [
          ...selectiveSelfIntroQuestionMocks.map(
            (question) => SelectiveCardGroup(
              question: question.questionKey,
              answers: question.answerKeys,
              answersState: question.answerStates,
              onAnswersStateChange: (answersState) {},
            ),
          ),
          Padding(padding: .only(bottom: AppSpacing.bottom)),
        ],
      ),
    );
  }
}

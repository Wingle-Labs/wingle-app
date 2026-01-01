import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/selective_card_group.dart';

/// 선택형 자기소개 탭 뷰
class SelectiveTabView extends ConsumerWidget {
  /// 생성자
  const SelectiveTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Repository 패턴 구현
    final questions = {
      '첫번째 질문: 1': [('답변 1', true), ('답변 2', false), ('답변 3', false)],
      '두번째 질문: 2': [('답변 1', false), ('답변 2', false), ('답변 3', true)],
      '세번째 질문: 3': [
        ('답변 1', true),
        ('답변 2', false),
        ('멀티 라인 답변의 UI를 확인하기 위해 장문으로 작성된 목업 답변', false),
      ],
    };
    return SingleChildScrollView(
      padding: const .all(AppPadding.scaffold),
      child: Column(
        spacing: AppSpacing.md,
        children: [
          ...questions.entries.map(
            (question) => SelectiveCardGroup(
              question: question.key,
              answers: question.value.map((answer) => answer.$1).toList(),
              answersState: question.value.map((answer) => answer.$2).toList(),
              onAnswersStateChange: (answersState) {},
            ),
          ),
          Padding(padding: .only(bottom: AppSpacing.bottom)),
        ],
      ),
    );
  }
}

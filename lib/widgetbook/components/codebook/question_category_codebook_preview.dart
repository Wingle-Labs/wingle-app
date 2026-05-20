import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';

/// Question Category 코드북과 choice-questions 응답 관계를 보여주는 미리보기.
class QuestionCategoryCodebookPreview extends StatelessWidget {
  /// 코드북 스냅샷.
  final CodeSnapshot snapshot;

  /// 카테고리별 현재 버전.
  final Map<String, int> currentVersions;

  /// 카테고리별 질문 세트 스냅샷.
  final Map<String, ChoiceQuestionSetSnapshot> choiceSnapshots;

  /// 생성자.
  const QuestionCategoryCodebookPreview({
    super.key,
    required this.snapshot,
    required this.currentVersions,
    required this.choiceSnapshots,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'QUESTION_CATEGORY · v${snapshot.version}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            for (final code in snapshot.codes) ...[
              _QuestionCategoryCard(
                code: code.code,
                codeName: code.codeName,
                version: currentVersions[code.code],
                snapshot: choiceSnapshots[code.code],
              ),
              if (code != snapshot.codes.last) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuestionCategoryCard extends StatelessWidget {
  final String code;
  final String codeName;
  final int? version;
  final ChoiceQuestionSetSnapshot? snapshot;

  const _QuestionCategoryCard({
    required this.code,
    required this.codeName,
    required this.version,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    final questions = snapshot?.questions ?? const <ChoiceQuestionDetail>[];

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$codeName ($code)'),
            const SizedBox(height: 4),
            Text(version == null ? '버전 없음' : 'v$version'),
            const SizedBox(height: AppSpacing.s12),
            if (questions.isEmpty)
              const Text('질문 스냅샷이 없습니다.')
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final question in questions) ...[
                    Text(
                      'Q${question.id}. ${question.content}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      question.options
                          .map((option) => option.content)
                          .join(' / '),
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

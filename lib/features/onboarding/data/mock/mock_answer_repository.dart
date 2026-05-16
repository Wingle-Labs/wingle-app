import 'package:wingle/features/onboarding/domain/model/answer/answer_models.dart';
import 'package:wingle/features/onboarding/domain/repository/answer_repository.dart';

/// 답변 Repository Mock 구현.
class MockAnswerRepository implements AnswerRepository {
  /// 생성자
  const MockAnswerRepository();

  @override
  Future<List<ChoiceAnswerResult>> fetchChoiceAnswers() async {
    return const [
      ChoiceAnswerResult(
        questionId: 1,
        questionContent: '좋아하는 데이트 장소는?',
        optionId: 1,
        optionContent: '카페',
      ),
    ];
  }

  @override
  Future<void> saveChoiceAnswers({
    required List<ChoiceAnswerItem> answers,
  }) async {}

  @override
  Future<List<EssayAnswerResult>> fetchEssayAnswers() async {
    return const [
      EssayAnswerResult(
        questionId: 1,
        questionContent: '자신을 소개해주세요.',
        isRequired: true,
        content: '안녕하세요.',
      ),
    ];
  }

  @override
  Future<void> saveEssayAnswers({
    required List<EssayAnswerItem> answers,
  }) async {}
}

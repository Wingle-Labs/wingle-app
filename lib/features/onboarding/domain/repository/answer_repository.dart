import 'package:wingle/features/onboarding/domain/model/answer/answer_models.dart';

/// 답변 Repository.
abstract class AnswerRepository {
  /// 내 객관식 답변을 조회한다.
  Future<List<ChoiceAnswerResult>> fetchChoiceAnswers();

  /// 객관식 답변을 저장한다.
  Future<void> saveChoiceAnswers({required List<ChoiceAnswerItem> answers});

  /// 내 주관식 답변을 조회한다.
  Future<List<EssayAnswerResult>> fetchEssayAnswers();

  /// 주관식 답변을 저장한다.
  Future<void> saveEssayAnswers({required List<EssayAnswerItem> answers});
}

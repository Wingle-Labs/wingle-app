import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';

/// 코드북 Repository.
abstract class CodebookRepository {
  /// 약관 스냅샷을 조회한다.
  Future<TermSnapshot> fetchTermsSnapshot();

  /// 현재 약관 버전을 조회한다.
  Future<Map<String, int>> fetchTermsCurrentVersions();

  /// 공통 코드 스냅샷을 조회한다.
  Future<Map<String, CodeSnapshot>> fetchCodebookSnapshot({
    required List<String> groups,
  });

  /// 공통 코드 현재 버전을 조회한다.
  Future<Map<String, int>> fetchCodebookCurrentVersions();

  /// 객관식 질문 스냅샷을 조회한다.
  Future<Map<String, ChoiceQuestionSetSnapshot>> fetchChoiceQuestionSnapshot({
    required List<String> categories,
  });

  /// 객관식 질문 현재 버전을 조회한다.
  Future<Map<String, int>> fetchChoiceQuestionCurrentVersions();

  /// 주관식 질문 스냅샷을 조회한다.
  Future<EssayQuestionSnapshot> fetchEssayQuestionSnapshot();

  /// 주관식 질문 현재 버전을 조회한다.
  Future<CurrentVersionResponse> fetchEssayQuestionCurrentVersion();
}

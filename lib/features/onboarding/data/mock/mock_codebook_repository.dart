import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/domain/repository/codebook_repository.dart';

/// 코드북 Repository Mock 구현.
class MockCodebookRepository implements CodebookRepository {
  /// 생성자
  const MockCodebookRepository();

  @override
  Future<TermSnapshot> fetchTermsSnapshot() async {
    return const TermSnapshot(
      version: 1,
      terms: [
        TermDetail(
          type: 'TOS',
          content: '# 서비스 이용약관',
          isRequired: true,
          version: 1,
        ),
      ],
    );
  }

  @override
  Future<Map<String, int>> fetchTermsCurrentVersions() async {
    return const {'TOS': 1};
  }

  @override
  Future<Map<String, CodeSnapshot>> fetchCodebookSnapshot({
    required List<String> groups,
  }) async {
    return {
      for (final group in groups)
        group: group == 'BODY_TYPE'
            ? const CodeSnapshot(
                version: 1,
                codes: [
                  CommonCodeDetail(
                    code: 'BT_F_001',
                    codeName: '슬림',
                    parentCode: 'BT_FEMALE',
                    displayOrder: 1,
                  ),
                  CommonCodeDetail(
                    code: 'BT_F_002',
                    codeName: '보통',
                    parentCode: 'BT_FEMALE',
                    displayOrder: 2,
                  ),
                  CommonCodeDetail(
                    code: 'BT_F_003',
                    codeName: '볼륨',
                    parentCode: 'BT_FEMALE',
                    displayOrder: 3,
                  ),
                  CommonCodeDetail(
                    code: 'BT_F_004',
                    codeName: '체구 있음',
                    parentCode: 'BT_FEMALE',
                    displayOrder: 4,
                  ),
                  CommonCodeDetail(
                    code: 'BT_F_005',
                    codeName: '공개 안함',
                    parentCode: 'BT_FEMALE',
                    displayOrder: 5,
                  ),
                  CommonCodeDetail(
                    code: 'BT_M_001',
                    codeName: '슬림',
                    parentCode: 'BT_MALE',
                    displayOrder: 1,
                  ),
                  CommonCodeDetail(
                    code: 'BT_M_002',
                    codeName: '보통',
                    parentCode: 'BT_MALE',
                    displayOrder: 2,
                  ),
                  CommonCodeDetail(
                    code: 'BT_M_003',
                    codeName: '탄탄',
                    parentCode: 'BT_MALE',
                    displayOrder: 3,
                  ),
                  CommonCodeDetail(
                    code: 'BT_M_004',
                    codeName: '체격 있음',
                    parentCode: 'BT_MALE',
                    displayOrder: 4,
                  ),
                  CommonCodeDetail(
                    code: 'BT_M_005',
                    codeName: '공개 안함',
                    parentCode: 'BT_MALE',
                    displayOrder: 5,
                  ),
                ],
              )
            : const CodeSnapshot(
                version: 1,
                codes: [
                  CommonCodeDetail(
                    code: 'CODE_001',
                    codeName: '목업 코드',
                    displayOrder: 1,
                  ),
                ],
              ),
    };
  }

  @override
  Future<Map<String, int>> fetchCodebookCurrentVersions() async {
    return const {'BODY_TYPE': 1};
  }

  @override
  Future<Map<String, ChoiceQuestionSetSnapshot>> fetchChoiceQuestionSnapshot({
    required List<String> categories,
  }) async {
    return {
      for (final category in categories)
        category: const ChoiceQuestionSetSnapshot(
          version: 1,
          questions: [
            ChoiceQuestionDetail(
              id: 1,
              content: '좋아하는 데이트 장소는?',
              options: [ChoiceQuestionOption(id: 1, content: '카페')],
            ),
          ],
        ),
    };
  }

  @override
  Future<Map<String, int>> fetchChoiceQuestionCurrentVersions() async {
    return const {'QC_LOVE': 1};
  }

  @override
  Future<EssayQuestionSnapshot> fetchEssayQuestionSnapshot() async {
    return const EssayQuestionSnapshot(
      version: 1,
      questions: [
        EssayQuestionDetail(
          id: 1,
          content: '자신을 소개해주세요.',
          isRequired: true,
          sortOrder: 1,
        ),
      ],
    );
  }

  @override
  Future<CurrentVersionResponse> fetchEssayQuestionCurrentVersion() async {
    return const CurrentVersionResponse(version: 1);
  }
}

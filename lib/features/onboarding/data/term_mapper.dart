import 'package:wingle/features/onboarding/data/term_dto.dart';
import 'package:wingle/features/onboarding/presentation/models/agreement_item.dart';

/// [TermDto]를 [AgreementItemModel]으로 변환하는 매퍼.
class TermMapper {
  const TermMapper._();

  /// DTO → Presentation 모델 변환
  static AgreementItemModel toAgreementItem(TermDto dto) {
    return AgreementItemModel(
      id: dto.id,
      title: dto.title,
      content: dto.content,
      isRequired: dto.isRequire,
      version: dto.version,
    );
  }
}

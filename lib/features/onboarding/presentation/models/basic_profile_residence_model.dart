import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';

/// 기본 프로필 거주지 입력 화면 상태 모델.
class BasicProfileResidenceModel {
  static const Object _unset = Object();

  /// 입력한 거주지 검색어
  final String query;

  /// 매핑된 거주지 코드
  final ResidenceCode? residenceCode;

  /// 생성자
  const BasicProfileResidenceModel({this.query = '', this.residenceCode});

  /// 다음 단계로 진행 가능한지 여부
  bool get canContinue => residenceCode != null;

  /// 복사
  BasicProfileResidenceModel copyWith({
    String? query,
    Object? residenceCode = _unset,
  }) {
    return BasicProfileResidenceModel(
      query: query ?? this.query,
      residenceCode: identical(residenceCode, _unset)
          ? this.residenceCode
          : residenceCode as ResidenceCode?,
    );
  }
}

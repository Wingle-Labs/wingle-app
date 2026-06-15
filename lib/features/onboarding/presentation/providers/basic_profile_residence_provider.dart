import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';
import 'package:wingle/features/onboarding/presentation/models/basic_profile_residence_model.dart';

part 'basic_profile_residence_provider.g.dart';

/// 기본 프로필 거주지 입력 상태 관리 Notifier.
@Riverpod(keepAlive: true)
class BasicProfileResidence extends _$BasicProfileResidence {
  @override
  BasicProfileResidenceModel build() => const BasicProfileResidenceModel();

  /// 거주지 검색어를 갱신한다.
  ///
  /// 실제 거주지 코드는 REGION 코드북 선택을 통해서만 저장한다.
  void updateQuery(String value) {
    if (state.query == value && state.residenceCode == null) {
      return;
    }

    state = state.copyWith(query: value, residenceCode: null);
  }

  /// 거주지 선택을 초기화한다.
  void clear() {
    state = const BasicProfileResidenceModel();
  }

  /// 거주지 코드를 직접 설정한다.
  void selectResidenceCode(ResidenceCode residenceCode, {String? query}) {
    state = state.copyWith(
      query: query ?? state.query,
      residenceCode: residenceCode,
    );
  }
}

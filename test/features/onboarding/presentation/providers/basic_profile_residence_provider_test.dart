import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_provider.dart';

void main() {
  test('거주지 검색어만 입력하면 코드 선택 전까지 진행할 수 없다', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(basicProfileProvider.notifier);

    notifier.updateResidenceQuery('서울특별시 강남구');

    final state = container.read(basicProfileProvider);

    expect(state.residenceQuery, '서울특별시 강남구');
    expect(state.residenceCode, isNull);
    expect(state.canContinueResidence, isFalse);
  });

  test('REGION 코드북에서 선택된 거주지 코드를 저장한다', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(basicProfileProvider.notifier);

    notifier.selectResidenceCode(
      const ResidenceCode(
        level1: 'R_11',
        level2: 'R_11680',
        level3: 'R_11680103',
      ),
      query: '서울특별시 강남구 개포동',
    );

    final state = container.read(basicProfileProvider);

    expect(state.residenceQuery, '서울특별시 강남구 개포동');
    expect(state.residenceCode?.level1, 'R_11');
    expect(state.residenceCode?.level2, 'R_11680');
    expect(state.residenceCode?.level3, 'R_11680103');
    expect(state.canContinueResidence, isTrue);
  });

  test('거주지 상태를 초기화할 수 있다', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(basicProfileProvider.notifier);

    notifier.selectResidenceCode(
      const ResidenceCode(
        level1: 'R_11',
        level2: 'R_11680',
        level3: 'R_11680103',
      ),
      query: '서울특별시 강남구 개포동',
    );
    notifier.clearResidence();

    final state = container.read(basicProfileProvider);

    expect(state.residenceQuery, isEmpty);
    expect(state.residenceCode, isNull);
    expect(state.canContinueResidence, isFalse);
  });
}

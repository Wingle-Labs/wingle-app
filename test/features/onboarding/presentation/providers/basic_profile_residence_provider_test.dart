import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_provider.dart';

void main() {
  test('거주지 검색어를 입력하면 목업 코드가 함께 저장된다', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(basicProfileProvider.notifier);

    notifier.updateResidenceQuery('서울특별시 강남구');

    final state = container.read(basicProfileProvider);

    expect(state.residenceQuery, '서울특별시 강남구');
    expect(state.residenceCode, isNotNull);
    expect(state.residenceCode!.level1, hasLength(3));
    expect(state.residenceCode!.level2, hasLength(5));
    expect(state.residenceCode!.level3, hasLength(8));
    expect(state.canContinueResidence, isTrue);
  });

  test('거주지 상태를 초기화할 수 있다', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(basicProfileProvider.notifier);

    notifier.updateResidenceQuery('서울특별시 강남구');
    notifier.clearResidence();

    final state = container.read(basicProfileProvider);

    expect(state.residenceQuery, isEmpty);
    expect(state.residenceCode, isNull);
    expect(state.canContinueResidence, isFalse);
  });
}

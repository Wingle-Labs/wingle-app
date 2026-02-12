import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:wingle/features/onboarding/data/mock/mock_term_repository.dart';
import 'package:wingle/features/onboarding/presentation/providers/agreement_state_notifier.dart';
import 'package:wingle/features/onboarding/presentation/providers/term_repository_provider.dart';

void main() {
  group('AgreementStateNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          termRepositoryProvider.overrideWithValue(const MockTermRepository()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('초기 로딩 시 약관 목록이 정상적으로 로드된다', () async {
      final result = await container.read(agreementStateProvider.future);

      expect(result.isNotEmpty, true);
      expect(result.length, 3);
    });

    test('개별 약관 토글이 정상 동작한다', () async {
      await container.read(agreementStateProvider.future);

      final notifier = container.read(agreementStateProvider.notifier);

      notifier.toggleAgreement(1);

      final state = await container.read(agreementStateProvider.future);

      expect(state.firstWhere((e) => e.id == 1).isChecked, true);
    });

    test('전체 동의가 정상 동작한다', () async {
      await container.read(agreementStateProvider.future);

      final notifier = container.read(agreementStateProvider.notifier);

      notifier.toggleAll(true);

      final state = await container.read(agreementStateProvider.future);

      expect(state.every((e) => e.isChecked), true);
    });

    test('필수 약관 검증 로직이 정상 동작한다', () async {
      await container.read(agreementStateProvider.future);

      final notifier = container.read(agreementStateProvider.notifier);

      // 필수 약관만 체크
      notifier.toggleAgreement(1);
      notifier.toggleAgreement(2);

      expect(notifier.isRequiredSatisfied(), true);
    });

    test('필수 약관이 하나라도 체크되지 않으면 false', () async {
      await container.read(agreementStateProvider.future);

      final notifier = container.read(agreementStateProvider.notifier);

      notifier.toggleAgreement(1); // 하나만 체크

      expect(notifier.isRequiredSatisfied(), false);
    });
  });
}

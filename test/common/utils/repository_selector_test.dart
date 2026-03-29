import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/common/utils/repository_selector.dart';

void main() {
  group('RepositorySelector', () {
    test('준비되지 않은 API는 source와 무관하게 mock을 사용한다', () {
      expect(
        RepositorySelector.shouldUseMock(
          isApiReady: false,
          source: RepositorySource.live,
        ),
        isTrue,
      );
      expect(
        RepositorySelector.shouldUseMock(
          isApiReady: false,
          source: RepositorySource.mock,
        ),
        isTrue,
      );
    });

    test('준비된 API는 source가 mock일 때만 mock을 사용한다', () {
      expect(
        RepositorySelector.shouldUseMock(
          isApiReady: true,
          source: RepositorySource.mock,
        ),
        isTrue,
      );
      expect(
        RepositorySelector.shouldUseMock(
          isApiReady: true,
          source: RepositorySource.live,
        ),
        isFalse,
      );
    });
  });

  group('RepositorySource.fromEnv', () {
    test('MOCK와 LIVE를 올바르게 파싱한다', () {
      expect(RepositorySource.fromEnv('MOCK'), RepositorySource.mock);
      expect(RepositorySource.fromEnv('LIVE'), RepositorySource.live);
      expect(RepositorySource.fromEnv('IMPL'), RepositorySource.live);
    });

    test('알 수 없는 값이나 null은 mock으로 처리한다', () {
      expect(RepositorySource.fromEnv(null), RepositorySource.mock);
      expect(RepositorySource.fromEnv('unknown'), RepositorySource.mock);
    });
  });
}

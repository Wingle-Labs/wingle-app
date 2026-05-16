import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/env_util.dart';

/// Repository 구현 선택값
enum RepositorySource {
  /// Mock 구현
  mock,

  /// 실제 구현
  live;

  /// 환경 변수 값을 enum으로 변환한다.
  static RepositorySource fromEnv(String? value) {
    switch (value?.toUpperCase()) {
      case 'LIVE':
      case 'IMPL':
        return RepositorySource.live;
      case 'MOCK':
      default:
        return RepositorySource.mock;
    }
  }
}

/// Repository 선택 유틸
class RepositorySelector {
  /// 인스턴스 생성 방지
  const RepositorySelector._();

  /// 현재 env 기준 source를 반환한다.
  static RepositorySource currentSource() {
    try {
      final raw = EnvUtil.getNullable(ApiEnvFile.source);
      return RepositorySource.fromEnv(raw);
    } catch (_) {
      return RepositorySource.mock;
    }
  }

  /// 준비되지 않은 API는 항상 mock을 사용하고,
  /// 준비된 API만 source 값에 따라 구현체를 선택한다.
  static bool shouldUseMock({
    required bool isApiReady,
    RepositorySource? source,
  }) {
    if (!isApiReady) {
      return true;
    }

    return (source ?? currentSource()) == RepositorySource.mock;
  }

  /// env source와 API 준비 여부를 모두 반영한 실제 선택값을 반환한다.
  static RepositorySource effectiveSource({
    required bool isApiReady,
    RepositorySource? source,
  }) {
    return shouldUseMock(isApiReady: isApiReady, source: source)
        ? RepositorySource.mock
        : RepositorySource.live;
  }

  /// API 로그에 남길 Repository 선택 상태 라벨을 반환한다.
  static String selectionLabel({
    required bool isApiReady,
    RepositorySource? source,
  }) {
    final configuredSource = source ?? currentSource();
    final effective = effectiveSource(
      isApiReady: isApiReady,
      source: configuredSource,
    );

    return '${effective.name.toUpperCase()} '
        '(API_SOURCE=${configuredSource.name.toUpperCase()}, '
        'isApiReady=$isApiReady)';
  }
}

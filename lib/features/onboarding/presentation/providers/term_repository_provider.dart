import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/features/onboarding/data/mock/mock_term_repository.dart';
import 'package:wingle/features/onboarding/domain/repository/term_repository.dart';

/// [TermRepository] 구현체를 제공하는 Provider.
///
/// - Presentation 레이어는 이 Provider를 통해 Repository에 접근한다.
/// - 구현체 교체(테스트, Mock 등)를 용이하게 하기 위한 추상화 지점이다.
final termRepositoryProvider = Provider<TermRepository>((ref) {
  // return TermRepositoryImpl(
  //   client: http.Client(),
  //   baseUrl: EnvUtil.get(ApiEnvFile.baseUrl),
  // );

  return MockTermRepository();
});

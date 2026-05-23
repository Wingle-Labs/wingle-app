import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/authenticated_api_client.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/onboarding/data/health_repository_impl.dart';
import 'package:wingle/features/onboarding/data/mock/mock_health_repository.dart';
import 'package:wingle/features/onboarding/domain/repository/health_repository.dart';

part 'health_repository_provider.g.dart';

/// [HealthRepository] 구현체를 제공하는 Provider.
@Riverpod(keepAlive: true)
HealthRepository healthRepository(Ref ref) {
  const isApiReady = true;

  if (RepositorySelector.shouldUseMock(isApiReady: isApiReady)) {
    return const MockHealthRepository();
  }

  final baseUrl = EnvUtil.get(ApiEnvFile.baseUrl);
  final client = AuthenticatedApiClient(
    inner: http.Client(),
    baseUrl: baseUrl,
    requestSourceLabel: RepositorySelector.selectionLabel(
      isApiReady: isApiReady,
    ),
  );
  ref.onDispose(client.close);

  return HealthRepositoryImpl(client: client, baseUrl: baseUrl);
}

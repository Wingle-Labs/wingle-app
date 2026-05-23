import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/authenticated_api_client.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/data/profile_repository_impl.dart';
import 'package:wingle/features/onboarding/domain/repository/profile_repository.dart';

part 'profile_repository_provider.g.dart';

/// [ProfileRepository] 구현체를 제공하는 Provider.
@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  const isApiReady = true;

  if (RepositorySelector.shouldUseMock(isApiReady: isApiReady)) {
    return MockProfileRepository();
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

  return ProfileRepositoryImpl(client: client, baseUrl: baseUrl);
}

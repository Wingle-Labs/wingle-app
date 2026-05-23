import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/authenticated_api_client.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/onboarding/data/body_shape_repository_impl.dart';
import 'package:wingle/features/onboarding/data/mock/mock_body_shape_repository.dart';
import 'package:wingle/features/onboarding/domain/model/body_shape/body_shape_models.dart';
import 'package:wingle/features/onboarding/domain/repository/body_shape_repository.dart';

part 'body_shape_repository_provider.g.dart';

/// [BodyShapeRepository] 구현체를 제공하는 Provider.
@Riverpod(keepAlive: true)
BodyShapeRepository bodyShapeRepository(Ref ref) {
  const isApiReady = false;

  if (RepositorySelector.shouldUseMock(isApiReady: isApiReady)) {
    return MockBodyShapeRepository();
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

  return BodyShapeRepositoryImpl(client: client, baseUrl: baseUrl);
}

/// 체형 코드북을 제공하는 Provider.
@Riverpod(keepAlive: true)
BodyShapeCodebook bodyShapeCodebook(Ref ref) {
  final repository = ref.watch(bodyShapeRepositoryProvider);
  return repository.fetchBodyShapeCodebook();
}

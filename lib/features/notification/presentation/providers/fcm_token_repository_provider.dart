import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/authenticated_api_client.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/notification/data/fcm_token_repository_impl.dart';
import 'package:wingle/features/notification/data/mock/mock_fcm_token_repository.dart';
import 'package:wingle/features/notification/domain/repository/fcm_token_repository.dart';

part 'fcm_token_repository_provider.g.dart';

/// [FcmTokenRepository] 구현체를 제공한다.
@Riverpod(keepAlive: true)
FcmTokenRepository fcmTokenRepository(Ref ref) {
  const isApiReady = true;

  if (RepositorySelector.shouldUseMock(isApiReady: isApiReady)) {
    return MockFcmTokenRepository();
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

  return FcmTokenRepositoryImpl(client: client, baseUrl: baseUrl);
}

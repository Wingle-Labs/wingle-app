import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/authenticated_api_client.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/auth/data/mock/mock_login_repository.dart';
import 'package:wingle/features/auth/data/repositories/login_repository_impl.dart';
import 'package:wingle/features/auth/domain/repositories/login_repository.dart';

/// [LoginRepository] 구현체를 제공하는 Provider.
final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  const isApiReady = true;

  if (RepositorySelector.shouldUseMock(isApiReady: isApiReady)) {
    return MockLoginRepository();
  }

  final baseUrl = EnvUtil.get(ApiEnvFile.baseUrl);
  final client = AuthenticatedApiClient(inner: http.Client(), baseUrl: baseUrl);
  ref.onDispose(client.close);

  return LoginRepositoryImpl(client: client, baseUrl: baseUrl);
});

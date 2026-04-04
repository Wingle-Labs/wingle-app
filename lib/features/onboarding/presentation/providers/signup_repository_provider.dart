import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/onboarding/data/mock/mock_signup_repository.dart';
import 'package:wingle/features/onboarding/data/signup_repository_impl.dart';
import 'package:wingle/features/onboarding/domain/repository/signup_repository.dart';

/// [SignupRepository] 구현체를 제공하는 Provider.
final signupRepositoryProvider = Provider<SignupRepository>((ref) {
  const isApiReady = true;

  if (RepositorySelector.shouldUseMock(isApiReady: isApiReady)) {
    return MockSignupRepository();
  }

  final client = http.Client();
  ref.onDispose(client.close);

  return SignupRepositoryImpl(
    client: client,
    baseUrl: EnvUtil.get(ApiEnvFile.baseUrl),
  );
});

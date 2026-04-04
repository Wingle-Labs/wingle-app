import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/data/profile_repository_impl.dart';
import 'package:wingle/features/onboarding/domain/repository/profile_repository.dart';

/// [ProfileRepository] 구현체를 제공하는 Provider.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  const isApiReady = false;

  if (RepositorySelector.shouldUseMock(isApiReady: isApiReady)) {
    return MockProfileRepository();
  }

  final client = http.Client();
  ref.onDispose(client.close);

  return ProfileRepositoryImpl(
    client: client,
    baseUrl: EnvUtil.get(ApiEnvFile.baseUrl),
  );
});

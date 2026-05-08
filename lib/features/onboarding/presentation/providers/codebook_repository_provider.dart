import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/authenticated_api_client.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/onboarding/data/codebook_repository_impl.dart';
import 'package:wingle/features/onboarding/data/mock/mock_codebook_repository.dart';
import 'package:wingle/features/onboarding/domain/repository/codebook_repository.dart';

/// [CodebookRepository] 구현체를 제공하는 Provider.
final codebookRepositoryProvider = Provider<CodebookRepository>((ref) {
  const isApiReady = true;

  if (RepositorySelector.shouldUseMock(isApiReady: isApiReady)) {
    return const MockCodebookRepository();
  }

  final baseUrl = EnvUtil.get(ApiEnvFile.baseUrl);
  final client = AuthenticatedApiClient(inner: http.Client(), baseUrl: baseUrl);
  ref.onDispose(client.close);

  return CodebookRepositoryImpl(client: client, baseUrl: baseUrl);
});

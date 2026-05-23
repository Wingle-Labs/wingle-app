import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/onboarding/data/cached_codebook_repository.dart';
import 'package:wingle/features/onboarding/data/codebook_repository_impl.dart';
import 'package:wingle/features/onboarding/data/mock/mock_codebook_repository.dart';
import 'package:wingle/features/onboarding/domain/repository/codebook_repository.dart';

part 'codebook_repository_provider.g.dart';

/// [CodebookRepository] 구현체를 제공하는 Provider.
@Riverpod(keepAlive: true)
CodebookRepository codebookRepository(Ref ref) {
  const isApiReady = true;

  if (RepositorySelector.shouldUseMock(isApiReady: isApiReady)) {
    return const MockCodebookRepository();
  }

  final baseUrl = EnvUtil.get(ApiEnvFile.baseUrl);
  final client = http.Client();
  ref.onDispose(client.close);

  return CachedCodebookRepository(
    remoteRepository: CodebookRepositoryImpl(client: client, baseUrl: baseUrl),
  );
}

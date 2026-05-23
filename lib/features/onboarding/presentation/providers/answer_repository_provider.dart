import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/authenticated_api_client.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/onboarding/data/answer_repository_impl.dart';
import 'package:wingle/features/onboarding/data/mock/mock_answer_repository.dart';
import 'package:wingle/features/onboarding/domain/repository/answer_repository.dart';

part 'answer_repository_provider.g.dart';

/// [AnswerRepository] 구현체를 제공하는 Provider.
@Riverpod(keepAlive: true)
AnswerRepository answerRepository(Ref ref) {
  const isApiReady = true;

  if (RepositorySelector.shouldUseMock(isApiReady: isApiReady)) {
    return const MockAnswerRepository();
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

  return AnswerRepositoryImpl(client: client, baseUrl: baseUrl);
}

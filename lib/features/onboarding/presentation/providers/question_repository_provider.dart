import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/authenticated_api_client.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/onboarding/data/mock/mock_question_repository.dart';
import 'package:wingle/features/onboarding/data/question_repository_impl.dart';
import 'package:wingle/features/onboarding/domain/repository/question_repository.dart';

part 'question_repository_provider.g.dart';

/// [QuestionRepository] 구현체를 제공하는 Provider.
@Riverpod(keepAlive: true)
QuestionRepository questionRepository(Ref ref) {
  const isApiReady = true;

  if (RepositorySelector.shouldUseMock(isApiReady: isApiReady)) {
    return MockQuestionRepository();
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

  return QuestionRepositoryImpl(client: client, baseUrl: baseUrl);
}

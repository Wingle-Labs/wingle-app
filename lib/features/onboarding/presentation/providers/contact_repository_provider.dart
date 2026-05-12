import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/authenticated_api_client.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/onboarding/data/contact_repository_impl.dart';
import 'package:wingle/features/onboarding/data/mock/mock_contact_repository.dart';
import 'package:wingle/features/onboarding/domain/repository/contact_repository.dart';

/// [ContactRepository] 구현체를 제공하는 Provider.
final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  const isApiReady = true;

  if (RepositorySelector.shouldUseMock(isApiReady: isApiReady)) {
    return const MockContactRepository();
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

  return ContactRepositoryImpl(client: client, baseUrl: baseUrl);
});

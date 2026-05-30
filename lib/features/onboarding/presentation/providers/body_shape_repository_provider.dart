import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/authenticated_api_client.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/onboarding/data/body_shape_repository_impl.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_local_datasource.dart';
import 'package:wingle/features/onboarding/data/mock/mock_body_shape_repository.dart';
import 'package:wingle/features/onboarding/domain/model/body_shape/body_shape_models.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_group.dart';
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
  try {
    final codes = CodebookLocalDataSource().loadCodes(CodebookGroup.bodyType);
    if (codes.isNotEmpty) {
      final codebook = BodyShapeCodebook.fromCodebookEntries(codes);
      if (codebook.maleOptions.isNotEmpty ||
          codebook.femaleOptions.isNotEmpty) {
        return codebook;
      }
    }
  } catch (_) {
    // 테스트/Widgetbook처럼 Hive가 아직 준비되지 않은 환경은 fallback을 사용한다.
  }

  final repository = ref.watch(bodyShapeRepositoryProvider);
  return repository.fetchBodyShapeCodebook();
}

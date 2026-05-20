import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/bootstrap/bootstrap_initializer.dart';
import 'package:wingle/app/bootstrap/initializers/codebook_initializer.dart';
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/features/onboarding/data/codebook/choice_question_local_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_local_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_remote_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_repository_impl.dart'
    as bootstrap_codebook;

/// 부트스트랩 초기화 제공자
final bootstrapInitializerProvider = Provider<BootstrapInitializer>((ref) {
  final baseUrl = EnvUtil.get(ApiEnvFile.baseUrl);
  final dio = Dio();
  final codebookRepository = bootstrap_codebook.CodebookRepositoryImpl(
    remoteDataSource: CodebookRemoteDataSource(
      dio: dio,
      baseUrl: baseUrl,
      logger: debugPrint,
    ),
    localDataSource: CodebookLocalDataSource(),
    choiceLocalDataSource: const ChoiceQuestionLocalDataSource(),
    logger: debugPrint,
  );

  return BootstrapInitializer(
    codebookInitializer: CodebookInitializer(repository: codebookRepository),
  );
});

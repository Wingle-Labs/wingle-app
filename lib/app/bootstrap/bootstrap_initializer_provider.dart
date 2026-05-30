import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/app/bootstrap/bootstrap_initializer.dart';
import 'package:wingle/app/bootstrap/initializers/auth_session_initializer.dart';
import 'package:wingle/app/bootstrap/initializers/codebook_initializer.dart';
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/features/auth/presentation/providers/login_repository_provider.dart';
import 'package:wingle/features/onboarding/data/codebook/choice_question_local_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_local_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_remote_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_repository_impl.dart'
    as bootstrap_codebook;
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';

part 'bootstrap_initializer_provider.g.dart';

/// 부트스트랩 초기화 제공자
@Riverpod(keepAlive: true)
BootstrapInitializer bootstrapInitializer(Ref ref) {
  final baseUrl = EnvUtil.get(ApiEnvFile.baseUrl);
  final dio = Dio();
  final loginRepository = ref.watch(loginRepositoryProvider);
  final profileRepository = ref.watch(profileRepositoryProvider);
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
    authSessionInitializer: AuthSessionInitializer(
      loginRepository: loginRepository,
      profileRepository: profileRepository,
      logger: debugPrint,
    ),
    codebookInitializer: CodebookInitializer(repository: codebookRepository),
  );
}

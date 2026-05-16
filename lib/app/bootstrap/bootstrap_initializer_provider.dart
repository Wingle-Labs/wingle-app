import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/bootstrap/bootstrap_initializer.dart';
import 'package:wingle/app/bootstrap/initializers/codebook_initializer.dart';
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_local_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_remote_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_repository_impl.dart';

final bootstrapInitializerProvider = Provider<BootstrapInitializer>((ref) {
  final baseUrl = EnvUtil.get(ApiEnvFile.baseUrl);
  final dio = Dio();
  final codebookRepository = CodebookRepositoryImpl(
    remoteDataSource: CodebookRemoteDataSource(
      dio: dio,
      baseUrl: baseUrl,
      logger: debugPrint,
    ),
    localDataSource: CodebookLocalDataSource(),
    logger: debugPrint,
  );

  return BootstrapInitializer(
    codebookInitializer: CodebookInitializer(repository: codebookRepository),
  );
});

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_local_datasource.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';

part 'job_codebook_provider.g.dart';

/// JOB 코드북 트리를 제공하는 Provider.
@Riverpod(keepAlive: true)
JobCodebookTree jobCodebookTree(Ref ref) {
  final localDataSource = CodebookLocalDataSource();
  final codes = localDataSource.loadCodes(CodebookGroup.job);
  final version =
      localDataSource.loadVersions().versions[CodebookGroup.job] ?? 0;

  if (codes.isEmpty) {
    throw StateError('JOB codebook snapshot is empty.');
  }

  return JobCodebookTree.fromSnapshot(
    CodebookSnapshot(version: version, codes: codes),
  );
}

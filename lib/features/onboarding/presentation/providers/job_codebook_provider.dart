import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_local_datasource.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/domain/model/profile/job_occupation_policy.dart';

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

  return buildJobCodebookTree(CodebookSnapshot(version: version, codes: codes));
}

/// 앱 직업 선택 정책을 반영해 JOB 코드북 트리를 만든다.
JobCodebookTree buildJobCodebookTree(CodebookSnapshot snapshot) {
  return JobCodebookTree.fromSnapshot(
    snapshot,
    resolveParentCode: (entry, entriesByCode) {
      if (JobOccupationPolicy.topLevelOccupationCodes.contains(entry.code)) {
        return null;
      }

      return entry.parentCode;
    },
  );
}

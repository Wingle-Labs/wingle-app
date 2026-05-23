import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_local_datasource.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';

part 'region_codebook_provider.g.dart';

/// REGION 코드북 트리를 제공하는 Provider.
@Riverpod(keepAlive: true)
RegionCodebookTree regionCodebookTree(Ref ref) {
  final localDataSource = CodebookLocalDataSource();
  final codes = localDataSource.loadCodes(CodebookGroup.region);
  final version =
      localDataSource.loadVersions().versions[CodebookGroup.region] ?? 0;

  if (codes.isEmpty) {
    throw StateError('REGION codebook snapshot is empty.');
  }

  return RegionCodebookTree.fromSnapshot(
    CodebookSnapshot(version: version, codes: codes),
  );
}

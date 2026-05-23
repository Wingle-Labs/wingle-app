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
    includeEntry: _includeRegionEntry,
    resolveCodeName: _resolveRegionCodeName,
  );
}

bool _includeRegionEntry(
  CodebookEntry entry,
  Map<String, CodebookEntry> entriesByCode,
) {
  return !_isCityWithSiblingDistricts(entry, entriesByCode);
}

String _resolveRegionCodeName(
  CodebookEntry entry,
  Map<String, CodebookEntry> entriesByCode,
) {
  final city = _siblingCityForDistrict(entry, entriesByCode);
  if (city == null) return entry.codeName;
  return '${city.codeName} ${entry.codeName}';
}

bool _isCityWithSiblingDistricts(
  CodebookEntry entry,
  Map<String, CodebookEntry> entriesByCode,
) {
  final digits = _regionDigits(entry.code);

  if (entry.parentCode == null ||
      digits == null ||
      digits.length != 5 ||
      !digits.endsWith('0') ||
      !entry.codeName.endsWith('시')) {
    return false;
  }

  final districtPrefix = digits.substring(0, 4);
  return entriesByCode.values.any((candidate) {
    final candidateDigits = _regionDigits(candidate.code);
    return candidate.parentCode == entry.parentCode &&
        candidateDigits != null &&
        candidateDigits.length == 5 &&
        candidateDigits.startsWith(districtPrefix) &&
        !candidateDigits.endsWith('0') &&
        candidate.codeName.endsWith('구');
  });
}

CodebookEntry? _siblingCityForDistrict(
  CodebookEntry entry,
  Map<String, CodebookEntry> entriesByCode,
) {
  final parentCode = entry.parentCode;
  final digits = _regionDigits(entry.code);

  if (parentCode == null ||
      digits == null ||
      digits.length != 5 ||
      digits.endsWith('0') ||
      !entry.codeName.endsWith('구')) {
    return null;
  }

  final cityCode = 'R_${digits.substring(0, 4)}0';
  final city = entriesByCode[cityCode];

  if (city == null ||
      city.parentCode != parentCode ||
      !city.codeName.endsWith('시')) {
    return null;
  }

  return city;
}

String? _regionDigits(String code) {
  if (!code.startsWith('R_')) return null;
  return code.substring(2);
}

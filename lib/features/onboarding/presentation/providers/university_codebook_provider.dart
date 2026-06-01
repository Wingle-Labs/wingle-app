import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_local_datasource.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';

part 'university_codebook_provider.g.dart';

/// UNIVERSITY 코드북 항목을 제공한다.
@Riverpod(keepAlive: true)
List<CodebookEntry> universityCodebookEntries(Ref ref) {
  try {
    return CodebookLocalDataSource().loadCodes(CodebookGroup.university);
  } catch (_) {
    return const <CodebookEntry>[];
  }
}

/// 입력된 학교명과 정확히 일치하는 UNIVERSITY 코드북 항목을 찾는다.
CodebookEntry? findUniversityEntryByName(
  String schoolName,
  List<CodebookEntry> entries,
) {
  final normalized = schoolName.trim();
  if (normalized.isEmpty) {
    return null;
  }

  for (final entry in entries) {
    if (entry.codeName.trim() == normalized) {
      return entry;
    }
  }
  return null;
}

/// 입력된 학교명과 코드가 모두 일치하는 UNIVERSITY 코드북 항목을 찾는다.
CodebookEntry? findUniversityEntryByCodeAndName(
  String? universityCode,
  String schoolName,
  List<CodebookEntry> entries,
) {
  final normalizedCode = universityCode?.trim();
  final normalizedName = schoolName.trim();
  if (normalizedCode == null ||
      normalizedCode.isEmpty ||
      normalizedName.isEmpty) {
    return null;
  }

  for (final entry in entries) {
    if (entry.code == normalizedCode &&
        entry.codeName.trim() == normalizedName) {
      return entry;
    }
  }
  return null;
}

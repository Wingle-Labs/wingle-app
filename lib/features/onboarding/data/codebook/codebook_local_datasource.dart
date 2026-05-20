import 'package:hive_ce/hive.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_entry.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_group.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_snapshot.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_version_map.dart';

/// 코드북 로컬 데이터소스.
class CodebookLocalDataSource {
  /// 메타데이터 Hive 박스 이름.
  static const String metadataBoxName = 'codebook_metadata';

  /// 코드북 스냅샷 Hive 박스 이름.
  static const String snapshotBoxName = 'codebook_snapshot';

  /// 버전 조회.
  CodebookVersionMap loadVersions() {
    final box = _metadataBox;
    final versions = <CodebookGroup, int>{};

    for (final group in CodebookGroup.values) {
      final rawValue = box.get(group.code);
      final parsed = rawValue is num
          ? rawValue.toInt()
          : int.tryParse(rawValue?.toString() ?? '') ?? 0;
      if (parsed > 0) {
        versions[group] = parsed;
      }
    }

    return CodebookVersionMap(versions: versions);
  }

  /// 특정 그룹 스냅샷 목록 조회.
  List<CodebookEntry> loadCodes(CodebookGroup group) {
    final snapshot = _snapshotBox.get(group.code);
    if (snapshot is! Map) {
      return const <CodebookEntry>[];
    }

    final parsed = CodebookSnapshot.fromJson(
      Map<String, dynamic>.from(snapshot),
    );
    final codes = [...parsed.codes]
      ..sort((left, right) => _compareEntries(group, left, right));
    return codes;
  }

  /// 코드로 조회.
  CodebookEntry? findByCode(CodebookGroup group, String code) {
    for (final entry in loadCodes(group)) {
      if (entry.code == code) {
        return entry;
      }
    }
    return null;
  }

  /// 버전 저장.
  Future<void> saveVersions(CodebookVersionMap versionMap) async {
    for (final entry in versionMap.versions.entries) {
      await _metadataBox.put(entry.key.code, entry.value);
    }
  }

  /// 스냅샷 교체 저장.
  Future<void> replaceSnapshots(
    Map<CodebookGroup, CodebookSnapshot> snapshots,
  ) async {
    for (final entry in snapshots.entries) {
      final sortedCodes = [...entry.value.codes]
        ..sort((left, right) => _compareEntries(entry.key, left, right));
      await _snapshotBox.put(
        entry.key.code,
        CodebookSnapshot(
          version: entry.value.version,
          codes: sortedCodes,
        ).toJson(),
      );
      await _metadataBox.put(entry.key.code, entry.value.version);
    }
  }

  Box<dynamic> get _metadataBox => _getBox(metadataBoxName);

  Box<dynamic> get _snapshotBox => _getBox(snapshotBoxName);

  Box<dynamic> _getBox(String name) {
    if (!Hive.isBoxOpen(name)) {
      throw StateError(
        '[CodebookLocalDataSource] Hive Box "$name" is not open.',
      );
    }
    return Hive.box(name);
  }

  int _compareEntries(
    CodebookGroup group,
    CodebookEntry left,
    CodebookEntry right,
  ) {
    return switch (group) {
      CodebookGroup.bodyType => _compareByDisplayOrder(left, right),
      CodebookGroup.region => _compareByRegion(left, right),
      CodebookGroup.job => _compareByCodeName(left, right),
      CodebookGroup.university => _compareByCodeName(left, right),
      CodebookGroup.questionCategory => _compareByCodeName(left, right),
    };
  }

  int _compareByDisplayOrder(CodebookEntry left, CodebookEntry right) {
    final orderCompare = left.displayOrder.compareTo(right.displayOrder);
    if (orderCompare != 0) return orderCompare;
    return left.code.compareTo(right.code);
  }

  int _compareByRegion(CodebookEntry left, CodebookEntry right) {
    final parentCompare = (left.parentCode ?? '').compareTo(
      right.parentCode ?? '',
    );
    if (parentCompare != 0) return parentCompare;
    final nameCompare = left.codeName.compareTo(right.codeName);
    if (nameCompare != 0) return nameCompare;
    return left.code.compareTo(right.code);
  }

  int _compareByCodeName(CodebookEntry left, CodebookEntry right) {
    final nameCompare = left.codeName.compareTo(right.codeName);
    if (nameCompare != 0) return nameCompare;
    return left.code.compareTo(right.code);
  }
}

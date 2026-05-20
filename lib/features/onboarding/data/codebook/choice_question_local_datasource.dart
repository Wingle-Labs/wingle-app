import 'package:hive_ce/hive.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';

/// 객관식 질문 코드북 로컬 데이터소스.
class ChoiceQuestionLocalDataSource {
  /// 생성자.
  const ChoiceQuestionLocalDataSource();

  /// 메타데이터 Hive 박스 이름.
  static const String metadataBoxName = 'choice_question_metadata';

  /// 스냅샷 Hive 박스 이름.
  static const String snapshotBoxName = 'choice_question_snapshot';

  /// 버전 조회.
  Map<String, int> loadVersions() {
    final box = _metadataBox;
    final versions = <String, int>{};

    for (final key in box.keys) {
      final rawValue = box.get(key);
      final parsed = rawValue is num
          ? rawValue.toInt()
          : int.tryParse(rawValue?.toString() ?? '') ?? 0;
      if (parsed > 0) {
        versions[key.toString()] = parsed;
      }
    }

    return versions;
  }

  /// 특정 카테고리 스냅샷 조회.
  ChoiceQuestionSetSnapshot? loadSnapshot(String category) {
    final snapshot = _snapshotBox.get(category);
    if (snapshot is! Map) {
      return null;
    }

    return ChoiceQuestionSetSnapshot.fromJson(
      Map<String, dynamic>.from(snapshot),
    );
  }

  /// 여러 카테고리 스냅샷 조회.
  Map<String, ChoiceQuestionSetSnapshot> loadSnapshots(
    List<String> categories,
  ) {
    return {
      for (final category in categories)
        if (loadSnapshot(category) case final snapshot?) category: snapshot,
    };
  }

  /// 버전 저장.
  Future<void> saveVersions(Map<String, int> versions) async {
    for (final entry in versions.entries) {
      await _metadataBox.put(entry.key, entry.value);
    }
  }

  /// 스냅샷 교체 저장.
  Future<void> replaceSnapshots(
    Map<String, ChoiceQuestionSetSnapshot> snapshots,
  ) async {
    for (final entry in snapshots.entries) {
      await _snapshotBox.put(entry.key, entry.value.toJson());
      await _metadataBox.put(entry.key, entry.value.version);
    }
  }

  Box<dynamic> get _metadataBox => _getBox(metadataBoxName);

  Box<dynamic> get _snapshotBox => _getBox(snapshotBoxName);

  Box<dynamic> _getBox(String name) {
    if (!Hive.isBoxOpen(name)) {
      throw StateError(
        '[ChoiceQuestionLocalDataSource] Hive Box "$name" is not open.',
      );
    }
    return Hive.box(name);
  }
}

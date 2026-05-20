import 'package:wingle/features/onboarding/data/codebook/choice_question_local_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_local_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook_repository_impl.dart'
    as remote_codebook;
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/domain/repository/codebook_repository.dart';

/// 로컬 캐시 우선 코드북 Repository.
class CachedCodebookRepository implements CodebookRepository {
  final CodebookLocalDataSource _localDataSource;
  final ChoiceQuestionLocalDataSource _choiceLocalDataSource;
  final remote_codebook.CodebookRepositoryImpl _remoteRepository;

  /// 생성자.
  CachedCodebookRepository({
    CodebookLocalDataSource? localDataSource,
    ChoiceQuestionLocalDataSource? choiceLocalDataSource,
    required remote_codebook.CodebookRepositoryImpl remoteRepository,
  }) : _localDataSource = localDataSource ?? CodebookLocalDataSource(),
       _choiceLocalDataSource =
           choiceLocalDataSource ?? const ChoiceQuestionLocalDataSource(),
       _remoteRepository = remoteRepository;

  @override
  Future<TermSnapshot> fetchTermsSnapshot() {
    return _remoteRepository.fetchTermsSnapshot();
  }

  @override
  Future<Map<String, int>> fetchTermsCurrentVersions() {
    return _remoteRepository.fetchTermsCurrentVersions();
  }

  @override
  Future<Map<String, CodeSnapshot>> fetchCodebookSnapshot({
    required List<String> groups,
  }) async {
    final snapshots = <String, CodeSnapshot>{};
    final missingGroups = <String>[];

    for (final group in groups) {
      try {
        final codebookGroup = CodebookGroup.values.firstWhere(
          (candidate) => candidate.code == group,
        );
        final codes = _localDataSource.loadCodes(codebookGroup);
        if (codes.isEmpty) {
          missingGroups.add(group);
          continue;
        }
        final version =
            _localDataSource.loadVersions().versions[codebookGroup] ?? 0;
        snapshots[group] = CodeSnapshot(version: version, codes: codes);
      } catch (_) {
        missingGroups.add(group);
      }
    }

    if (missingGroups.isNotEmpty) {
      final remoteSnapshots = await _remoteRepository.fetchCodebookSnapshot(
        groups: missingGroups,
      );
      final codesToSave = <CodebookGroup, CodebookSnapshot>{};
      for (final entry in remoteSnapshots.entries) {
        final codebookGroup = CodebookGroup.values.firstWhere(
          (candidate) => candidate.code == entry.key,
        );
        codesToSave[codebookGroup] = CodebookSnapshot(
          version: entry.value.version,
          codes: entry.value.codes
              .map(
                (code) => CodebookEntry(
                  code: code.code,
                  codeName: code.codeName,
                  parentCode: code.parentCode,
                  displayOrder: code.displayOrder,
                ),
              )
              .toList(),
        );
        snapshots[entry.key] = entry.value;
      }
      await _localDataSource.replaceSnapshots(codesToSave);
    }

    return snapshots;
  }

  @override
  Future<Map<String, int>> fetchCodebookCurrentVersions() async {
    final versions = _localDataSource.loadVersions();
    return {
      for (final entry in versions.toJson().entries)
        entry.key: entry.value as int,
    };
  }

  @override
  Future<Map<String, ChoiceQuestionSetSnapshot>> fetchChoiceQuestionSnapshot({
    required List<String> categories,
  }) async {
    final snapshots = _choiceLocalDataSource.loadSnapshots(categories);
    if (snapshots.length == categories.length) {
      return snapshots;
    }

    final missing = categories
        .where((category) => !snapshots.containsKey(category))
        .toList();
    if (missing.isEmpty) return snapshots;

    final remoteSnapshots = await _remoteRepository.fetchChoiceQuestionSnapshot(
      categories: missing,
    );
    await _choiceLocalDataSource.replaceSnapshots(remoteSnapshots);

    return {...snapshots, ...remoteSnapshots};
  }

  @override
  Future<Map<String, int>> fetchChoiceQuestionCurrentVersions() async {
    return _choiceLocalDataSource.loadVersions();
  }

  @override
  Future<EssayQuestionSnapshot> fetchEssayQuestionSnapshot() {
    return _remoteRepository.fetchEssayQuestionSnapshot();
  }

  @override
  Future<CurrentVersionResponse> fetchEssayQuestionCurrentVersion() {
    return _remoteRepository.fetchEssayQuestionCurrentVersion();
  }
}

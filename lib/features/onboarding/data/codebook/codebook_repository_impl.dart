import 'dart:async';

import 'package:wingle/features/onboarding/data/codebook/choice_question_local_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_local_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_remote_datasource.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';

/// 코드북 동기화 예외.
class CodebookSyncException implements Exception {
  /// 에러 메시지.
  final String message;

  /// 생성자.
  const CodebookSyncException(this.message);

  @override
  String toString() => 'CodebookSyncException($message)';
}

/// 코드북 Repository 구현체.
class CodebookRepositoryImpl {
  final CodebookRemoteDataSource _remoteDataSource;
  final CodebookLocalDataSource _localDataSource;
  final ChoiceQuestionLocalDataSource _choiceLocalDataSource;
  final void Function(String message)? _logger;

  /// 생성자.
  const CodebookRepositoryImpl({
    required CodebookRemoteDataSource remoteDataSource,
    required CodebookLocalDataSource localDataSource,
    ChoiceQuestionLocalDataSource? choiceLocalDataSource,
    void Function(String message)? logger,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _choiceLocalDataSource =
           choiceLocalDataSource ?? const ChoiceQuestionLocalDataSource(),
       _logger = logger;

  /// 로컬 버전 조회.
  CodebookVersionMap getLocalVersions() {
    final versions = _localDataSource.loadVersions();
    _log('[CodebookSync] local versions loaded: ${versions.toJson()}');
    return versions;
  }

  /// 로컬 코드 조회.
  List<CodebookEntry> getCodes(CodebookGroup group) {
    return _localDataSource.loadCodes(group);
  }

  /// 코드 검색.
  CodebookEntry? findByCode(CodebookGroup group, String code) {
    return _localDataSource.findByCode(group, code);
  }

  /// 서버 버전 조회.
  Future<CodebookVersionMap> getRemoteVersions() async {
    try {
      final versions = await _remoteDataSource.fetchCurrentVersions();
      _log('[CodebookSync] remote versions fetched: ${versions.toJson()}');
      return versions;
    } catch (error, stackTrace) {
      _log('[CodebookSync] remote versions fetch failed: $error');
      Error.throwWithStackTrace(
        CodebookSyncException(error.toString()),
        stackTrace,
      );
    }
  }

  /// outdated 그룹 계산.
  List<CodebookGroup> getOutdatedGroups({
    required CodebookVersionMap localVersions,
    required CodebookVersionMap remoteVersions,
  }) {
    final outdated = <CodebookGroup>[];
    for (final group in CodebookGroup.values) {
      final local = localVersions.versions[group];
      final remote = remoteVersions.versions[group];
      if (remote != null && local != remote) {
        outdated.add(group);
      }
    }
    _log(
      '[CodebookSync] outdated groups detected: '
      '${outdated.map((e) => e.code).toList()}',
    );
    return outdated;
  }

  /// 스냅샷 조회.
  Future<Map<CodebookGroup, CodebookSnapshot>> fetchSnapshots(
    List<CodebookGroup> groups,
  ) async {
    if (groups.isEmpty) {
      return const {};
    }

    try {
      final snapshots = await _remoteDataSource.fetchSnapshots(groups);
      return snapshots;
    } catch (error, stackTrace) {
      _log('[CodebookSync] snapshot fetch failed: $error');
      Error.throwWithStackTrace(
        CodebookSyncException(error.toString()),
        stackTrace,
      );
    }
  }

  /// 스냅샷 교체 저장.
  Future<void> replaceSnapshots(
    Map<CodebookGroup, CodebookSnapshot> snapshots,
  ) async {
    if (snapshots.isEmpty) {
      return;
    }

    await _localDataSource.replaceSnapshots(snapshots);
    _log(
      '[CodebookSync] snapshot replaced: '
      '${snapshots.keys.map((e) => e.code).toList()}',
    );
  }

  /// 전체 동기화.
  Future<BootstrapCodebookSyncResult> sync() async {
    final localVersions = getLocalVersions();
    final localChoiceVersions = _choiceLocalDataSource.loadVersions();

    try {
      final remoteVersions = await getRemoteVersions();
      final outdatedGroups = getOutdatedGroups(
        localVersions: localVersions,
        remoteVersions: remoteVersions,
      );

      final snapshots = await fetchSnapshots(outdatedGroups);
      await replaceSnapshots(snapshots);

      final remoteChoiceVersions = await _remoteDataSource
          .fetchChoiceQuestionCurrentVersions();
      final outdatedChoiceCategories = _getOutdatedChoiceCategories(
        localVersions: localChoiceVersions,
        remoteVersions: remoteChoiceVersions,
      );
      final choiceSnapshots = await _fetchChoiceQuestionSnapshots(
        outdatedChoiceCategories,
      );
      await _replaceChoiceQuestionSnapshots(choiceSnapshots);

      return BootstrapCodebookSyncResult.success(
        localVersions: _localDataSource.loadVersions(),
        remoteVersions: remoteVersions,
        syncedGroups: snapshots.keys.toList(growable: false),
        localChoiceVersions: _choiceLocalDataSource.loadVersions(),
        remoteChoiceVersions: remoteChoiceVersions,
        syncedChoiceCategories: choiceSnapshots.keys.toList(growable: false),
        usedOfflineCache: false,
      );
    } catch (error) {
      _log('[CodebookSync] sync failed: $error');
      if (localVersions.versions.isNotEmpty || localChoiceVersions.isNotEmpty) {
        return BootstrapCodebookSyncResult.success(
          localVersions: localVersions,
          remoteVersions: const CodebookVersionMap.empty(),
          syncedGroups: const [],
          localChoiceVersions: localChoiceVersions,
          remoteChoiceVersions: const {},
          syncedChoiceCategories: const [],
          usedOfflineCache: true,
        );
      }
      return BootstrapCodebookSyncResult.failure(error.toString());
    }
  }

  List<String> _getOutdatedChoiceCategories({
    required Map<String, int> localVersions,
    required Map<String, int> remoteVersions,
  }) {
    final outdated = <String>[];
    for (final entry in remoteVersions.entries) {
      final local = localVersions[entry.key];
      if (local != entry.value) {
        outdated.add(entry.key);
      }
    }
    _log('[CodebookSync] outdated choice categories detected: $outdated');
    return outdated;
  }

  Future<Map<String, ChoiceQuestionSetSnapshot>> _fetchChoiceQuestionSnapshots(
    List<String> categories,
  ) async {
    if (categories.isEmpty) {
      return const {};
    }

    return _remoteDataSource.fetchChoiceQuestionSnapshot(
      categories: categories,
    );
  }

  Future<void> _replaceChoiceQuestionSnapshots(
    Map<String, ChoiceQuestionSetSnapshot> snapshots,
  ) async {
    if (snapshots.isEmpty) {
      return;
    }

    await _choiceLocalDataSource.replaceSnapshots(snapshots);
    _log(
      '[CodebookSync] choice snapshots replaced: '
      '${snapshots.keys.toList()}',
    );
  }

  void _log(String message) {
    _logger?.call(message);
  }
}

/// bootstrap 결과 전용 내부 모델.
class BootstrapCodebookSyncResult {
  /// 동기화 성공 여부.
  final bool success;

  /// 실패 시 에러 메시지.
  final String? errorMessage;

  /// 로컬 코드북 버전.
  final CodebookVersionMap localVersions;

  /// 원격 코드북 버전.
  final CodebookVersionMap remoteVersions;

  /// 갱신된 코드북 그룹.
  final List<CodebookGroup> syncedGroups;

  /// 로컬 객관식 질문 버전.
  final Map<String, int> localChoiceVersions;

  /// 원격 객관식 질문 버전.
  final Map<String, int> remoteChoiceVersions;

  /// 갱신된 객관식 질문 카테고리.
  final List<String> syncedChoiceCategories;

  /// 오프라인 캐시 사용 여부.
  final bool usedOfflineCache;

  const BootstrapCodebookSyncResult._({
    required this.success,
    required this.errorMessage,
    required this.localVersions,
    required this.remoteVersions,
    required this.syncedGroups,
    required this.localChoiceVersions,
    required this.remoteChoiceVersions,
    required this.syncedChoiceCategories,
    required this.usedOfflineCache,
  });

  /// 성공 결과를 생성한다.
  factory BootstrapCodebookSyncResult.success({
    required CodebookVersionMap localVersions,
    required CodebookVersionMap remoteVersions,
    required List<CodebookGroup> syncedGroups,
    required Map<String, int> localChoiceVersions,
    required Map<String, int> remoteChoiceVersions,
    required List<String> syncedChoiceCategories,
    required bool usedOfflineCache,
  }) {
    return BootstrapCodebookSyncResult._(
      success: true,
      errorMessage: null,
      localVersions: localVersions,
      remoteVersions: remoteVersions,
      syncedGroups: syncedGroups,
      localChoiceVersions: localChoiceVersions,
      remoteChoiceVersions: remoteChoiceVersions,
      syncedChoiceCategories: syncedChoiceCategories,
      usedOfflineCache: usedOfflineCache,
    );
  }

  /// 실패 결과를 생성한다.
  factory BootstrapCodebookSyncResult.failure(String message) {
    return BootstrapCodebookSyncResult._(
      success: false,
      errorMessage: message,
      localVersions: const CodebookVersionMap.empty(),
      remoteVersions: const CodebookVersionMap.empty(),
      syncedGroups: const [],
      localChoiceVersions: const {},
      remoteChoiceVersions: const {},
      syncedChoiceCategories: const [],
      usedOfflineCache: false,
    );
  }
}

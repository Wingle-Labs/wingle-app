import 'dart:async';

import 'package:wingle/features/onboarding/data/codebook/codebook_local_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_remote_datasource.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_entry.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_group.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_snapshot.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_version_map.dart';

/// 코드북 동기화 예외.
class CodebookSyncException implements Exception {
  final String message;

  const CodebookSyncException(this.message);

  @override
  String toString() => 'CodebookSyncException($message)';
}

/// 코드북 Repository 구현체.
class CodebookRepositoryImpl {
  final CodebookRemoteDataSource _remoteDataSource;
  final CodebookLocalDataSource _localDataSource;
  final void Function(String message)? _logger;

  /// 생성자
  const CodebookRepositoryImpl({
    required CodebookRemoteDataSource remoteDataSource,
    required CodebookLocalDataSource localDataSource,
    void Function(String message)? logger,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
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

    try {
      final remoteVersions = await getRemoteVersions();
      final outdatedGroups = getOutdatedGroups(
        localVersions: localVersions,
        remoteVersions: remoteVersions,
      );

      final snapshots = await fetchSnapshots(outdatedGroups);
      await replaceSnapshots(snapshots);

      return BootstrapCodebookSyncResult.success(
        localVersions: _localDataSource.loadVersions(),
        remoteVersions: remoteVersions,
        syncedGroups: snapshots.keys.toList(growable: false),
        usedOfflineCache: false,
      );
    } catch (error) {
      _log('[CodebookSync] sync failed: $error');
      if (localVersions.versions.isNotEmpty) {
        return BootstrapCodebookSyncResult.success(
          localVersions: localVersions,
          remoteVersions: const CodebookVersionMap.empty(),
          syncedGroups: const [],
          usedOfflineCache: true,
        );
      }
      return BootstrapCodebookSyncResult.failure(error.toString());
    }
  }

  void _log(String message) {
    _logger?.call(message);
  }
}

/// bootstrap 결과 전용 내부 모델.
class BootstrapCodebookSyncResult {
  final bool success;
  final String? errorMessage;
  final CodebookVersionMap localVersions;
  final CodebookVersionMap remoteVersions;
  final List<CodebookGroup> syncedGroups;
  final bool usedOfflineCache;

  const BootstrapCodebookSyncResult._({
    required this.success,
    required this.errorMessage,
    required this.localVersions,
    required this.remoteVersions,
    required this.syncedGroups,
    required this.usedOfflineCache,
  });

  factory BootstrapCodebookSyncResult.success({
    required CodebookVersionMap localVersions,
    required CodebookVersionMap remoteVersions,
    required List<CodebookGroup> syncedGroups,
    required bool usedOfflineCache,
  }) {
    return BootstrapCodebookSyncResult._(
      success: true,
      errorMessage: null,
      localVersions: localVersions,
      remoteVersions: remoteVersions,
      syncedGroups: syncedGroups,
      usedOfflineCache: usedOfflineCache,
    );
  }

  factory BootstrapCodebookSyncResult.failure(String message) {
    return BootstrapCodebookSyncResult._(
      success: false,
      errorMessage: message,
      localVersions: const CodebookVersionMap.empty(),
      remoteVersions: const CodebookVersionMap.empty(),
      syncedGroups: const [],
      usedOfflineCache: false,
    );
  }
}

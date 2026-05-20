import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/onboarding/data/codebook/choice_question_local_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_local_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_remote_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_repository_impl.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';

class _FakeRemoteDataSource extends CodebookRemoteDataSource {
  final CodebookVersionMap remoteVersions;
  final Map<CodebookGroup, CodebookSnapshot> snapshots;
  final Map<String, int> remoteChoiceVersions;
  final Map<String, ChoiceQuestionSetSnapshot> choiceSnapshots;
  final Set<CodebookGroup> failingGroups;
  final bool throwOnVersions;

  _FakeRemoteDataSource({
    required this.remoteVersions,
    required this.snapshots,
    this.remoteChoiceVersions = const {},
    this.choiceSnapshots = const {},
    this.failingGroups = const {},
    this.throwOnVersions = false,
  }) : super(dio: Dio(), baseUrl: 'https://api.example.com');

  @override
  Future<CodebookVersionMap> fetchCurrentVersions() async {
    if (throwOnVersions) {
      throw Exception('network error');
    }
    return remoteVersions;
  }

  @override
  Future<Map<CodebookGroup, CodebookSnapshot>> fetchSnapshots(
    List<CodebookGroup> groups,
  ) async {
    return {
      for (final group in groups)
        if (!failingGroups.contains(group) && snapshots[group] != null)
          group: snapshots[group]!,
    };
  }

  @override
  Future<Map<String, int>> fetchChoiceQuestionCurrentVersions() async {
    if (throwOnVersions) {
      throw Exception('network error');
    }
    return remoteChoiceVersions;
  }

  @override
  Future<Map<String, ChoiceQuestionSetSnapshot>> fetchChoiceQuestionSnapshot({
    required List<String> categories,
  }) async {
    return {
      for (final category in categories)
        if (choiceSnapshots[category] != null)
          category: choiceSnapshots[category]!,
    };
  }
}

void main() {
  late Directory tempDir;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    await HiveUtil.initialize(HiveAesCipher(Hive.generateSecureKey()));
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('로컬 캐시가 있고 일부 그룹만 실패하면 성공 그룹만 교체한다', () async {
    final localDataSource = CodebookLocalDataSource();
    await localDataSource.replaceSnapshots({
      CodebookGroup.bodyType: const CodebookSnapshot(
        version: 1,
        codes: [
          CodebookEntry(
            code: 'BT_OLD',
            codeName: 'old',
            parentCode: null,
            displayOrder: 1,
          ),
        ],
      ),
      CodebookGroup.region: const CodebookSnapshot(
        version: 1,
        codes: [
          CodebookEntry(
            code: 'R_OLD',
            codeName: 'old',
            parentCode: null,
            displayOrder: 1,
          ),
        ],
      ),
    });

    final repository = CodebookRepositoryImpl(
      remoteDataSource: _FakeRemoteDataSource(
        remoteVersions: const CodebookVersionMap(
          versions: {CodebookGroup.bodyType: 2, CodebookGroup.region: 2},
        ),
        snapshots: const {
          CodebookGroup.bodyType: CodebookSnapshot(
            version: 2,
            codes: [
              CodebookEntry(
                code: 'BT_NEW',
                codeName: 'new',
                parentCode: null,
                displayOrder: 1,
              ),
            ],
          ),
          CodebookGroup.region: CodebookSnapshot(
            version: 2,
            codes: [
              CodebookEntry(
                code: 'R_NEW',
                codeName: 'new',
                parentCode: null,
                displayOrder: 1,
              ),
            ],
          ),
        },
        failingGroups: {CodebookGroup.region},
      ),
      localDataSource: localDataSource,
    );

    final result = await repository.sync();

    expect(result.success, isTrue);
    expect(result.usedOfflineCache, isFalse);
    expect(repository.getCodes(CodebookGroup.bodyType).single.code, 'BT_NEW');
    expect(repository.getCodes(CodebookGroup.region).single.code, 'R_OLD');
    expect(result.syncedGroups, [CodebookGroup.bodyType]);
  });

  test('객관식 질문 버전이 달라지면 로컬 스냅샷도 교체한다', () async {
    final localDataSource = CodebookLocalDataSource();
    final choiceLocalDataSource = ChoiceQuestionLocalDataSource();
    await localDataSource.replaceSnapshots({
      CodebookGroup.bodyType: const CodebookSnapshot(
        version: 1,
        codes: [
          CodebookEntry(
            code: 'BT_OLD',
            codeName: 'old',
            parentCode: null,
            displayOrder: 1,
          ),
        ],
      ),
    });
    await choiceLocalDataSource.replaceSnapshots({
      'QC_LOVE': const ChoiceQuestionSetSnapshot(
        version: 1,
        questions: [
          ChoiceQuestionDetail(
            id: 1,
            content: 'old',
            options: [ChoiceQuestionOption(id: 1, content: 'a')],
          ),
        ],
      ),
    });

    final repository = CodebookRepositoryImpl(
      remoteDataSource: _FakeRemoteDataSource(
        remoteVersions: const CodebookVersionMap(
          versions: {CodebookGroup.bodyType: 1},
        ),
        snapshots: const {
          CodebookGroup.bodyType: CodebookSnapshot(
            version: 1,
            codes: [
              CodebookEntry(
                code: 'BT_OLD',
                codeName: 'old',
                parentCode: null,
                displayOrder: 1,
              ),
            ],
          ),
        },
        remoteChoiceVersions: const {'QC_LOVE': 2},
        choiceSnapshots: const {
          'QC_LOVE': ChoiceQuestionSetSnapshot(
            version: 2,
            questions: [
              ChoiceQuestionDetail(
                id: 2,
                content: 'new',
                options: [ChoiceQuestionOption(id: 2, content: 'b')],
              ),
            ],
          ),
        },
      ),
      localDataSource: localDataSource,
      choiceLocalDataSource: choiceLocalDataSource,
    );

    final result = await repository.sync();

    expect(result.success, isTrue);
    expect(result.syncedChoiceCategories, ['QC_LOVE']);
    expect(choiceLocalDataSource.loadSnapshot('QC_LOVE')!.version, 2);
    expect(result.remoteChoiceVersions['QC_LOVE'], 2);
  });

  test('로컬 캐시가 없고 서버가 실패하면 bootstrap 실패로 반환한다', () async {
    final repository = CodebookRepositoryImpl(
      remoteDataSource: _FakeRemoteDataSource(
        remoteVersions: const CodebookVersionMap.empty(),
        snapshots: const {},
        failingGroups: {CodebookGroup.bodyType},
        throwOnVersions: true,
      ),
      localDataSource: CodebookLocalDataSource(),
    );

    final result = await repository.sync();

    expect(result.success, isFalse);
    expect(result.errorMessage, isNotNull);
  });
}

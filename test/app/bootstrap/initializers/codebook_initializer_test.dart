import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:wingle/app/bootstrap/initializers/codebook_initializer.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/onboarding/data/codebook/choice_question_local_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_local_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_remote_datasource.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_repository_impl.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';

void main() {
  late Directory tempDir;
  late CodebookLocalDataSource localDataSource;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    await HiveUtil.initialize(HiveAesCipher(Hive.generateSecureKey()));
    localDataSource = CodebookLocalDataSource();
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('필수 코드북 그룹이 비어 있으면 초기화 실패로 처리한다', () async {
    final initializer = CodebookInitializer(
      repository: CodebookRepositoryImpl(
        remoteDataSource: const _EmptyRemoteDataSource(),
        localDataSource: localDataSource,
        choiceLocalDataSource: const ChoiceQuestionLocalDataSource(),
      ),
    );

    final result = await initializer.initialize();

    expect(result.success, isFalse);
    expect(result.errorMessage, contains('BODY_TYPE'));
    expect(result.errorMessage, contains('REGION'));
    expect(result.errorMessage, contains('JOB'));
    expect(result.errorMessage, contains('UNIVERSITY'));
  });

  test('필수 코드북 그룹이 로컬에 있으면 초기화 성공으로 처리한다', () async {
    await localDataSource.replaceSnapshots({
      CodebookGroup.bodyType: const CodebookSnapshot(
        version: 1,
        codes: [
          CodebookEntry(code: 'BT_M_001', codeName: '보통', displayOrder: 1),
        ],
      ),
      CodebookGroup.region: const CodebookSnapshot(
        version: 1,
        codes: [
          CodebookEntry(code: 'R_11', codeName: '서울특별시', displayOrder: 1),
        ],
      ),
      CodebookGroup.job: const CodebookSnapshot(
        version: 1,
        codes: [CodebookEntry(code: 'J101', codeName: '무직', displayOrder: 1)],
      ),
      CodebookGroup.university: const CodebookSnapshot(
        version: 1,
        codes: [
          CodebookEntry(code: 'U001', codeName: '테스트대학교', displayOrder: 1),
        ],
      ),
    });
    final initializer = CodebookInitializer(
      repository: CodebookRepositoryImpl(
        remoteDataSource: const _EmptyRemoteDataSource(),
        localDataSource: localDataSource,
        choiceLocalDataSource: const ChoiceQuestionLocalDataSource(),
      ),
    );

    final result = await initializer.initialize();

    expect(result.success, isTrue);
  });
}

class _EmptyRemoteDataSource implements CodebookRemoteDataSource {
  const _EmptyRemoteDataSource();

  @override
  Future<CodebookVersionMap> fetchCurrentVersions() async {
    return const CodebookVersionMap.empty();
  }

  @override
  Future<Map<CodebookGroup, CodebookSnapshot>> fetchSnapshots(
    List<CodebookGroup> groups,
  ) async {
    return const {};
  }

  @override
  Future<Map<String, int>> fetchChoiceQuestionCurrentVersions() async {
    return const {};
  }

  @override
  Future<Map<String, ChoiceQuestionSetSnapshot>> fetchChoiceQuestionSnapshot({
    required List<String> categories,
  }) async {
    return const {};
  }
}

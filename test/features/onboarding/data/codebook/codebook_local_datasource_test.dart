import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_local_datasource.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_entry.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_group.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_snapshot.dart';

void main() {
  late Directory tempDir;
  late CodebookLocalDataSource dataSource;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    final cipher = HiveAesCipher(Hive.generateSecureKey());
    await HiveUtil.initialize(cipher);
    dataSource = CodebookLocalDataSource();
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('버전과 snapshot을 저장하고 정렬된 code를 조회한다', () async {
    await dataSource.replaceSnapshots({
      CodebookGroup.bodyType: CodebookSnapshot(
        version: 3,
        codes: [
          const CodebookEntry(
            code: 'BT_2',
            codeName: 'B',
            parentCode: null,
            displayOrder: 2,
          ),
          const CodebookEntry(
            code: 'BT_1',
            codeName: 'A',
            parentCode: null,
            displayOrder: 1,
          ),
        ],
      ),
    });

    final versions = dataSource.loadVersions();
    final codes = dataSource.loadCodes(CodebookGroup.bodyType);

    expect(versions.versions[CodebookGroup.bodyType]!, 3);
    expect(codes.map((value) => value.code), ['BT_1', 'BT_2']);
    expect(
      dataSource.findByCode(CodebookGroup.bodyType, 'BT_2')?.codeName,
      'B',
    );
    expect(
      HiveConstants.boxes.any((box) => box.name == 'codebook_snapshot'),
      isTrue,
    );
  });
}

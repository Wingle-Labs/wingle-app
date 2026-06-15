import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:http/http.dart' as http;
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/onboarding/data/body_shape_repository_impl.dart';
import 'package:wingle/features/onboarding/data/codebook/codebook_local_datasource.dart';
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

  test('BodyShapeRepositoryImpl은 BODY_TYPE 코드북 snapshot을 반환한다', () async {
    await localDataSource.replaceSnapshots({
      CodebookGroup.bodyType: const CodebookSnapshot(
        version: 1,
        codes: [
          CodebookEntry(
            code: 'BT_M_001',
            codeName: '슬림',
            parentCode: 'BT_MALE',
            displayOrder: 1,
          ),
          CodebookEntry(
            code: 'BT_F_001',
            codeName: '슬림',
            parentCode: 'BT_FEMALE',
            displayOrder: 1,
          ),
        ],
      ),
    });
    final repository = BodyShapeRepositoryImpl(
      client: http.Client(),
      baseUrl: 'https://api.example.com',
      localDataSource: localDataSource,
    );

    final codebook = repository.fetchBodyShapeCodebook();

    expect(codebook.optionsForGender('male').first.code, 'BT_M_001');
    expect(codebook.optionsForGender('female').first.code, 'BT_F_001');
  });

  test('BODY_TYPE snapshot이 없으면 실패한다', () {
    final repository = BodyShapeRepositoryImpl(
      client: http.Client(),
      baseUrl: 'https://api.example.com',
      localDataSource: localDataSource,
    );

    expect(repository.fetchBodyShapeCodebook, throwsA(isA<StateError>()));
  });
}

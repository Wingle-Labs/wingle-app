import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:value_date/common/constants/hive_constants.dart';
import 'package:value_date/common/utils/hive_util.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    await HiveUtil.clearAll(); // 초기화
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('HiveUtil write, read: 값 쓰고 읽기', () async {
    await HiveUtil.write(key: HiveLoginBox.userId, value: 'test_user');

    final value = await HiveUtil.read(HiveLoginBox.userId);

    expect(value, 'test_user');
  });

  test('HiveUtil.delete: key 삭제', () async {
    await HiveUtil.write(key: HiveLoginBox.accessToken, value: 'token_value');

    await HiveUtil.delete(HiveLoginBox.accessToken);

    final value = await HiveUtil.read(HiveLoginBox.accessToken);

    expect(value, isNull);
  });

  test('HiveUtil.clearBox: Box에서 모든 key 삭제', () async {
    await HiveUtil.write(key: HiveLoginBox.userId, value: 'user');
    await HiveUtil.write(key: HiveLoginBox.accessToken, value: 'token');

    await HiveUtil.clearBox(HiveConstants.userLoginInfo);

    final v1 = await HiveUtil.read(HiveLoginBox.userId);
    final v2 = await HiveUtil.read(HiveLoginBox.accessToken);

    expect(v1, isNull);
    expect(v2, isNull);
  });

  test('HiveUtil.clearAll: 모든 Box 삭제', () async {
    await HiveUtil.write(key: HiveLoginBox.userId, value: 'user123');
    await HiveUtil.write(key: HiveLoginBox.refreshToken, value: 'refresh123');

    await HiveUtil.clearAll();

    final userId = await HiveUtil.read(HiveLoginBox.userId);
    final refreshToken = await HiveUtil.read(HiveLoginBox.refreshToken);

    expect(userId, isNull);
    expect(refreshToken, isNull);
  });
}

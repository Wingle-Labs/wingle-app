// lib/common/utils/hive_util.dart

import 'package:hive_ce/hive.dart';
import 'package:value_date/common/constants/hive_constants.dart';

/// Hive 유틸리티 클래스 - Hive box에 대한 CRUD 작업을 제공합니다.
/// key를 직접 string으로 입력하지 않고, HiveKey 타입을 통해 안전하게 접근합니다.
class HiveUtil {
  /// HiveBox 객체 기반으로 Box 오픈
  static Future<Box> _openHiveBox(HiveBox box) async {
    if (Hive.isBoxOpen(box.name)) {
      return Hive.box(box.name);
    }
    return await Hive.openBox(box.name);
  }

  /// 저장할 HiveKey와 값만 전달하면 자동으로 Box를 열고 저장합니다.
  static Future<void> write<T>({
    required HiveKey<T> key,
    required T value,
  }) async {
    final boxInstance = await _openHiveBox(key.box);
    await boxInstance.put(key.name, value);
  }

  /// HiveKey만 전달하면 해당 키에 저장된 값을 읽어옵니다.
  static Future<T?> read<T>(HiveKey<T> key) async {
    final boxInstance = await _openHiveBox(key.box);
    return boxInstance.get(key.name);
  }

  /// HiveKey만 전달하면 해당 키를 삭제합니다.
  static Future<void> delete<T>(HiveKey<T> key) async {
    final boxInstance = await _openHiveBox(key.box);
    await boxInstance.delete(key.name);
  }

  /// 모든 데이터를 삭제합니다.
  static Future<void> clearAll() async {
    for (final box in HiveConstants.boxes) {
      final boxInstance = await _openHiveBox(box);
      await boxInstance.clear();
    }
  }

  /// 특정 Box의 모든 데이터를 삭제합니다.
  static Future<void> clearBox(HiveBox box) async {
    final boxInstance = await _openHiveBox(box);
    await boxInstance.clear();
  }
}

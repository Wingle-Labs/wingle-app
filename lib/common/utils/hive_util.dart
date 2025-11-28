// lib/common/utils/hive_util.dart

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:value_date/common/constants/hive_constants.dart';

/// Hive 유틸리티 클래스 - Hive box에 대한 CRUD 작업을 제공합니다.
/// key를 직접 string으로 입력하지 않고, HiveKey 타입을 통해 안전하게 접근합니다.
class HiveUtil {
  /// HiveBox 객체 기반으로 Box 오픈
  static Future<void> initialize(HiveAesCipher cipher) async {
    for (final box in HiveConstants.boxes) {
      final secureCipher = box.isEncrypted ? cipher : null;
      await Hive.openBox(box.name, encryptionCipher: secureCipher);
    }
  }

  static Box _getBox(HiveBox box) {
    if (!Hive.isBoxOpen(box.name)) {
      throw Exception(
        '[HiveUtil] Hive Box "${box.name}"가 열려 있지 않습니다. '
        'HiveUtil.initialize()를 먼저 호출해주세요.',
      );
    }
    return Hive.box(box.name);
  }

  /// 저장할 HiveKey와 값만 전달하면 자동으로 Box를 열고 저장합니다.
  static Future<void> write<T>({
    required HiveKey<T> key,
    required T value,
  }) async {
    final box = _getBox(key.box);
    await box.put(key.name, value);
  }

  /// HiveKey만 전달하면 해당 키에 저장된 값을 읽어옵니다.
  static T? read<T>(HiveKey<T> key) {
    final box = _getBox(key.box);
    final value = box.get(key.name);
    if (value is T) return value;
    return null;
  }

  /// HiveKey만 전달하면 해당 키를 삭제합니다.
  static Future<void> delete<T>(HiveKey<T> key) async {
    final box = _getBox(key.box);
    await box.delete(key.name);
  }

  /// 모든 데이터를 삭제합니다.
  static Future<void> clearAll() async {
    for (final box in HiveConstants.boxes) {
      final boxInstance = _getBox(box);
      await boxInstance.clear();
    }
  }

  /// 특정 Box의 모든 데이터를 삭제합니다.
  static Future<void> clearBox(HiveBox box) async {
    final boxInstance = _getBox(box);
    await boxInstance.clear();
  }
}

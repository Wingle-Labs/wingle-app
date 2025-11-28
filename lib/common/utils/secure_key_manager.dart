import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:wingle/common/constants/secure_storage_constants.dart';
import 'package:wingle/common/utils/secure_storage_util.dart';

/// Hive AES Cipher를 관리하는 싱글톤 클래스
class SecureKeyManager {
  SecureKeyManager._internal();

  /// 싱글톤 인스턴스
  static final SecureKeyManager instance = SecureKeyManager._internal();

  List<int>? _keyBytes;
  HiveAesCipher? _cipher;

  /// AES cipher 초기화 메소드
  Future<void> initialize() async {
    final storedKey = await SecureStorageUtil.readKey(
      SecureStorageType.hiveAesKey,
    );

    if (storedKey == null) {
      final newKey = Hive.generateSecureKey();
      final encoded = base64Encode(newKey);
      await SecureStorageUtil.createKey(SecureStorageType.hiveAesKey, encoded);
      _keyBytes = newKey;
    } else {
      _keyBytes = base64Decode(storedKey);
    }

    _cipher = HiveAesCipher(_keyBytes!);
  }

  /// cipher getter
  HiveAesCipher get cipher {
    if (_cipher == null) {
      throw Exception(
        'SecureKeyManager.initialize() must be called before accessing cipher.',
      );
    }
    return _cipher!;
  }
}

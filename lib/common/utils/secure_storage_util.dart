import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:value_date/common/constants/secure_storage_constants.dart';

/// Secure Storage를 사용하여 Hive AES 키를 안전하게 관리하는 유틸리티 클래스
/// 앱 종료 후에도 키를 유지하고, 보안적으로 안전하게 저장합니다.
class SecureStorageUtil {
  static const _storage = FlutterSecureStorage();

  /// 키를 생성하여 저장합니다.
  /// 기존 키가 있다면 덮어씁니다.
  static Future<String> createKey(SecureStorageType type, String value) async {
    await _storage.write(key: type.value, value: value);

    return value;
  }

  /// 저장된 키를 읽어옵니다.
  static Future<String?> readKey(SecureStorageType type) async {
    return await _storage.read(key: type.value);
  }

  /// 키를 삭제합니다.
  /// 키가 존재하지 않아도 에러를 발생시키지 않습니다.
  static Future<void> deleteKey(SecureStorageType type) async {
    await _storage.delete(key: type.value);
  }

  /// 키가 존재하는지 확인합니다.
  /// 키가 존재하면 true, 없으면 false를 반환합니다.
  static Future<bool> hasKey(SecureStorageType type) async {
    return await _storage.containsKey(key: type.value);
  }
}

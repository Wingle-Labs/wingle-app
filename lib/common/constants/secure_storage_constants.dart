/// Secure Storage 관련 상수들을 정의하는 enum
enum SecureStorageType {
  /// Hive AES 키를 저장하는 키 이름
  hiveAesKey('hive_aes_key'),

  /// Device UUID를 저장하는 키 이름
  deviceUuid('device_uuid');

  const SecureStorageType(this.value);

  /// 값으로 문자열을 반환합니다.
  final String value;
}

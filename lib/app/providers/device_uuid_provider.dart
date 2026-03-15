import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:wingle/common/constants/secure_storage_constants.dart';

part 'device_uuid_provider.g.dart';

/// 기기 고유 ID를 관리하는 Provider
@Riverpod(keepAlive: true)
class DeviceUuid extends _$DeviceUuid {
  static final _key = SecureStorageType.deviceUuid.value;

  final _storage = const FlutterSecureStorage();

  @override
  String build() {
    throw StateError("Device UUID가 초기화되지 않았습니다. initialize()를 먼저 호출해주세요.");
  }

  /// 앱 시작 시 UUID 초기화
  Future<void> initialize() async {
    final saved = await _storage.read(key: _key);

    final uuid = saved ?? const Uuid().v4();

    if (saved == null) {
      await _storage.write(key: _key, value: uuid);
    }

    state = uuid;
  }
}

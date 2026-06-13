import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/features/onboarding/application/device_contact_service.dart';

part 'device_contact_service_provider.g.dart';

/// 기기 연락처 조회 서비스를 제공한다.
@Riverpod(keepAlive: true)
DeviceContactService deviceContactService(Ref ref) {
  return const FlutterDeviceContactService();
}

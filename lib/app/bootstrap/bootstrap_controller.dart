import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/app/bootstrap/bootstrap_initializer.dart';
import 'package:wingle/app/bootstrap/bootstrap_initializer_provider.dart';
import 'package:wingle/app/providers/device_uuid_provider.dart';
import 'package:wingle/features/notification/presentation/providers/fcm_token_service_provider.dart';

part 'bootstrap_controller.g.dart';

/// 앱 실행에 필요한 부트스트랩 상태를 관리한다.
@Riverpod(keepAlive: true)
class BootstrapController extends _$BootstrapController {
  @override
  Future<BootstrapInitializeResult> build() {
    return _initialize();
  }

  /// 실패한 부트스트랩을 다시 시도한다.
  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_initialize);
  }

  Future<BootstrapInitializeResult> _initialize() async {
    await ref.read(deviceUuidProvider.notifier).initialize();

    final result = await ref.read(bootstrapInitializerProvider).initialize();
    debugPrint('[Bootstrap] auth session: ${result.authSession.status.name}');

    if (!result.success) {
      debugPrint(
        '[Bootstrap] initialize failed: ${result.codebook.errorMessage}',
      );
      return result;
    }

    if (result.codebook.usedOfflineCache) {
      debugPrint('[Bootstrap] using offline codebook cache');
    }

    if (!kIsWeb && result.authSession.isAuthenticated) {
      final fcmTokenService = ref.read(fcmTokenServiceProvider);
      fcmTokenService.startTokenRefreshListener();
      unawaited(fcmTokenService.registerCurrentToken());
    }

    return result;
  }
}

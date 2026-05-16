import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:wingle/app/bootstrap/bootstrap_initializer_provider.dart';
import 'package:wingle/app/config/app_localization_wrapper.dart';
import 'package:wingle/app/config/firebase_options.dart';
import 'package:wingle/app/providers/device_uuid_provider.dart';
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/common/utils/secure_key_manager.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Flutter 앱 초기화 순서
  /// 1. 로컬라이제이션 초기화
  /// 2. 보안 키 관리자 초기화
  /// 3. Hive 초기화
  /// 4. 환경 변수 로드
  /// 5. Hive 박스 초기화
  /// 6. Firebase 초기화
  await EasyLocalization.ensureInitialized();
  await SecureKeyManager.instance.initialize();
  await Hive.initFlutter();
  await EnvUtil.loadAll(EnvConstants.envs);
  await HiveUtil.initialize(SecureKeyManager.instance.cipher);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Riverpod bootstrap
  final container = ProviderContainer();

  /// 기기 UUID 초기화
  await container.read(deviceUuidProvider.notifier).initialize();

  /// 코드북 bootstrap
  await container.read(bootstrapInitializerProvider).initialize();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: AppLocalizationWrapper(child: const App()),
    ),
  );
}

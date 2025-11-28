import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:value_date/app/config/firebase_options.dart';
import 'package:value_date/app/config/localization.dart';
import 'package:value_date/common/utils/env_util.dart';
import 'package:value_date/common/utils/hive_util.dart';
import 'package:value_date/common/utils/secure_key_manager.dart';

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
  await EnvUtil.loadAll();
  await HiveUtil.initialize(SecureKeyManager.instance.cipher);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ProviderScope(child: AppLocalizationWrapper(child: const App())));
}

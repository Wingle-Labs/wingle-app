import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'config/adaptive_theme.dart';

/// 어댑티브 테마를 사용하는 메인 어플리케이션 위젯
/// 어플리케이션의 전반적인 테마와 레이아웃을 관리합니다.
class App extends StatefulWidget {
  /// 메인 어플리케이션 위젯을 생성합니다.
  /// 어댑티브 테마와 네비게이션을 포함합니다.
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return const AppTheming();
  }
}

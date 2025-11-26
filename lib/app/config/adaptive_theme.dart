import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme/themes.dart';

/// 어댑티브 테마 래퍼
/// 어플리케이션의 라이트/다크 테마를 관리합니다.
class AppTheming extends ConsumerWidget {
  /// 어댑티브 테마에 포함될 홈 위젯
  final Widget home;

  /// 어댑티브 테마 래퍼를 생성합니다.
  /// [home]은 어댑티브 테마에 포함될 홈 위젯입니다.
  const AppTheming({super.key, required this.home});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveTheme(
      light: Themes.light,
      dark: Themes.dark,
      initial: AdaptiveThemeMode.system,
      debugShowFloatingThemeButton: false,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        home: home,
      ),
    );
  }
}

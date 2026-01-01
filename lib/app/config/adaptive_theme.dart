import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/providers/localization_provider.dart';
import 'package:wingle/app/providers/router_provider.dart';

import 'theme/themes.dart';

/// 어댑티브 테마 래퍼
/// 어플리케이션의 라이트/다크 테마를 관리합니다.
class AppTheming extends ConsumerWidget {
  /// 어댑티브 테마 래퍼를 생성합니다.
  const AppTheming({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveTheme(
      light: Themes.light,
      dark: Themes.dark,
      initial: AdaptiveThemeMode.system,
      debugShowFloatingThemeButton: true,
      builder: (theme, darkTheme) => MaterialApp.router(
        theme: theme,
        darkTheme: darkTheme,
        locale: ref.watch(localizationProvider),
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        routerConfig: ref.watch(routerProvider),
      ),
    );
  }
}

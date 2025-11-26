import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:value_date/themes.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ko')],
        path: 'assets/translations',
        fallbackLocale: const Locale('ko'),
        child: MainApp(),
      ),
    ),
  );
}

/// The main application widget.
class MainApp extends ConsumerStatefulWidget {
  /// The main application widget.
  const MainApp({super.key});

  @override
  ConsumerState createState() => _MainApp();
}

class _MainApp extends ConsumerState {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: Themes.light,
      dark: Themes.dark,
      initial: AdaptiveThemeMode.system,
      debugShowFloatingThemeButton: true,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('test-text'.tr()),
                FilledButton(
                  onPressed: () {},
                  child: Text('toggle-theme'.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

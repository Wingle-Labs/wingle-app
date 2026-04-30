import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/app_localization_wrapper.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/app/providers/device_uuid_provider.dart';
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/common/utils/secure_key_manager.dart';
import 'package:wingle/widgetbook/components/widgetbook_component_folder.dart';
import 'package:wingle/widgetbook/foundations/color_page.dart';
import 'package:wingle/widgetbook/foundations/elevation_page.dart';
import 'package:wingle/widgetbook/foundations/padding_page.dart';
import 'package:wingle/widgetbook/foundations/radius_page.dart';
import 'package:wingle/widgetbook/foundations/size_page.dart';
import 'package:wingle/widgetbook/foundations/spacing_page.dart';
import 'package:wingle/widgetbook/foundations/typography_page.dart';
import 'package:wingle/widgetbook/screens/widgetbook_screen_folders.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SecureKeyManager.instance.initialize();
  await Hive.initFlutter();
  await EnvUtil.loadAll(EnvConstants.envs);
  await HiveUtil.initialize(SecureKeyManager.instance.cipher);

  final container = ProviderContainer();
  await container.read(deviceUuidProvider.notifier).initialize();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: AppLocalizationWrapper(child: const WingleWidgetbook()),
    ),
  );
}

/// Widgetbook 앱
class WingleWidgetbook extends StatelessWidget {
  /// 생성자
  const WingleWidgetbook({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        WidgetbookFolder(
          name: 'Foundations',
          children: [
            WidgetbookComponent(
              name: 'Typography',
              useCases: [
                WidgetbookUseCase(
                  name: 'All Styles',
                  builder: (context) => const TypographyPage(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Colors',
              useCases: [
                WidgetbookUseCase(
                  name: 'All Styles',
                  builder: (context) {
                    /// 테마 변경
                    final theme = context.knobs.object.dropdown<ThemeMode>(
                      label: 'Theme',
                      options: const [
                        ThemeMode.light,
                        ThemeMode.dark,
                        ThemeMode.system,
                      ],
                      initialOption: ThemeMode.light,
                      labelBuilder: (mode) => switch (mode) {
                        ThemeMode.light => 'Light',
                        ThemeMode.dark => 'Dark',
                        ThemeMode.system => 'System',
                      },
                    );
                    return MaterialApp(
                      themeMode: theme,
                      theme: Themes.light,
                      darkTheme: Themes.dark,
                      home: const ColorPage(),
                    );
                  },
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Elevation',
              useCases: [
                WidgetbookUseCase(
                  name: 'All Styles',
                  builder: (context) => const ElevationPage(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Padding',
              useCases: [
                WidgetbookUseCase(
                  name: 'All Styles',
                  builder: (context) => const PaddingPage(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Radius',
              useCases: [
                WidgetbookUseCase(
                  name: 'All Styles',
                  builder: (context) => const RadiusPage(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Size',
              useCases: [
                WidgetbookUseCase(
                  name: 'All Styles',
                  builder: (context) => const SizePage(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Spacing',
              useCases: [
                WidgetbookUseCase(
                  name: 'All Styles',
                  builder: (context) => const SpacingPage(),
                ),
              ],
            ),
          ],
        ),
        buildComponentFolder(),
        buildScreenFolder(),
      ],
      lightTheme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeMode.light,
      appBuilder: (context, child) =>
          Theme(data: Theme.of(context), child: child),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/widgetbook/foundations/color_page.dart';
import 'package:wingle/widgetbook/foundations/padding_page.dart';
import 'package:wingle/widgetbook/foundations/radius_page.dart';
import 'package:wingle/widgetbook/foundations/size_page.dart';

import 'widgetbook/foundations/typography_page.dart';

void main() {
  runApp(const WingleWidgetbook());
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
                    final theme = context.knobs.object.dropdown(
                      label: 'Theme',
                      options: ThemeMode.values,
                      initialOption: ThemeMode.system,
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
          ],
        ),
      ],
      lightTheme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeMode.system,
      appBuilder: (context, child) =>
          Theme(data: Theme.of(context), child: child),
    );
  }
}

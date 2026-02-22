import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/themes.dart';

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

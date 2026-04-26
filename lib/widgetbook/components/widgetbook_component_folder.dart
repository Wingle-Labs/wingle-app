import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/widgetbook/components/default_app_bar_page.dart';

/// Widgetbook의 컴포넌트 폴더를 구성한다.
WidgetbookFolder buildComponentFolder() {
  return WidgetbookFolder(
    name: 'Components',
    children: [
      WidgetbookComponent(
        name: 'DefaultAppBar',
        useCases: [
          WidgetbookUseCase(
            name: 'Basic',
            builder: (context) => const DefaultAppBarPage(
              initialLayout: DefaultAppBarLayout.basic,
              initialShowSubtitle: false,
            ),
          ),
          WidgetbookUseCase(
            name: 'Basic With Subtitle',
            builder: (context) => const DefaultAppBarPage(
              initialLayout: DefaultAppBarLayout.basic,
              initialShowSubtitle: true,
            ),
          ),
          WidgetbookUseCase(
            name: 'Side',
            builder: (context) => const DefaultAppBarPage(
              initialLayout: DefaultAppBarLayout.side,
              initialShowSubtitle: false,
            ),
          ),
          WidgetbookUseCase(
            name: 'Display',
            builder: (context) => const DefaultAppBarPage(
              initialLayout: DefaultAppBarLayout.display,
              initialShowSubtitle: false,
            ),
          ),
          WidgetbookUseCase(
            name: 'Display With Subtitle',
            builder: (context) => const DefaultAppBarPage(
              initialLayout: DefaultAppBarLayout.display,
              initialShowSubtitle: true,
            ),
          ),
          WidgetbookUseCase(
            name: 'Both Empty',
            builder: (context) => const DefaultAppBarPage(
              initialLayout: DefaultAppBarLayout.basic,
              initialShowTitle: false,
              initialShowSubtitle: false,
            ),
          ),
        ],
      ),
    ],
  );
}

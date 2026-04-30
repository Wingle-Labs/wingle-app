import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/widgetbook/components/default_app_bar_page.dart';
import 'package:wingle/widgetbook/components/divider_page.dart';
import 'package:wingle/widgetbook/components/icon_page.dart';
import 'package:wingle/widgetbook/components/pagination_page.dart';
import 'package:wingle/widgetbook/components/selections/checkbox_page.dart';
import 'package:wingle/widgetbook/components/selections/radio_page.dart';
import 'package:wingle/widgetbook/components/snackbar_page.dart';

/// Widgetbook의 컴포넌트 폴더를 구성한다.
WidgetbookFolder buildComponentFolder() {
  return WidgetbookFolder(
    name: 'Components',
    children: [
      WidgetbookComponent(
        name: 'Divider',
        useCases: [
          WidgetbookUseCase(
            name: 'Default',
            builder: (context) => const DividerPage(),
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'Icon',
        useCases: [
          WidgetbookUseCase(
            name: 'Default',
            builder: (context) => const IconPage(),
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'Snackbar',
        useCases: [
          WidgetbookUseCase(
            name: 'Default',
            builder: (context) => const SnackbarPage(),
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'Pagination',
        useCases: [
          WidgetbookUseCase(
            name: 'Default',
            builder: (context) => const PaginationPage(),
          ),
        ],
      ),
      WidgetbookFolder(
        name: 'Selections',
        children: [
          WidgetbookComponent(
            name: 'Checkbox',
            useCases: [
              WidgetbookUseCase(
                name: 'Default',
                builder: (context) => const CheckboxPage(),
              ),
            ],
          ),
          WidgetbookComponent(
            name: 'Radio',
            useCases: [
              WidgetbookUseCase(
                name: 'Default',
                builder: (context) => const RadioPage(),
              ),
            ],
          ),
        ],
      ),
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

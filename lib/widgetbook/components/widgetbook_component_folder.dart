import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/widgetbook/components/badge_page.dart';
import 'package:wingle/widgetbook/components/buttons/basic_button_page.dart';
import 'package:wingle/widgetbook/components/buttons/filled_button_page.dart';
import 'package:wingle/widgetbook/components/buttons/full_width_button_page.dart';
import 'package:wingle/widgetbook/components/buttons/outlined_button_page.dart';
import 'package:wingle/widgetbook/components/buttons/text_button_page.dart';
import 'package:wingle/widgetbook/components/cards_page.dart';
import 'package:wingle/widgetbook/components/chip_button_page.dart';
import 'package:wingle/widgetbook/components/default_app_bar_page.dart';
import 'package:wingle/widgetbook/components/divider_page.dart';
import 'package:wingle/widgetbook/components/icon_page.dart';
import 'package:wingle/widgetbook/components/input_field_page.dart';
import 'package:wingle/widgetbook/components/misc_components_page.dart';
import 'package:wingle/widgetbook/components/pagination_page.dart';
import 'package:wingle/widgetbook/components/selections/check_page.dart';
import 'package:wingle/widgetbook/components/selections/checkbox_page.dart';
import 'package:wingle/widgetbook/components/selections/radio_page.dart';
import 'package:wingle/widgetbook/components/selections/toggle_icon_page.dart';
import 'package:wingle/widgetbook/components/selections/toggle_switch_page.dart';
import 'package:wingle/widgetbook/components/snackbar_page.dart';
import 'package:wingle/widgetbook/components/states_page.dart';
import 'package:wingle/widgetbook/components/texts_page.dart';
import 'package:wingle/widgetbook/components/wrappers_page.dart';

/// Widgetbook의 컴포넌트 폴더를 구성한다.
WidgetbookFolder buildComponentFolder() {
  return WidgetbookFolder(
    name: 'Components',
    children: [
      WidgetbookFolder(
        name: 'Button',
        children: [
          WidgetbookComponent(
            name: 'Common',
            useCases: [
              WidgetbookUseCase(
                name: 'Default',
                builder: (context) => const BasicButtonPage(),
              ),
            ],
          ),
          WidgetbookComponent(
            name: 'Filled',
            useCases: [
              WidgetbookUseCase(
                name: 'Default',
                builder: (context) => const FilledButtonPage(),
              ),
            ],
          ),
          WidgetbookComponent(
            name: 'Outlined',
            useCases: [
              WidgetbookUseCase(
                name: 'Default',
                builder: (context) => const OutlinedButtonPage(),
              ),
            ],
          ),
          WidgetbookComponent(
            name: 'Text',
            useCases: [
              WidgetbookUseCase(
                name: 'Default',
                builder: (context) => const TextButtonPage(),
              ),
            ],
          ),
          WidgetbookComponent(
            name: 'Full Width',
            useCases: [
              WidgetbookUseCase(
                name: 'Default',
                builder: (context) => const FullWidthButtonPage(),
              ),
            ],
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'Chip Button',
        useCases: [
          WidgetbookUseCase(
            name: 'Default',
            builder: (context) => const ChipButtonPage(),
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'Badge',
        useCases: [
          WidgetbookUseCase(
            name: 'Default',
            builder: (context) => const BadgePage(),
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'Cards',
        useCases: [
          WidgetbookUseCase(
            name: 'All States',
            builder: (context) => const CardsPage(),
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'Input Field',
        useCases: [
          WidgetbookUseCase(
            name: 'Normal',
            builder: (context) => const InputFieldPage(),
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'Texts',
        useCases: [
          WidgetbookUseCase(
            name: 'All States',
            builder: (context) => const TextsPage(),
          ),
        ],
      ),
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
        name: 'States',
        useCases: [
          WidgetbookUseCase(
            name: 'All States',
            builder: (context) => const StatesPage(),
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
        name: 'Misc',
        useCases: [
          WidgetbookUseCase(
            name: 'All States',
            builder: (context) => const MiscComponentsPage(),
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'Wrappers',
        useCases: [
          WidgetbookUseCase(
            name: 'All States',
            builder: (context) => const WrappersPage(),
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
            name: 'Check',
            useCases: [
              WidgetbookUseCase(
                name: 'Default',
                builder: (context) => const CheckPage(),
              ),
            ],
          ),
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
          WidgetbookComponent(
            name: 'Toggle Switch',
            useCases: [
              WidgetbookUseCase(
                name: 'Default',
                builder: (context) => const ToggleSwitchPage(),
              ),
            ],
          ),
          WidgetbookComponent(
            name: 'Toggle Icon',
            useCases: [
              WidgetbookUseCase(
                name: 'Default',
                builder: (context) => const ToggleIconPage(),
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

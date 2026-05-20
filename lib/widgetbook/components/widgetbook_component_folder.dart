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
import 'package:wingle/widgetbook/components/codebook/codebook_explorer_page.dart';
import 'package:wingle/widgetbook/components/codebook/codebook_snapshot_page.dart';
import 'package:wingle/widgetbook/components/codebook/codebook_story_specs.dart';
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
        name: 'Buttons',
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
          WidgetbookComponent(
            name: 'Chip Button',
            useCases: [
              WidgetbookUseCase(
                name: 'Default',
                builder: (context) => const ChipButtonPage(),
              ),
            ],
          ),
        ],
      ),
      WidgetbookFolder(
        name: 'Input',
        children: [
          WidgetbookComponent(
            name: 'DefaultInputField',
            useCases: [
              WidgetbookUseCase(
                name: 'Variants',
                builder: (context) => const InputFieldPage(),
              ),
            ],
          ),
        ],
      ),
      WidgetbookFolder(
        name: 'Navigation',
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
          WidgetbookComponent(
            name: 'Pagination',
            useCases: [
              WidgetbookUseCase(
                name: 'Default',
                builder: (context) => const PaginationPage(),
              ),
            ],
          ),
        ],
      ),
      WidgetbookFolder(
        name: 'Feedback',
        children: [
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
        ],
      ),
      WidgetbookFolder(
        name: 'Surfaces',
        children: [
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
            name: 'Divider',
            useCases: [
              WidgetbookUseCase(
                name: 'Default',
                builder: (context) => const DividerPage(),
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
        ],
      ),
      WidgetbookFolder(
        name: 'Selection',
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
      WidgetbookFolder(
        name: 'Text',
        children: [
          WidgetbookComponent(
            name: 'DefaultText',
            useCases: [
              WidgetbookUseCase(
                name: 'All States',
                builder: (context) => const TextsPage(),
              ),
            ],
          ),
        ],
      ),
      WidgetbookFolder(
        name: 'Icons',
        children: [
          WidgetbookComponent(
            name: 'Icon',
            useCases: [
              WidgetbookUseCase(
                name: 'Default',
                builder: (context) => const IconPage(),
              ),
            ],
          ),
        ],
      ),
      WidgetbookFolder(
        name: 'Misc',
        children: [
          WidgetbookComponent(
            name: 'Date Picker and Shapes',
            useCases: [
              WidgetbookUseCase(
                name: 'All States',
                builder: (context) => const MiscComponentsPage(),
              ),
            ],
          ),
        ],
      ),
      WidgetbookFolder(
        name: 'Codebook',
        children: [
          WidgetbookComponent(
            name: 'Explorer',
            useCases: [
              WidgetbookUseCase(
                name: 'Current Versions',
                builder: (context) => const CodebookExplorerPage(),
              ),
            ],
          ),
          WidgetbookFolder(
            name: 'Snapshots',
            children: [
              for (final spec in codebookStorySpecs)
                WidgetbookComponent(
                  name: spec.key,
                  useCases: [
                    WidgetbookUseCase(
                      name: 'Snapshot',
                      builder: (context) =>
                          CodebookSnapshotPage(groupKey: spec.key),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    ],
  );
}

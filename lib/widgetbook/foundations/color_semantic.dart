// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/color/app_color_scheme.dart';
import 'package:wingle/app/config/theme/color/dark_color_scheme.dart';
import 'package:wingle/app/config/theme/color/light_color_scheme.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/app/config/theme/constants/weight.dart';

typedef _ColorGetter = Color Function(AppColorScheme scheme);

/// 시맨틱 컬러 스킴을 확인할 수 있는 페이지
class ColorSemanticPage extends StatelessWidget {
  /// 생성자
  const ColorSemanticPage({super.key});

  static const _sections = <_SemanticSectionData>[
    _SemanticSectionData(
      title: 'Static',
      items: [
        _SemanticColorItem(name: 'staticWhite', getter: _staticWhite),
        _SemanticColorItem(name: 'staticBlack', getter: _staticBlack),
      ],
    ),
    _SemanticSectionData(
      title: 'Primary / Secondary',
      items: [
        _SemanticColorItem(name: 'primaryNormal', getter: _primaryNormal),
        _SemanticColorItem(name: 'primaryStrong', getter: _primaryStrong),
        _SemanticColorItem(name: 'primaryHeavy', getter: _primaryHeavy),
        _SemanticColorItem(name: 'onPrimaryNormal', getter: _onPrimaryNormal),
        _SemanticColorItem(name: 'secondaryNormal', getter: _secondaryNormal),
        _SemanticColorItem(name: 'secondaryStrong', getter: _secondaryStrong),
        _SemanticColorItem(name: 'secondaryHeavy', getter: _secondaryHeavy),
        _SemanticColorItem(
          name: 'onSecondaryNormal',
          getter: _onSecondaryNormal,
        ),
      ],
    ),
    _SemanticSectionData(
      title: 'Background / Overlay / Scrim',
      items: [
        _SemanticColorItem(name: 'backgroundNormal', getter: _backgroundNormal),
        _SemanticColorItem(
          name: 'backgroundAlternative',
          getter: _backgroundAlternative,
        ),
        _SemanticColorItem(
          name: 'backgroundElevatedNormal',
          getter: _backgroundElevatedNormal,
        ),
        _SemanticColorItem(
          name: 'backgroundElevatedAlternative',
          getter: _backgroundElevatedAlternative,
        ),
        _SemanticColorItem(name: 'overlayInactive', getter: _overlayInactive),
        _SemanticColorItem(name: 'overlayPressed', getter: _overlayPressed),
        _SemanticColorItem(name: 'overlayDisabled', getter: _overlayDisabled),
        _SemanticColorItem(name: 'overlayLoading', getter: _overlayLoading),
        _SemanticColorItem(name: 'scrimNormal', getter: _scrimNormal),
        _SemanticColorItem(name: 'scrimStrong', getter: _scrimStrong),
      ],
    ),
    _SemanticSectionData(
      title: 'Interaction / Text / Stroke',
      items: [
        _SemanticColorItem(
          name: 'interactionInactive',
          getter: _interactionInactive,
        ),
        _SemanticColorItem(
          name: 'interactionDisable',
          getter: _interactionDisable,
        ),
        _SemanticColorItem(name: 'textStrong', getter: _textStrong),
        _SemanticColorItem(name: 'textNormal', getter: _textNormal),
        _SemanticColorItem(name: 'textNeutral', getter: _textNeutral),
        _SemanticColorItem(name: 'textAlternative', getter: _textAlternative),
        _SemanticColorItem(name: 'textAssistive', getter: _textAssistive),
        _SemanticColorItem(name: 'textDisable', getter: _textDisable),
        _SemanticColorItem(
          name: 'strokeStructuralBorder',
          getter: _strokeStructuralBorder,
        ),
        _SemanticColorItem(
          name: 'strokeStructuralDivider',
          getter: _strokeStructuralDivider,
        ),
        _SemanticColorItem(name: 'strokeNormal', getter: _strokeNormal),
        _SemanticColorItem(name: 'strokeNeutral', getter: _strokeNeutral),
        _SemanticColorItem(
          name: 'strokeAlternative',
          getter: _strokeAlternative,
        ),
        _SemanticColorItem(
          name: 'strokeSolidNormal',
          getter: _strokeSolidNormal,
        ),
        _SemanticColorItem(
          name: 'strokeSolidNeutral',
          getter: _strokeSolidNeutral,
        ),
        _SemanticColorItem(
          name: 'strokeSolidAlternative',
          getter: _strokeSolidAlternative,
        ),
      ],
    ),
    _SemanticSectionData(
      title: 'Status / Elevation',
      items: [
        _SemanticColorItem(name: 'statusPositive', getter: _statusPositive),
        _SemanticColorItem(name: 'statusCautionary', getter: _statusCautionary),
        _SemanticColorItem(name: 'statusNegative', getter: _statusNegative),
        _SemanticColorItem(
          name: 'elevationShadowNormal',
          getter: _elevationShadowNormal,
        ),
        _SemanticColorItem(
          name: 'elevationShadowEmphasize',
          getter: _elevationShadowEmphasize,
        ),
        _SemanticColorItem(
          name: 'elevationShadowStrong',
          getter: _elevationShadowStrong,
        ),
        _SemanticColorItem(
          name: 'elevationShadowHeavy',
          getter: _elevationShadowHeavy,
        ),
      ],
    ),
    _SemanticSectionData(
      title: 'Components',
      items: [
        _SemanticColorItem(
          name: 'componentFillNormal',
          getter: _componentFillNormal,
        ),
        _SemanticColorItem(
          name: 'componentFillStrong',
          getter: _componentFillStrong,
        ),
        _SemanticColorItem(
          name: 'componentFillAlternative',
          getter: _componentFillAlternative,
        ),
        _SemanticColorItem(
          name: 'componentPrimaryFilledButtonEnabled',
          getter: _componentPrimaryFilledButtonEnabled,
        ),
        _SemanticColorItem(
          name: 'componentPrimaryFilledButtonInactive',
          getter: _componentPrimaryFilledButtonInactive,
        ),
        _SemanticColorItem(
          name: 'componentPrimaryFilledButtonDisabled',
          getter: _componentPrimaryFilledButtonDisabled,
        ),
        _SemanticColorItem(
          name: 'componentSecondaryFilledButtonEnabled',
          getter: _componentSecondaryFilledButtonEnabled,
        ),
        _SemanticColorItem(
          name: 'componentSecondaryFilledButtonInactive',
          getter: _componentSecondaryFilledButtonInactive,
        ),
        _SemanticColorItem(
          name: 'componentSecondaryFilledButtonDisabled',
          getter: _componentSecondaryFilledButtonDisabled,
        ),
        _SemanticColorItem(
          name: 'componentPrimaryOutlinedButtonEnabled',
          getter: _componentPrimaryOutlinedButtonEnabled,
        ),
        _SemanticColorItem(
          name: 'componentPrimaryOutlinedButtonInactive',
          getter: _componentPrimaryOutlinedButtonInactive,
        ),
        _SemanticColorItem(
          name: 'componentPrimaryOutlinedButtonDisabled',
          getter: _componentPrimaryOutlinedButtonDisabled,
        ),
        _SemanticColorItem(
          name: 'componentSecondaryOutlinedButtonEnabled',
          getter: _componentSecondaryOutlinedButtonEnabled,
        ),
        _SemanticColorItem(
          name: 'componentSecondaryOutlinedButtonInactive',
          getter: _componentSecondaryOutlinedButtonInactive,
        ),
        _SemanticColorItem(
          name: 'componentSecondaryOutlinedButtonDisabled',
          getter: _componentSecondaryOutlinedButtonDisabled,
        ),
        _SemanticColorItem(
          name: 'componentAssistiveOutlinedButtonEnabled',
          getter: _componentAssistiveOutlinedButtonEnabled,
        ),
        _SemanticColorItem(
          name: 'componentAssistiveOutlinedButtonDisabled',
          getter: _componentAssistiveOutlinedButtonDisabled,
        ),
        _SemanticColorItem(
          name: 'componentPrimaryTextButtonEnabled',
          getter: _componentPrimaryTextButtonEnabled,
        ),
        _SemanticColorItem(
          name: 'componentPrimaryTextButtonDisabled',
          getter: _componentPrimaryTextButtonDisabled,
        ),
        _SemanticColorItem(
          name: 'componentSecondaryTextButtonEnabled',
          getter: _componentSecondaryTextButtonEnabled,
        ),
        _SemanticColorItem(
          name: 'componentSecondaryTextButtonDisabled',
          getter: _componentSecondaryTextButtonDisabled,
        ),
        _SemanticColorItem(
          name: 'componentAssistiveTextButtonEnabled',
          getter: _componentAssistiveTextButtonEnabled,
        ),
        _SemanticColorItem(
          name: 'componentAssistiveTextButtonDisabled',
          getter: _componentAssistiveTextButtonDisabled,
        ),
        _SemanticColorItem(
          name: 'componentFloatingActionButtonNormal',
          getter: _componentFloatingActionButtonNormal,
        ),
        _SemanticColorItem(
          name: 'componentFloatingActionButtonStrong',
          getter: _componentFloatingActionButtonStrong,
        ),
        _SemanticColorItem(
          name: 'componentCheckboxIconEnabled',
          getter: _componentCheckboxIconEnabled,
        ),
        _SemanticColorItem(
          name: 'componentCheckboxIconDisabled',
          getter: _componentCheckboxIconDisabled,
        ),
        _SemanticColorItem(
          name: 'componentBottomSheetHandle',
          getter: _componentBottomSheetHandle,
        ),
        _SemanticColorItem(
          name: 'componentInfoCardBackground',
          getter: _componentInfoCardBackground,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const lightScheme = LightColorScheme();
    const darkScheme = DarkColorScheme();

    return ListView(
      padding: const EdgeInsets.all(AppPadding.scaffold),
      children: [
        const Text(
          'light_color_scheme.dart와 dark_color_scheme.dart의 실제 시맨틱 컬러를 표시합니다.',
        ),
        const SizedBox(height: AppSpacing.md),
        ..._sections.map(
          (section) => _SemanticSection(
            title: section.title,
            items: section.items,
            lightScheme: lightScheme,
            darkScheme: darkScheme,
          ),
        ),
      ],
    );
  }
}

class _SemanticSection extends StatelessWidget {
  final String title;
  final List<_SemanticColorItem> items;
  final AppColorScheme lightScheme;
  final AppColorScheme darkScheme;

  const _SemanticSection({
    required this.title,
    required this.items,
    required this.lightScheme,
    required this.darkScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppPadding.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: AppFontSize.main,
              fontWeight: AppFontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...items.map(
            (item) => _SemanticColorRow(
              name: item.name,
              light: _resolve(item.getter, lightScheme),
              dark: _resolve(item.getter, darkScheme),
            ),
          ),
        ],
      ),
    );
  }

  _ResolvedColor _resolve(_ColorGetter getter, AppColorScheme scheme) {
    try {
      return _ResolvedColor.color(getter(scheme));
    } on UnimplementedError {
      return const _ResolvedColor.unimplemented();
    }
  }
}

class _SemanticColorRow extends StatelessWidget {
  final String name;
  final _ResolvedColor light;
  final _ResolvedColor dark;

  const _SemanticColorRow({
    required this.name,
    required this.light,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppPadding.card),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppRadius.iosStyleRadius,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: AppFontWeight.bold)),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _SchemePreview(label: 'Light', resolved: light),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SchemePreview(label: 'Dark', resolved: dark),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SchemePreview extends StatelessWidget {
  final String label;
  final _ResolvedColor resolved;

  const _SchemePreview({required this.label, required this.resolved});

  @override
  Widget build(BuildContext context) {
    if (!resolved.isImplemented) {
      return Container(
        height: 88,
        padding: const EdgeInsets.all(AppPadding.card),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: AppRadius.iosStyleRadius,
        ),
        alignment: Alignment.centerLeft,
        child: Text('$label\nUnimplemented'),
      );
    }

    final color = resolved.color!;
    final foreground =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black;
    final hex =
        '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';

    return Container(
      height: 88,
      padding: const EdgeInsets.all(AppPadding.card),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.iosStyleRadius,
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: foreground),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(label, style: const TextStyle(fontWeight: AppFontWeight.bold)),
            Text(hex, style: const TextStyle(fontSize: AppFontSize.caption)),
          ],
        ),
      ),
    );
  }
}

class _ResolvedColor {
  final Color? color;
  final bool isImplemented;

  const _ResolvedColor.color(this.color) : isImplemented = true;

  const _ResolvedColor.unimplemented() : color = null, isImplemented = false;
}

class _SemanticSectionData {
  final String title;
  final List<_SemanticColorItem> items;

  const _SemanticSectionData({required this.title, required this.items});
}

class _SemanticColorItem {
  final String name;
  final _ColorGetter getter;

  const _SemanticColorItem({required this.name, required this.getter});
}

Color _staticWhite(AppColorScheme scheme) => scheme.staticWhite;
Color _staticBlack(AppColorScheme scheme) => scheme.staticBlack;
Color _primaryNormal(AppColorScheme scheme) => scheme.primaryNormal;
Color _primaryStrong(AppColorScheme scheme) => scheme.primaryStrong;
Color _primaryHeavy(AppColorScheme scheme) => scheme.primaryHeavy;
Color _onPrimaryNormal(AppColorScheme scheme) => scheme.onPrimaryNormal;
Color _secondaryNormal(AppColorScheme scheme) => scheme.secondaryNormal;
Color _secondaryStrong(AppColorScheme scheme) => scheme.secondaryStrong;
Color _secondaryHeavy(AppColorScheme scheme) => scheme.secondaryHeavy;
Color _onSecondaryNormal(AppColorScheme scheme) => scheme.onSecondaryNormal;
Color _backgroundNormal(AppColorScheme scheme) => scheme.backgroundNormal;
Color _backgroundAlternative(AppColorScheme scheme) =>
    scheme.backgroundAlternative;
Color _backgroundElevatedNormal(AppColorScheme scheme) =>
    scheme.backgroundElevatedNormal;
Color _backgroundElevatedAlternative(AppColorScheme scheme) =>
    scheme.backgroundElevatedAlternative;
Color _overlayInactive(AppColorScheme scheme) => scheme.overlayInactive;
Color _overlayPressed(AppColorScheme scheme) => scheme.overlayPressed;
Color _overlayDisabled(AppColorScheme scheme) => scheme.overlayDisabled;
Color _overlayLoading(AppColorScheme scheme) => scheme.overlayLoading;
Color _interactionInactive(AppColorScheme scheme) => scheme.interactionInactive;
Color _interactionDisable(AppColorScheme scheme) => scheme.interactionDisable;
Color _scrimNormal(AppColorScheme scheme) => scheme.scrimNormal;
Color _scrimStrong(AppColorScheme scheme) => scheme.scrimStrong;
Color _textStrong(AppColorScheme scheme) => scheme.textStrong;
Color _textNormal(AppColorScheme scheme) => scheme.textNormal;
Color _textNeutral(AppColorScheme scheme) => scheme.textNeutral;
Color _textAlternative(AppColorScheme scheme) => scheme.textAlternative;
Color _textAssistive(AppColorScheme scheme) => scheme.textAssistive;
Color _textDisable(AppColorScheme scheme) => scheme.textDisable;
Color _strokeStructuralBorder(AppColorScheme scheme) =>
    scheme.strokeStructuralBorder;
Color _strokeStructuralDivider(AppColorScheme scheme) =>
    scheme.strokeStructuralDivider;
Color _strokeNormal(AppColorScheme scheme) => scheme.strokeNormal;
Color _strokeNeutral(AppColorScheme scheme) => scheme.strokeNeutral;
Color _strokeAlternative(AppColorScheme scheme) => scheme.strokeAlternative;
Color _strokeSolidNormal(AppColorScheme scheme) => scheme.strokeSolidNormal;
Color _strokeSolidNeutral(AppColorScheme scheme) => scheme.strokeSolidNeutral;
Color _strokeSolidAlternative(AppColorScheme scheme) =>
    scheme.strokeSolidAlternative;
Color _statusPositive(AppColorScheme scheme) => scheme.statusPositive;
Color _statusCautionary(AppColorScheme scheme) => scheme.statusCautionary;
Color _statusNegative(AppColorScheme scheme) => scheme.statusNegative;
Color _elevationShadowNormal(AppColorScheme scheme) =>
    scheme.elevationShadowNormal;
Color _elevationShadowEmphasize(AppColorScheme scheme) =>
    scheme.elevationShadowEmphasize;
Color _elevationShadowStrong(AppColorScheme scheme) =>
    scheme.elevationShadowStrong;
Color _elevationShadowHeavy(AppColorScheme scheme) =>
    scheme.elevationShadowHeavy;
Color _componentFillNormal(AppColorScheme scheme) => scheme.componentFillNormal;
Color _componentFillStrong(AppColorScheme scheme) => scheme.componentFillStrong;
Color _componentFillAlternative(AppColorScheme scheme) =>
    scheme.componentFillAlternative;
Color _componentPrimaryFilledButtonEnabled(AppColorScheme scheme) =>
    scheme.componentPrimaryFilledButtonEnabled;
Color _componentPrimaryFilledButtonInactive(AppColorScheme scheme) =>
    scheme.componentPrimaryFilledButtonInactive;
Color _componentPrimaryFilledButtonDisabled(AppColorScheme scheme) =>
    scheme.componentPrimaryFilledButtonDisabled;
Color _componentSecondaryFilledButtonEnabled(AppColorScheme scheme) =>
    scheme.componentSecondaryFilledButtonEnabled;
Color _componentSecondaryFilledButtonInactive(AppColorScheme scheme) =>
    scheme.componentSecondaryFilledButtonInactive;
Color _componentSecondaryFilledButtonDisabled(AppColorScheme scheme) =>
    scheme.componentSecondaryFilledButtonDisabled;
Color _componentPrimaryOutlinedButtonEnabled(AppColorScheme scheme) =>
    scheme.componentPrimaryOutlinedButtonEnabled;
Color _componentPrimaryOutlinedButtonInactive(AppColorScheme scheme) =>
    scheme.componentPrimaryOutlinedButtonInactive;
Color _componentPrimaryOutlinedButtonDisabled(AppColorScheme scheme) =>
    scheme.componentPrimaryOutlinedButtonDisabled;
Color _componentSecondaryOutlinedButtonEnabled(AppColorScheme scheme) =>
    scheme.componentSecondaryOutlinedButtonEnabled;
Color _componentSecondaryOutlinedButtonInactive(AppColorScheme scheme) =>
    scheme.componentSecondaryOutlinedButtonInactive;
Color _componentSecondaryOutlinedButtonDisabled(AppColorScheme scheme) =>
    scheme.componentSecondaryOutlinedButtonDisabled;
Color _componentAssistiveOutlinedButtonEnabled(AppColorScheme scheme) =>
    scheme.componentAssistiveOutlinedButtonEnabled;
Color _componentAssistiveOutlinedButtonDisabled(AppColorScheme scheme) =>
    scheme.componentAssistiveOutlinedButtonDisabled;
Color _componentPrimaryTextButtonEnabled(AppColorScheme scheme) =>
    scheme.componentPrimaryTextButtonEnabled;
Color _componentPrimaryTextButtonDisabled(AppColorScheme scheme) =>
    scheme.componentPrimaryTextButtonDisabled;
Color _componentSecondaryTextButtonEnabled(AppColorScheme scheme) =>
    scheme.componentSecondaryTextButtonEnabled;
Color _componentSecondaryTextButtonDisabled(AppColorScheme scheme) =>
    scheme.componentSecondaryTextButtonDisabled;
Color _componentAssistiveTextButtonEnabled(AppColorScheme scheme) =>
    scheme.componentAssistiveTextButtonEnabled;
Color _componentAssistiveTextButtonDisabled(AppColorScheme scheme) =>
    scheme.componentAssistiveTextButtonDisabled;
Color _componentFloatingActionButtonNormal(AppColorScheme scheme) =>
    scheme.componentFloatingActionButtonNormal;
Color _componentFloatingActionButtonStrong(AppColorScheme scheme) =>
    scheme.componentFloatingActionButtonStrong;
Color _componentCheckboxIconEnabled(AppColorScheme scheme) =>
    scheme.componentCheckboxIconEnabled;
Color _componentCheckboxIconDisabled(AppColorScheme scheme) =>
    scheme.componentCheckboxIconDisabled;
Color _componentBottomSheetHandle(AppColorScheme scheme) =>
    scheme.componentBottomSheetHandle;
Color _componentInfoCardBackground(AppColorScheme scheme) =>
    scheme.componentInfoCardBackground;

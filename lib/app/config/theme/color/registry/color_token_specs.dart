// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/color/contracts/app_color_scheme.dart';
import 'package:wingle/app/config/theme/color/registry/enum_title.dart';

typedef AppColorTokenResolver = Color Function(AppColorScheme scheme);

/// 시맨틱 컬러 섹션.
enum AppColorSemanticSection {
  staticColors,
  primarySecondary,
  backgroundOverlayScrim,
  interactionTextStroke,
  statusElevation,
  components,
}

/// 시맨틱 컬러 토큰.
enum AppColorTokenSpec {
  staticWhite(AppColorSemanticSection.staticColors, _staticWhite),
  staticBlack(AppColorSemanticSection.staticColors, _staticBlack),
  primaryNormal(AppColorSemanticSection.primarySecondary, _primaryNormal),
  primaryStrong(AppColorSemanticSection.primarySecondary, _primaryStrong),
  primaryHeavy(AppColorSemanticSection.primarySecondary, _primaryHeavy),
  onPrimaryNormal(AppColorSemanticSection.primarySecondary, _onPrimaryNormal),
  secondaryNormal(AppColorSemanticSection.primarySecondary, _secondaryNormal),
  secondaryStrong(AppColorSemanticSection.primarySecondary, _secondaryStrong),
  secondaryHeavy(AppColorSemanticSection.primarySecondary, _secondaryHeavy),
  onSecondaryNormal(
    AppColorSemanticSection.primarySecondary,
    _onSecondaryNormal,
  ),
  backgroundNormal(
    AppColorSemanticSection.backgroundOverlayScrim,
    _backgroundNormal,
  ),
  backgroundAlternative(
    AppColorSemanticSection.backgroundOverlayScrim,
    _backgroundAlternative,
  ),
  backgroundElevatedNormal(
    AppColorSemanticSection.backgroundOverlayScrim,
    _backgroundElevatedNormal,
  ),
  backgroundElevatedAlternative(
    AppColorSemanticSection.backgroundOverlayScrim,
    _backgroundElevatedAlternative,
  ),
  overlayInactive(
    AppColorSemanticSection.backgroundOverlayScrim,
    _overlayInactive,
  ),
  overlayPressed(
    AppColorSemanticSection.backgroundOverlayScrim,
    _overlayPressed,
  ),
  overlayDisabled(
    AppColorSemanticSection.backgroundOverlayScrim,
    _overlayDisabled,
  ),
  overlayLoading(
    AppColorSemanticSection.backgroundOverlayScrim,
    _overlayLoading,
  ),
  scrimNormal(AppColorSemanticSection.backgroundOverlayScrim, _scrimNormal),
  scrimStrong(AppColorSemanticSection.backgroundOverlayScrim, _scrimStrong),
  interactionInactive(
    AppColorSemanticSection.interactionTextStroke,
    _interactionInactive,
  ),
  interactionDisable(
    AppColorSemanticSection.interactionTextStroke,
    _interactionDisable,
  ),
  textStrong(AppColorSemanticSection.interactionTextStroke, _textStrong),
  textNormal(AppColorSemanticSection.interactionTextStroke, _textNormal),
  textNeutral(AppColorSemanticSection.interactionTextStroke, _textNeutral),
  textAlternative(
    AppColorSemanticSection.interactionTextStroke,
    _textAlternative,
  ),
  textAssistive(AppColorSemanticSection.interactionTextStroke, _textAssistive),
  textDisable(AppColorSemanticSection.interactionTextStroke, _textDisable),
  strokeStructuralBorder(
    AppColorSemanticSection.interactionTextStroke,
    _strokeStructuralBorder,
  ),
  strokeStructuralDivider(
    AppColorSemanticSection.interactionTextStroke,
    _strokeStructuralDivider,
  ),
  strokeNormal(AppColorSemanticSection.interactionTextStroke, _strokeNormal),
  strokeNeutral(AppColorSemanticSection.interactionTextStroke, _strokeNeutral),
  strokeAlternative(
    AppColorSemanticSection.interactionTextStroke,
    _strokeAlternative,
  ),
  strokeSolidNormal(
    AppColorSemanticSection.interactionTextStroke,
    _strokeSolidNormal,
  ),
  strokeSolidNeutral(
    AppColorSemanticSection.interactionTextStroke,
    _strokeSolidNeutral,
  ),
  strokeSolidAlternative(
    AppColorSemanticSection.interactionTextStroke,
    _strokeSolidAlternative,
  ),
  statusPositive(AppColorSemanticSection.statusElevation, _statusPositive),
  statusCautionary(AppColorSemanticSection.statusElevation, _statusCautionary),
  statusNegative(AppColorSemanticSection.statusElevation, _statusNegative),
  elevationShadowNormal(
    AppColorSemanticSection.statusElevation,
    _elevationShadowNormal,
  ),
  elevationShadowEmphasize(
    AppColorSemanticSection.statusElevation,
    _elevationShadowEmphasize,
  ),
  elevationShadowStrong(
    AppColorSemanticSection.statusElevation,
    _elevationShadowStrong,
  ),
  elevationShadowHeavy(
    AppColorSemanticSection.statusElevation,
    _elevationShadowHeavy,
  ),
  componentFillNormal(AppColorSemanticSection.components, _componentFillNormal),
  componentFillStrong(AppColorSemanticSection.components, _componentFillStrong),
  componentFillAlternative(
    AppColorSemanticSection.components,
    _componentFillAlternative,
  ),
  componentPrimaryFilledButtonEnabled(
    AppColorSemanticSection.components,
    _componentPrimaryFilledButtonEnabled,
  ),
  componentPrimaryFilledButtonInactive(
    AppColorSemanticSection.components,
    _componentPrimaryFilledButtonInactive,
  ),
  componentPrimaryFilledButtonDisabled(
    AppColorSemanticSection.components,
    _componentPrimaryFilledButtonDisabled,
  ),
  componentSecondaryFilledButtonEnabled(
    AppColorSemanticSection.components,
    _componentSecondaryFilledButtonEnabled,
  ),
  componentSecondaryFilledButtonInactive(
    AppColorSemanticSection.components,
    _componentSecondaryFilledButtonInactive,
  ),
  componentSecondaryFilledButtonDisabled(
    AppColorSemanticSection.components,
    _componentSecondaryFilledButtonDisabled,
  ),
  componentTertiaryFilledButtonEnabled(
    AppColorSemanticSection.components,
    _componentTertiaryFilledButtonEnabled,
  ),
  componentTertiaryFilledButtonInactive(
    AppColorSemanticSection.components,
    _componentTertiaryFilledButtonInactive,
  ),
  componentTertiaryFilledButtonDisabled(
    AppColorSemanticSection.components,
    _componentTertiaryFilledButtonDisabled,
  ),
  componentPrimaryOutlinedButtonEnabled(
    AppColorSemanticSection.components,
    _componentPrimaryOutlinedButtonEnabled,
  ),
  componentPrimaryOutlinedButtonInactive(
    AppColorSemanticSection.components,
    _componentPrimaryOutlinedButtonInactive,
  ),
  componentPrimaryOutlinedButtonDisabled(
    AppColorSemanticSection.components,
    _componentPrimaryOutlinedButtonDisabled,
  ),
  componentSecondaryOutlinedButtonEnabled(
    AppColorSemanticSection.components,
    _componentSecondaryOutlinedButtonEnabled,
  ),
  componentSecondaryOutlinedButtonInactive(
    AppColorSemanticSection.components,
    _componentSecondaryOutlinedButtonInactive,
  ),
  componentSecondaryOutlinedButtonDisabled(
    AppColorSemanticSection.components,
    _componentSecondaryOutlinedButtonDisabled,
  ),
  componentAssistiveOutlinedButtonEnabled(
    AppColorSemanticSection.components,
    _componentAssistiveOutlinedButtonEnabled,
  ),
  componentAssistiveOutlinedButtonDisabled(
    AppColorSemanticSection.components,
    _componentAssistiveOutlinedButtonDisabled,
  ),
  componentPrimaryTextButtonEnabled(
    AppColorSemanticSection.components,
    _componentPrimaryTextButtonEnabled,
  ),
  componentPrimaryTextButtonDisabled(
    AppColorSemanticSection.components,
    _componentPrimaryTextButtonDisabled,
  ),
  componentSecondaryTextButtonEnabled(
    AppColorSemanticSection.components,
    _componentSecondaryTextButtonEnabled,
  ),
  componentSecondaryTextButtonDisabled(
    AppColorSemanticSection.components,
    _componentSecondaryTextButtonDisabled,
  ),
  componentAssistiveTextButtonEnabled(
    AppColorSemanticSection.components,
    _componentAssistiveTextButtonEnabled,
  ),
  componentAssistiveTextButtonDisabled(
    AppColorSemanticSection.components,
    _componentAssistiveTextButtonDisabled,
  ),
  componentFloatingActionButtonNormal(
    AppColorSemanticSection.components,
    _componentFloatingActionButtonNormal,
  ),
  componentFloatingActionButtonStrong(
    AppColorSemanticSection.components,
    _componentFloatingActionButtonStrong,
  ),
  componentCheckboxIconEnabled(
    AppColorSemanticSection.components,
    _componentCheckboxIconEnabled,
  ),
  componentCheckboxIconDisabled(
    AppColorSemanticSection.components,
    _componentCheckboxIconDisabled,
  ),
  componentBottomSheetHandle(
    AppColorSemanticSection.components,
    _componentBottomSheetHandle,
  ),
  componentInfoCardBackground(
    AppColorSemanticSection.components,
    _componentInfoCardBackground,
  ),
  componentBadgePrimaryBackground(
    AppColorSemanticSection.components,
    _componentBadgePrimaryBackground,
  ),
  componentBadgePrimaryForeground(
    AppColorSemanticSection.components,
    _componentBadgePrimaryForeground,
  ),
  componentBadgeSecondaryBackground(
    AppColorSemanticSection.components,
    _componentBadgeSecondaryBackground,
  ),
  componentBadgeSecondaryForeground(
    AppColorSemanticSection.components,
    _componentBadgeSecondaryForeground,
  ),
  componentBadgeTertiaryBackground(
    AppColorSemanticSection.components,
    _componentBadgeTertiaryBackground,
  ),
  componentBadgeTertiaryForeground(
    AppColorSemanticSection.components,
    _componentBadgeTertiaryForeground,
  ),
  componentBadgeGrayBackground(
    AppColorSemanticSection.components,
    _componentBadgeGrayBackground,
  ),
  componentBadgeGrayForeground(
    AppColorSemanticSection.components,
    _componentBadgeGrayForeground,
  );

  final AppColorSemanticSection section;
  final AppColorTokenResolver resolve;

  const AppColorTokenSpec(this.section, this.resolve);

  /// 표시용 제목.
  String get title => name.title;
}

extension AppColorSemanticSectionTitle on AppColorSemanticSection {
  /// 표시용 제목.
  String get title => name.title;
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
Color _componentTertiaryFilledButtonEnabled(AppColorScheme scheme) =>
    scheme.componentTertiaryFilledButtonEnabled;
Color _componentTertiaryFilledButtonInactive(AppColorScheme scheme) =>
    scheme.componentTertiaryFilledButtonInactive;
Color _componentTertiaryFilledButtonDisabled(AppColorScheme scheme) =>
    scheme.componentTertiaryFilledButtonDisabled;
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
Color _componentBadgePrimaryBackground(AppColorScheme scheme) =>
    scheme.componentBadgePrimaryBackground;
Color _componentBadgePrimaryForeground(AppColorScheme scheme) =>
    scheme.componentBadgePrimaryForeground;
Color _componentBadgeSecondaryBackground(AppColorScheme scheme) =>
    scheme.componentBadgeSecondaryBackground;
Color _componentBadgeSecondaryForeground(AppColorScheme scheme) =>
    scheme.componentBadgeSecondaryForeground;
Color _componentBadgeTertiaryBackground(AppColorScheme scheme) =>
    scheme.componentBadgeTertiaryBackground;
Color _componentBadgeTertiaryForeground(AppColorScheme scheme) =>
    scheme.componentBadgeTertiaryForeground;
Color _componentBadgeGrayBackground(AppColorScheme scheme) =>
    scheme.componentBadgeGrayBackground;
Color _componentBadgeGrayForeground(AppColorScheme scheme) =>
    scheme.componentBadgeGrayForeground;

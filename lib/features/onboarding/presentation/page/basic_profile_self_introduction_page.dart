import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/color/contracts/app_color_scheme.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/icons/default_icon.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/constants/component_tokens.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/presentation/models/profile_details_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_details_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_route_chain.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 상세 프로필 자기소개 입력 페이지.
class BasicProfileSelfIntroductionPage extends ConsumerStatefulWidget {
  /// 생성자.
  const BasicProfileSelfIntroductionPage({super.key});

  @override
  ConsumerState<BasicProfileSelfIntroductionPage> createState() =>
      _BasicProfileSelfIntroductionPageState();
}

class _BasicProfileSelfIntroductionPageState
    extends ConsumerState<BasicProfileSelfIntroductionPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(profileDetailsProvider).selfIntroduction,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileDetailsProvider);
    final notifier = ref.read(profileDetailsProvider.notifier);

    void navigatePrevious() {
      OnboardingRouteChain.goPrevious(
        context,
        OnboardingRouteFlow.profileInput,
        OnboardingRoutes.profileSelfIntroduction,
      );
    }

    return ConstrainedScrollableScaffold(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        navigatePrevious();
      },
      textScalePolicy: TextScalePolicy.cappedLarge,
      padding: EdgeInsets.zero,
      appBar: DefaultAppBar(
        title: 'onboarding.basicProfile.selfIntroduction.appBarTitle',
        forceImplyLeading: true,
        onBackPressed: navigatePrevious,
      ),
      floatingActionButton: DefaultFloatingButton(
        label: 'common.button.next',
        isLoading: state.isSubmitting,
        disabled: state.isSubmitting || !state.canContinueSelfIntroduction,
        onPressed: () async {
          final saved = await notifier.saveSelfIntroduction();
          if (!context.mounted) return;

          if (!saved) {
            DefaultToast.show(
              context,
              ref.read(profileDetailsProvider).submitErrorMessage ??
                  ApiErrorMessages.submitProfileDetailsFailed,
            );
            return;
          }

          final submitted = await notifier.submitProfileDetails();
          if (!context.mounted) return;

          if (!submitted) {
            DefaultToast.show(
              context,
              ref.read(profileDetailsProvider).submitErrorMessage ??
                  ApiErrorMessages.submitProfileDetailsFailed,
            );
            return;
          }

          final requested = await notifier.requestProfileApproval();
          if (!context.mounted) return;

          if (!requested) {
            DefaultToast.show(
              context,
              ref.read(profileDetailsProvider).submitErrorMessage ??
                  ApiErrorMessages.requestProfileApprovalFailed,
            );
            return;
          }

          context.goNamed(OnboardingRoutes.approvalPending.name);
        },
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultPageHeader(
              title: 'onboarding.basicProfile.selfIntroduction.title',
              subtitle: 'onboarding.basicProfile.selfIntroduction.subtitle',
              titleStyle: context.typography.title,
              subtitleStyle: context.typography.bodySub,
              subtitleColor: context.colors.textAlternative,
              padding: const EdgeInsets.only(
                top: AppSpacing.s40,
                bottom: AppSpacing.s64,
              ),
            ),
            _SelfIntroductionInput(
              controller: _controller,
              state: state,
              onChanged: notifier.updateSelfIntroduction,
            ),
            const SizedBox(height: AppSpacing.s64),
            const _SelfIntroductionGuideButton(),
            const SizedBox(height: AppSpacing.bottom),
          ],
        ),
      ),
    );
  }
}

class _SelfIntroductionInput extends StatelessWidget {
  static const int _fieldMinLines = 4;
  static const double _qualityWidth = 64;
  static const double _counterWidth = 96;

  final TextEditingController controller;
  final ProfileDetailsModel state;
  final ValueChanged<String> onChanged;

  const _SelfIntroductionInput({
    required this.controller,
    required this.state,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'onboarding.basicProfile.selfIntroduction.label'.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: typography.body.copyWith(color: colors.textAlternative),
              ),
            ),
            SizedBox(
              width: _qualityWidth,
              child: Text(
                _qualityLabelKey(state.selfIntroductionQuality).tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: typography.body.copyWith(
                  color: _qualityColor(colors, state.selfIntroductionQuality),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            SizedBox(
              width: _counterWidth,
              child: Text(
                _counterText(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: typography.body.copyWith(color: colors.textAlternative),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        TextFormField(
          controller: controller,
          inputFormatters: [
            LengthLimitingTextInputFormatter(
              ProfileDetailsModel.selfIntroductionMaxLength,
            ),
          ],
          keyboardType: TextInputType.multiline,
          minLines: _fieldMinLines,
          maxLines: null,
          textAlignVertical: TextAlignVertical.top,
          onChanged: onChanged,
          cursorColor: colors.primaryNormal,
          cursorErrorColor: colors.statusNegative,
          cursorWidth: AppLineWidth.inputFieldCursor,
          style: typography.body.copyWith(color: colors.textNormal),
          decoration: InputDecoration(
            hintText: 'onboarding.basicProfile.selfIntroduction.hint'.tr(),
            hintStyle: typography.body.copyWith(color: colors.textAssistive),
            filled: true,
            fillColor: colors.backgroundNormal,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppComponentPadding.inputHorizontal,
              vertical: AppComponentPadding.inputVertical,
            ),
            enabledBorder: _border(colors.strokeStructuralBorder),
            focusedBorder: _border(colors.strokeStructuralBorder),
            border: _border(colors.strokeStructuralBorder),
          ),
        ),
      ],
    );
  }

  String _qualityLabelKey(SelfIntroductionQuality quality) {
    return switch (quality) {
      SelfIntroductionQuality.empty =>
        'onboarding.basicProfile.selfIntroduction.quality.empty',
      SelfIntroductionQuality.short =>
        'onboarding.basicProfile.selfIntroduction.quality.short',
      SelfIntroductionQuality.normal =>
        'onboarding.basicProfile.selfIntroduction.quality.normal',
      SelfIntroductionQuality.appropriate =>
        'onboarding.basicProfile.selfIntroduction.quality.appropriate',
    };
  }

  Color _qualityColor(AppColorScheme colors, SelfIntroductionQuality quality) {
    return switch (quality) {
      SelfIntroductionQuality.empty => colors.textAssistive,
      SelfIntroductionQuality.short => colors.statusCautionary,
      SelfIntroductionQuality.normal => colors.textAlternative,
      SelfIntroductionQuality.appropriate => colors.statusPositive,
    };
  }

  String _counterText(BuildContext context) {
    final suffix = context.locale.languageCode == 'en' ? ' chars' : '자';
    return '${state.selfIntroductionLength}/'
        '${ProfileDetailsModel.selfIntroductionMaxLength}$suffix';
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppComponentRadius.input),
      borderSide: BorderSide(
        color: color,
        width: AppLineWidth.inputFieldOutline,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
    );
  }
}

class _SelfIntroductionGuideButton extends StatelessWidget {
  const _SelfIntroductionGuideButton();

  static const double _width =
      AppContainerSize.profilePhotoGuideButtonWidth + 20;
  static const double _height = AppContainerSize.buttonChipHeight;
  static const double _iconSize = AppIconSize.xs;
  static const double _horizontalPadding = AppPadding.buttonChipHorizontal;
  static const double _labelIconGap = AppSpacing.s6;
  static const double _labelMaxWidth =
      _width - (_horizontalPadding * 2) - _labelIconGap - _iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return SizedBox(
      width: _width,
      height: _height,
      child: Material(
        color: colors.secondaryNormal,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return colors.overlayPressed;
            }

            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return colors.overlayInactive;
            }

            return null;
          }),
          onTap: () {
            DefaultToast.show(
              context,
              'onboarding.basicProfile.selfIntroduction.guideUnavailable',
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _horizontalPadding,
              vertical: AppPadding.buttonSmallVertical,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _labelMaxWidth),
                  child: Text(
                    'onboarding.basicProfile.selfIntroduction.guide'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typography.buttonSmall.copyWith(
                      color: colors.onSecondaryNormal,
                    ),
                  ),
                ),
                const SizedBox(width: _labelIconGap),
                DefaultIcon(
                  icon: Icons.chevron_right_rounded,
                  size: _iconSize,
                  color: colors.onSecondaryNormal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

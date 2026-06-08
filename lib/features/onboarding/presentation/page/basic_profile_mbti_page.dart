import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/basic_profile_input_scaffold.dart';
import 'package:wingle/features/onboarding/presentation/constants/basic_profile_input_constants.dart';
import 'package:wingle/features/onboarding/presentation/models/profile_details_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_details_provider.dart';
import 'package:wingle/features/onboarding/presentation/utils/onboarding_rejection_edit_mode.dart';
import 'package:wingle/features/onboarding/route/onboarding_route_chain.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 기본 프로필 입력의 MBTI 선택 페이지.
class BasicProfileMbtiPage extends ConsumerWidget {
  /// 생성자.
  const BasicProfileMbtiPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileDetailsProvider);
    final notifier = ref.read(profileDetailsProvider.notifier);
    final isRejectionEditMode = isOnboardingRejectionEditMode(context);

    void navigatePrevious() {
      goRejectedReviewOrPrevious(
        context,
        OnboardingRouteFlow.profileInput,
        OnboardingRoutes.profileDetails,
      );
    }

    return BasicProfileInputScaffold(
      currentStep: BasicProfileInputConstants.profileDetailsStep,
      totalSteps: BasicProfileInputConstants.totalSteps,
      title: 'onboarding.basicProfile.profileDetails.mbtiTitle',
      subtitle: null,
      buttonLabel: isRejectionEditMode
          ? 'common.button.saveEdit'
          : 'common.button.next',
      isLoading: state.isSubmitting,
      disabled: state.isSubmitting || !state.canContinueMbti,
      canPop: false,
      forceBackButton: true,
      onBackPressed: navigatePrevious,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        navigatePrevious();
      },
      onPressed: () async {
        final success = await notifier.saveMbti();
        if (!context.mounted) return;

        if (!success) {
          DefaultToast.show(
            context,
            ref.read(profileDetailsProvider).submitErrorMessage ??
                ApiErrorMessages.submitProfileDetailsFailed,
          );
          return;
        }

        if (isRejectionEditMode) {
          final submitted = await notifier.submitProfileDetails(
            forceUpdate: true,
          );
          if (!context.mounted) return;

          if (!submitted) {
            DefaultToast.show(
              context,
              ref.read(profileDetailsProvider).submitErrorMessage ??
                  ApiErrorMessages.submitProfileDetailsFailed,
            );
            return;
          }

          goRejectedReviewOrNamed(
            context,
            OnboardingRoutes.profileRejected.name,
          );
          return;
        }

        final next = OnboardingRouteChain.nextOf(
          OnboardingRouteFlow.profileInput,
          OnboardingRoutes.profileDetails,
        );
        if (next == null) return;

        goRejectedReviewOrNamed(context, next.name);
      },
      child: _MbtiSelectionGrid(
        state: state,
        onSelected: notifier.selectMbtiLetter,
      ),
    );
  }
}

class _MbtiSelectionGrid extends StatelessWidget {
  final ProfileDetailsModel state;
  final ValueChanged<String> onSelected;

  const _MbtiSelectionGrid({required this.state, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.s44),
        _MbtiOptionRow(
          left: 'E',
          right: 'I',
          selected: state.energy,
          onSelected: onSelected,
        ),
        const SizedBox(height: AppSpacing.s16),
        _MbtiOptionRow(
          left: 'N',
          right: 'S',
          selected: state.perception,
          onSelected: onSelected,
        ),
        const SizedBox(height: AppSpacing.s16),
        _MbtiOptionRow(
          left: 'F',
          right: 'T',
          selected: state.decision,
          onSelected: onSelected,
        ),
        const SizedBox(height: AppSpacing.s16),
        _MbtiOptionRow(
          left: 'P',
          right: 'J',
          selected: state.lifestyle,
          onSelected: onSelected,
        ),
      ],
    );
  }
}

class _MbtiOptionRow extends StatelessWidget {
  final String left;
  final String right;
  final String? selected;
  final ValueChanged<String> onSelected;

  const _MbtiOptionRow({
    required this.left,
    required this.right,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MbtiOptionTile(
            label: left,
            selected: selected == left,
            onTap: () => onSelected(left),
          ),
        ),
        const SizedBox(width: AppSpacing.s20),
        Expanded(
          child: _MbtiOptionTile(
            label: right,
            selected: selected == right,
            onTap: () => onSelected(right),
          ),
        ),
      ],
    );
  }
}

class _MbtiOptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MbtiOptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final backgroundColor = selected
        ? colors.componentSecondaryFilledButtonEnabled
        : colors.componentSelectionButtonBackground;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(AppRadius.iosStyle),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.iosStyle),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppContainerSize.large),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.selectionButtonHorizontal,
              vertical: AppPadding.selectionButtonVertical,
            ),
            child: Center(
              child: DefaultText(
                label,
                isTranslationKey: false,
                style: typography.buttonMedium.copyWith(
                  color: selected ? colors.textNormal : colors.textAlternative,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

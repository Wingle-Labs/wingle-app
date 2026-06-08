import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/icons/default_icon.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/basic_profile_input_scaffold.dart';
import 'package:wingle/features/onboarding/presentation/constants/basic_profile_input_constants.dart';
import 'package:wingle/features/onboarding/presentation/providers/job_codebook_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/job_profile_provider.dart';
import 'package:wingle/features/onboarding/presentation/utils/onboarding_rejection_edit_mode.dart';
import 'package:wingle/features/onboarding/route/onboarding_route_chain.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 직종 선택 페이지.
class BasicProfileOccupationPage extends ConsumerStatefulWidget {
  /// 생성자.
  const BasicProfileOccupationPage({super.key});

  @override
  ConsumerState<BasicProfileOccupationPage> createState() =>
      _BasicProfileOccupationPageState();
}

class _BasicProfileOccupationPageState
    extends ConsumerState<BasicProfileOccupationPage> {
  JobCodebookNode? _selectedRoot;

  @override
  Widget build(BuildContext context) {
    final tree = ref.watch(jobCodebookTreeProvider);
    final jobState = ref.watch(jobProfileProvider);
    final options = _selectedRoot == null
        ? tree.roots
        : tree.childrenOf(_selectedRoot!.code);

    void navigateBack() {
      if (_selectedRoot != null) {
        setState(() => _selectedRoot = null);
        return;
      }
      goRejectedReviewOrPrevious(
        context,
        OnboardingRouteFlow.profileInput,
        OnboardingRoutes.basicProfileCompany,
      );
    }

    return BasicProfileInputScaffold(
      currentStep: BasicProfileInputConstants.companyStep,
      totalSteps: BasicProfileInputConstants.totalSteps,
      title: _selectedRoot == null
          ? 'onboarding.basicProfile.occupation.title'
          : 'onboarding.basicProfile.occupation.detailTitle',
      subtitle: null,
      buttonLabel: 'common.button.next',
      showFloatingButton: false,
      canPop: false,
      forceBackButton: true,
      onBackPressed: navigateBack,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        navigateBack();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.selectionButtonGap,
        children: [
          for (final option in options)
            _OccupationTile(
              label: option.codeName,
              isLoading:
                  jobState.isSubmitting &&
                  option.code == jobState.occupationCode,
              showChevron: option.children.isNotEmpty,
              onTap: jobState.isSubmitting
                  ? null
                  : () => _handleSelected(context, option),
            ),
        ],
      ),
    );
  }

  Future<void> _handleSelected(
    BuildContext context,
    JobCodebookNode option,
  ) async {
    if (option.children.isNotEmpty) {
      setState(() => _selectedRoot = option);
      return;
    }

    final notifier = ref.read(jobProfileProvider.notifier);
    notifier.selectOccupation(code: option.code, name: option.codeName);

    final nextState = ref.read(jobProfileProvider);
    if (nextState.requiresCompany) {
      context.pushNamed(OnboardingRoutes.basicProfileCompanyName.name);
      return;
    }

    final success = await notifier.submit();
    if (!context.mounted) return;

    if (success) {
      goRejectedReviewOrPushNamed(
        context,
        OnboardingRoutes.basicProfileEducation.name,
      );
    } else {
      DefaultToast.show(
        context,
        ref.read(jobProfileProvider).submitErrorMessage ??
            ApiErrorMessages.submitJobFailed,
      );
    }
  }
}

class _OccupationTile extends StatelessWidget {
  final String label;
  final bool isLoading;
  final bool showChevron;
  final VoidCallback? onTap;

  const _OccupationTile({
    required this.label,
    required this.isLoading,
    required this.showChevron,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Material(
      color: colors.componentSelectionButtonBackground,
      borderRadius: BorderRadius.circular(AppRadius.iosStyle),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.iosStyle),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppContainerSize.selectionButtonHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.selectionButtonHorizontal,
              vertical: AppPadding.selectionButtonVertical,
            ),
            child: Row(
              children: [
                Expanded(
                  child: DefaultText(
                    label,
                    style: typography.buttonMedium.copyWith(
                      color: colors.componentSelectionButtonForeground,
                    ),
                    isTranslationKey: false,
                  ),
                ),
                if (isLoading)
                  SizedBox.square(
                    dimension: AppIconSize.sm,
                    child: CircularProgressIndicator(
                      strokeWidth: AppLineWidth.outline,
                      color: colors.primaryNormal,
                    ),
                  )
                else if (showChevron)
                  DefaultIcon(
                    icon: Icons.chevron_right_rounded,
                    size: AppIconSize.md,
                    color: colors.componentSelectionButtonForeground,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

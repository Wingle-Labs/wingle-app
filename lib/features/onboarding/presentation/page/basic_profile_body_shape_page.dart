import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/providers/current_user_gender_provider.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/features/onboarding/presentation/components/selection/basic_profile_body_shape_option_list.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/basic_profile_input_scaffold.dart';
import 'package:wingle/features/onboarding/presentation/constants/basic_profile_input_constants.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/body_shape_repository_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_route_chain.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 기본 프로필 입력의 체형 선택 페이지.
class BasicProfileBodyShapePage extends ConsumerWidget {
  /// 생성자
  const BasicProfileBodyShapePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(basicProfileProvider);
    final notifier = ref.read(basicProfileProvider.notifier);
    final codebook = ref.watch(bodyShapeCodebookProvider);
    final gender = ref.watch(currentUserGenderProvider);
    final options = codebook.optionsForGender(gender);
    final selectedCode = state.bodyShapeCode;
    final canContinue =
        state.canContinueBodyShape &&
        options.any((option) => option.code == selectedCode);
    void navigateToPreviousBasicProfileStep() {
      OnboardingRouteChain.goPrevious(
        context,
        OnboardingRouteFlow.profileInput,
        OnboardingRoutes.basicProfileBodyShape,
      );
    }

    return BasicProfileInputScaffold(
      currentStep: BasicProfileInputConstants.bodyShapeStep,
      totalSteps: BasicProfileInputConstants.totalSteps,
      title: 'onboarding.basicProfile.bodyShape.title',
      subtitle: null,
      buttonLabel: 'common.button.next',
      isLoading: state.isSubmitting,
      disabled: state.isSubmitting || !canContinue,
      canPop: false,
      forceBackButton: true,
      onBackPressed: navigateToPreviousBasicProfileStep,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        navigateToPreviousBasicProfileStep();
      },
      onPressed: () async {
        final success = await notifier.submit();
        if (!context.mounted) return;

        if (success) {
          context.pushNamed(OnboardingRoutes.basicProfileCompany.name);
        } else {
          DefaultToast.show(
            context,
            ref.read(basicProfileProvider).submitErrorMessage ??
                ApiErrorMessages.submitBasicProfileFailed,
          );
        }
      },
      child: BasicProfileBodyShapeOptionList(
        options: options,
        selectedCode: selectedCode,
        onSelected: notifier.selectBodyShape,
      ),
    );
  }
}

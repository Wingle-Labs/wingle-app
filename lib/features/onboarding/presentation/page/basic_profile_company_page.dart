import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/icons/default_icon.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_input_field.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/basic_profile_input_scaffold.dart';
import 'package:wingle/features/onboarding/presentation/constants/basic_profile_input_constants.dart';
import 'package:wingle/features/onboarding/presentation/providers/job_profile_provider.dart';
import 'package:wingle/features/onboarding/presentation/utils/onboarding_rejection_edit_mode.dart';
import 'package:wingle/features/onboarding/route/onboarding_route_chain.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 기본 프로필 입력의 회사명 입력 페이지.
class BasicProfileCompanyPage extends ConsumerStatefulWidget {
  /// 생성자.
  const BasicProfileCompanyPage({super.key});

  @override
  ConsumerState<BasicProfileCompanyPage> createState() =>
      _BasicProfileCompanyPageState();
}

class _BasicProfileCompanyPageState
    extends ConsumerState<BasicProfileCompanyPage> {
  late final TextEditingController _companyController;
  late final FocusNode _companyFocusNode;

  @override
  void initState() {
    super.initState();
    final initialState = ref.read(jobProfileProvider);
    _companyController = TextEditingController(text: initialState.company);
    _companyFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _companyController.dispose();
    _companyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jobProfileProvider);
    final notifier = ref.read(jobProfileProvider.notifier);

    ref.listen(jobProfileProvider, (previous, next) {
      if (_companyFocusNode.hasFocus ||
          _companyController.text == next.company) {
        return;
      }
      _companyController.text = next.company;
    });

    void navigateToPreviousBasicProfileStep() {
      OnboardingRouteChain.goPrevious(
        context,
        OnboardingRouteFlow.profileInput,
        OnboardingRoutes.basicProfileCompanyName,
      );
    }

    return BasicProfileInputScaffold(
      currentStep: BasicProfileInputConstants.companyStep,
      totalSteps: BasicProfileInputConstants.totalSteps,
      title: 'onboarding.basicProfile.company.title',
      subtitle: 'onboarding.basicProfile.company.subtitle',
      buttonLabel: 'common.button.next',
      isLoading: state.isSubmitting,
      disabled: state.isSubmitting || !state.canContinueCompany,
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
          goRejectedReviewOrPushNamed(
            context,
            OnboardingRoutes.basicProfileCompanyEmail.name,
          );
        } else {
          DefaultToast.show(
            context,
            ref.read(jobProfileProvider).submitErrorMessage ??
                ApiErrorMessages.submitJobFailed,
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultInputField(
            hintText: 'onboarding.basicProfile.company.companyHint',
            controller: _companyController,
            focusNode: _companyFocusNode,
            prefix: DefaultIcon(
              icon: Icons.search_rounded,
              size: AppIconSize.md,
              color: context.colors.textStrong,
            ),
            onChanged: notifier.updateCompany,
            showClearButton: _companyController.text.isNotEmpty,
            onClear: () {
              _companyController.clear();
              notifier.updateCompany('');
            },
          ),
        ],
      ),
    );
  }
}

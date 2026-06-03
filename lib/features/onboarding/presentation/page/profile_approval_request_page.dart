import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_details_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 프로필 심사를 자동 요청하는 중간 페이지.
class ProfileApprovalRequestPage extends ConsumerStatefulWidget {
  /// 생성자.
  const ProfileApprovalRequestPage({super.key});

  @override
  ConsumerState<ProfileApprovalRequestPage> createState() =>
      _ProfileApprovalRequestPageState();
}

class _ProfileApprovalRequestPageState
    extends ConsumerState<ProfileApprovalRequestPage> {
  bool _didStart = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_requestApproval);
  }

  Future<void> _requestApproval() async {
    if (_didStart) return;
    _didStart = true;

    final success = await ref
        .read(profileDetailsProvider.notifier)
        .requestProfileApproval();
    if (!mounted) return;

    if (success) {
      context.goNamed(OnboardingRoutes.approvalPending.name);
      return;
    }

    DefaultToast.show(
      context,
      ref.read(profileDetailsProvider).submitErrorMessage ??
          ApiErrorMessages.requestProfileApprovalFailed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileDetailsProvider);

    return ConstrainedScrollableScaffold(
      canPop: false,
      textScalePolicy: TextScalePolicy.cappedLarge,
      floatingActionButton: DefaultFloatingButton(
        label: 'onboarding.approvalRequest.retry',
        isLoading: state.isSubmitting,
        disabled: state.isSubmitting,
        onPressed: () {
          _didStart = false;
          _requestApproval();
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.s64),
          DefaultPageHeader(
            title: 'onboarding.approvalRequest.title',
            subtitle: 'onboarding.approvalRequest.subtitle',
            subtitleColor: context.colors.textAlternative,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: AppSpacing.s64),
          const Center(child: AnimationProgressIndicator()),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/app/router/onboarding_redirect_resolver.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/common/utils/auth_session_persistence.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/presentation/providers/onboarding_profile_status_provider.dart';

/// 프로필 심사 승인 대기 안내 화면.
class ProfileApprovalPendingPage extends ConsumerStatefulWidget {
  /// 생성자.
  const ProfileApprovalPendingPage({super.key});

  @override
  ConsumerState<ProfileApprovalPendingPage> createState() =>
      _ProfileApprovalPendingPageState();
}

class _ProfileApprovalPendingPageState
    extends ConsumerState<ProfileApprovalPendingPage>
    with WidgetsBindingObserver {
  static const double _topSpacing = AppSpacing.s64 + AppSpacing.s64;
  static const double _titleSubtitleGap = AppSpacing.s20;
  static const double _placeholderSize = 240;
  static const double _bottomReservedSpacing =
      AppSpacing.bottom + AppSpacing.s64;
  static const Duration _refreshInterval = Duration(seconds: 30);

  Timer? _refreshTimer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshTimer = Timer.periodic(
      _refreshInterval,
      (_) => unawaited(_refreshStatus()),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_refreshStatus());
    }
  }

  Future<void> _refreshStatus() async {
    if (!mounted || _hasNavigated) return;

    final status = await ref
        .read(profileApprovalStatusControllerProvider.notifier)
        .refresh();
    if (!mounted) return;

    _handleStatus(status);
  }

  void _handleStatus(LoginProfileStatus? status) {
    if (_hasNavigated || status == null || status.isPendingApproval) return;

    _hasNavigated = true;
    final destination = resolveOnboardingDestination(
      status,
      hasSeenProfileApprovalWelcome:
          AuthSessionPersistence.hasSeenProfileApprovalWelcome(),
    );
    context.goNamed(destination.name);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    ref.listen<AsyncValue<LoginProfileStatus?>>(
      profileApprovalStatusControllerProvider,
      (_, next) => _handleStatus(switch (next) {
        AsyncData(value: final status) => status,
        _ => null,
      }),
    );
    ref.watch(profileApprovalStatusControllerProvider);

    return TextScaleWrapper(
      policy: TextScalePolicy.cappedLarge,
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: colors.backgroundNormal,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: const DefaultFloatingButton(
            label: 'onboarding.approvalPending.start',
            disabled: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.scaffold,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: _topSpacing),
                        DefaultText(
                          'onboarding.approvalPending.title',
                          style: typography.title,
                          color: colors.textStrong,
                          policy: TextScalePolicy.cappedLarge,
                        ),
                        const SizedBox(height: _titleSubtitleGap),
                        DefaultText(
                          'onboarding.approvalPending.subtitle',
                          style: typography.bodySub,
                          color: colors.textAlternative,
                          policy: TextScalePolicy.cappedLarge,
                        ),
                        const Expanded(
                          child: Center(
                            child: SizedBox.square(
                              dimension: _placeholderSize,
                              child: Placeholder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: _bottomReservedSpacing),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

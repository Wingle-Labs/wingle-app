import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_approval_welcome_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 프로필 승인 완료 후 최초 1회 표시되는 안내 화면.
class ProfileApprovalWelcomePage extends ConsumerWidget {
  static const double _titleTopSpacing =
      AppSpacing.s64 + AppSpacing.s64 + AppSpacing.s48;
  static const double _titleSubtitleGap = AppSpacing.s20;
  static const double _imageTopSpacing = AppSpacing.s64;
  static const double _imageSize = 260;
  static const double _bottomReservedSpacing =
      AppSpacing.bottom + AppSpacing.s64;

  /// 생성자.
  const ProfileApprovalWelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileApprovalWelcomeControllerProvider);
    final colors = context.colors;
    final typography = context.typography;
    final nickname = state.nickname.trim().isEmpty
        ? 'onboarding.profileApprovedWelcome.defaultNickname'.tr()
        : state.nickname.trim();

    return TextScaleWrapper(
      policy: TextScalePolicy.cappedLarge,
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: colors.backgroundNormal,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: DefaultFloatingButton(
            label: 'onboarding.profileApprovedWelcome.start',
            isLoading: state.isSaving,
            disabled: state.isSaving,
            onPressed: () => _start(context, ref),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.scaffold,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: _titleTopSpacing),
                          Text(
                            'onboarding.profileApprovedWelcome.title'.tr(
                              namedArgs: {'nickname': nickname},
                            ),
                            textAlign: TextAlign.center,
                            style: typography.title.copyWith(
                              color: colors.textStrong,
                            ),
                          ),
                          const SizedBox(height: _titleSubtitleGap),
                          Text(
                            'onboarding.profileApprovedWelcome.subtitle'.tr(),
                            textAlign: TextAlign.center,
                            style: typography.bodySub.copyWith(
                              color: colors.textAlternative,
                            ),
                          ),
                          const SizedBox(height: _imageTopSpacing),
                          Image.asset(
                            'assets/images/onboarding/verification.png',
                            width: _imageSize,
                            height: _imageSize,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: _bottomReservedSpacing),
                        ],
                      ),
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

  Future<void> _start(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(profileApprovalWelcomeControllerProvider.notifier)
        .markSeen();
    if (!context.mounted) return;

    if (success) {
      context.goNamed(OnboardingRoutes.choiceQuestions.name);
      return;
    }

    final errorMessage = ref
        .read(profileApprovalWelcomeControllerProvider)
        .errorMessage;
    if (errorMessage != null) {
      DefaultToast.show(context, errorMessage);
    }
  }
}

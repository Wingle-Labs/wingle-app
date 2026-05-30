import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_text_button.dart';
import 'package:wingle/app/config/theme/components/cards/default_card.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/components/states/default_bottom_sheet.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/components/wrappers/profile_input_app_bar.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/common/utils/auth_session_state.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 기본 프로필 정보 등록의 첫 단계인 랜덤 닉네임 발급 페이지
class BasicProfileNicknamePage extends ConsumerStatefulWidget {
  /// 생성자
  const BasicProfileNicknamePage({super.key});

  @override
  ConsumerState<BasicProfileNicknamePage> createState() =>
      _BasicProfileNicknamePageState();
}

class _BasicProfileNicknamePageState
    extends ConsumerState<BasicProfileNicknamePage> {
  bool _isLogoutSheetShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(basicProfileProvider.notifier).loadNickname();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final state = ref.watch(basicProfileProvider);
    final notifier = ref.read(basicProfileProvider.notifier);

    return ConstrainedScrollableScaffold(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        unawaited(_showLogoutConfirmation());
      },
      textScalePolicy: .cappedLarge,
      padding: .zero,
      appBar: const ProfileInputAppBar(),
      floatingActionButton: DefaultFloatingButton(
        label: 'common.button.next',
        isLoading: state.shouldShowNicknameLoading,
        disabled: !state.canContinueNickname,
        onPressed: () {
          context.pushNamed(OnboardingRoutes.basicProfileResidence.name);
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultPageHeader(
            title: 'onboarding.basicProfile.nickname.title',
            subtitle: 'onboarding.basicProfile.nickname.subtitle',
            padding: .only(
              top: AppPadding.vertical,
              left: AppPadding.scaffold,
              right: AppPadding.scaffold,
              bottom: AppPadding.pageHeaderExternal,
            ),
            subtitleStyle: typography.bodySub,
            subtitleColor: colors.textAlternative,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.scaffold,
              vertical: AppPadding.card,
            ),
            child: Column(
              children: [
                DefaultCard(
                  child: state.shouldShowNicknameLoading
                      ? const Center(child: AnimationProgressIndicator())
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: DefaultText(
                            state.nickname.isNotEmpty
                                ? state.nickname
                                : state.nicknameErrorMessage ?? '',
                            style: typography.body.copyWith(
                              color: colors.textNeutral,
                            ),
                            isTranslationKey: state.nickname.isEmpty,
                          ),
                        ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IntrinsicWidth(
                    child: DefaultTextButton(
                      label: 'onboarding.basicProfile.nickname.button.change',
                      leadingIcon: Icons.autorenew_rounded,
                      onPressed: state.isNicknameLoading
                          ? null
                          : () => notifier.refreshNickname(),
                      isDisabled: state.isNicknameLoading,
                      foregroundColor: colors.textNeutral,
                      textStyle: typography.buttonSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (state.nicknameErrorMessage != null &&
              state.nickname.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s12),
            DefaultText(
              state.nicknameErrorMessage!,
              style: typography.caption.copyWith(color: colors.textAssistive),
            ),
          ],
          const SizedBox(height: AppSpacing.bottom),
        ],
      ),
    );
  }

  Future<void> _showLogoutConfirmation() async {
    if (_isLogoutSheetShowing) return;
    _isLogoutSheetShowing = true;

    try {
      final colors = context.colors;
      final typography = context.typography;

      await DefaultBottomSheet.show<void>(
        context,
        isHandleContained: true,
        body: DefaultPageHeader(
          title: 'onboarding.basicProfile.nickname.bottomSheet.title',
          subtitle: 'onboarding.basicProfile.nickname.bottomSheet.description',
          padding: EdgeInsets.zero,
          subtitleStyle: typography.bodySub,
          subtitleColor: colors.textAlternative,
        ),
        onMain: () {
          context.pop();
        },
        mainLabel: 'onboarding.basicProfile.nickname.bottomSheet.mainLabel',
        onSub: () {
          context.pop();
          unawaited(_logoutAndGoToLogin());
        },
        subLabel: 'onboarding.basicProfile.nickname.bottomSheet.subLabel',
      );
    } finally {
      _isLogoutSheetShowing = false;
    }
  }

  Future<void> _logoutAndGoToLogin() async {
    await AuthSessionState.clearLoginInfo();
    if (!mounted) return;

    context.goNamed(OnboardingRoutes.login.name);
  }
}

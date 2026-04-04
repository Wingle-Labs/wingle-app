import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_text_button.dart';
import 'package:wingle/app/config/theme/components/cards/default_card.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/components/texts/default_intruction.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_nickname_provider.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(basicProfileNicknameProvider.notifier).loadNickname();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final state = ref.watch(basicProfileNicknameProvider);
    final notifier = ref.read(basicProfileNicknameProvider.notifier);

    return ConstrainedScrollableScaffold(
      appBar: const DefaultAppBar(),
      floatingActionButton: DefaultFloatingButton(
        label: 'common.button.next',
        isLoading: state.shouldShowLoading,
        disabled: !state.canContinue,
        onPressed: () {
          context.pushNamed(OnboardingRoutes.age.name);
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          DefaultInstruction(
            'onboarding.basicProfile.nickname.title',
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: AppSpacing.instructionInternal),
          DefaultText(
            'onboarding.basicProfile.nickname.subtitle',
            style: typography.bodySub,
            color: colors.textAlternative,
            policy: .cappedLarge,
          ),
          const SizedBox(height: AppSpacing.xl),
          DefaultCard(
            child: state.shouldShowLoading
                ? const Center(child: AnimationProgressIndicator())
                : Align(
                    alignment: Alignment.centerLeft,
                    child: DefaultText(
                      state.nickname.isNotEmpty
                          ? state.nickname
                          : state.errorMessage ?? '',
                      style: typography.body.copyWith(
                        color: colors.textNeutral,
                      ),
                      isTranslationKey: state.nickname.isEmpty,
                    ),
                  ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Align(
            alignment: Alignment.centerRight,
            child: IntrinsicWidth(
              child: DefaultTextButton(
                label: 'onboarding.basicProfile.nickname.button.change',
                leadingIcon: Icons.autorenew_rounded,
                onPressed: state.isLoading
                    ? null
                    : () => notifier.refreshNickname(),
                isDisabled: state.isLoading,
                foregroundColor: colors.textNeutral,
                textStyle: typography.buttonSmall,
              ),
            ),
          ),
          if (state.errorMessage != null && state.nickname.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            DefaultText(
              state.errorMessage!,
              style: typography.caption.copyWith(color: colors.textAssistive),
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}

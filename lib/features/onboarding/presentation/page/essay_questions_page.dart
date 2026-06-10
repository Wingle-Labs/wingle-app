import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/badges/default_badge.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/home/route/home_routes.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/presentation/models/essay_questions_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/essay_questions_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_route_chain.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 승인 이후 선택 주관식 질문 목록 페이지.
class EssayQuestionsPage extends ConsumerWidget {
  /// 생성자.
  const EssayQuestionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(essayQuestionsControllerProvider);

    void navigatePrevious() {
      OnboardingRouteChain.goPrevious(
        context,
        OnboardingRouteFlow.approvedQuestions,
        OnboardingRoutes.requiredSelfIntro,
      );
    }

    return asyncState.when(
      data: (state) =>
          _EssayQuestionsContent(state: state, onBackPressed: navigatePrevious),
      loading: () => ConstrainedScrollableScaffold(
        appBar: DefaultAppBar(
          title: 'onboarding.essayQuestions.appBarTitle',
          forceImplyLeading: true,
          onBackPressed: navigatePrevious,
        ),
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          navigatePrevious();
        },
        child: const Center(child: AnimationProgressIndicator()),
      ),
      error: (error, stackTrace) => _EssayQuestionsError(
        onBackPressed: navigatePrevious,
        onRetry: () => ref.invalidate(essayQuestionsControllerProvider),
      ),
    );
  }
}

class _EssayQuestionsContent extends ConsumerWidget {
  final EssayQuestionsModel state;
  final VoidCallback onBackPressed;

  const _EssayQuestionsContent({
    required this.state,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typography = context.typography;

    return ConstrainedScrollableScaffold(
      appBar: DefaultAppBar(
        title: 'onboarding.essayQuestions.appBarTitle',
        forceImplyLeading: true,
        onBackPressed: onBackPressed,
        trailing: _SkipAction(
          isLoading: state.isSubmitting,
          onPressed: () => _skip(context, ref),
        ),
      ),
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        onBackPressed();
      },
      textScalePolicy: TextScalePolicy.cappedLarge,
      floatingActionButton: DefaultFloatingButton(
        label: 'onboarding.essayQuestions.next',
        isLoading: state.isSubmitting,
        onPressed: () => _complete(context, ref),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultPageHeader(
              title: 'onboarding.essayQuestions.title',
              subtitle: 'onboarding.essayQuestions.subtitle',
              titleStyle: typography.display.copyWith(
                color: colors.textNormal,
                fontSize: 30,
              ),
              subtitleStyle: typography.mainSub.copyWith(
                color: colors.textAlternative,
              ),
              padding: const EdgeInsets.only(
                top: AppSpacing.s48,
                bottom: AppSpacing.s32,
              ),
            ),
            Text(
              'onboarding.essayQuestions.progress'.tr(
                namedArgs: {
                  'done': state.completedQuestionCount.toString(),
                  'total': state.totalQuestionCount.toString(),
                },
              ),
              style: typography.body.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: AppSpacing.s16),
            for (final question in state.questions) ...[
              _EssayQuestionListButton(
                question: question,
                answer: state.answerOf(question.id),
                onPressed: () {
                  context.pushNamed(
                    OnboardingRoutes.essayQuestionInput.name,
                    pathParameters: {'questionId': question.id.toString()},
                  );
                },
              ),
              const SizedBox(height: AppSpacing.s12),
            ],
            const SizedBox(height: AppSpacing.bottom),
          ],
        ),
      ),
    );
  }

  Future<void> _complete(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(essayQuestionsControllerProvider.notifier)
        .completeWithAnswers();
    if (!context.mounted) return;

    if (!success) {
      DefaultToast.show(
        context,
        _currentState(ref)?.submitErrorMessage ??
            'onboarding.essayQuestions.saveFailed',
      );
      return;
    }

    context.goNamed(HomeRoutes.root.name);
  }

  Future<void> _skip(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(essayQuestionsControllerProvider.notifier)
        .skip();
    if (!context.mounted) return;

    if (!success) {
      DefaultToast.show(
        context,
        _currentState(ref)?.submitErrorMessage ??
            'onboarding.essayQuestions.saveFailed',
      );
      return;
    }

    context.goNamed(HomeRoutes.root.name);
  }

  EssayQuestionsModel? _currentState(WidgetRef ref) {
    return switch (ref.read(essayQuestionsControllerProvider)) {
      AsyncData(value: final value) => value,
      _ => null,
    };
  }
}

class _EssayQuestionListButton extends StatelessWidget {
  static const double _minHeight = 104;
  static const double _iconBoxSize = 32;

  final EssayQuestionDetail question;
  final String answer;
  final VoidCallback onPressed;

  const _EssayQuestionListButton({
    required this.question,
    required this.answer,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final hasAnswer = answer.trim().isNotEmpty;

    return Semantics(
      button: true,
      selected: hasAnswer,
      label: question.content,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppRadius.standard),
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
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.backgroundNormal,
              borderRadius: BorderRadius.circular(AppRadius.standard),
              border: Border.all(color: colors.strokeStructuralBorder),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: _minHeight),
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.card),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DefaultBadge(
                            text: hasAnswer
                                ? 'onboarding.essayQuestions.completedBadge'
                                      .tr()
                                : 'onboarding.essayQuestions.optionalBadge'
                                      .tr(),
                            size: DefaultBadgeSize.sm,
                            type: hasAnswer
                                ? DefaultBadgeType.primary
                                : DefaultBadgeType.gray,
                          ),
                          const SizedBox(height: AppSpacing.s12),
                          Text(
                            question.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: typography.main.copyWith(
                              color: colors.textNormal,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.s8),
                          Text(
                            hasAnswer
                                ? answer.trim()
                                : 'onboarding.essayQuestions.emptyPreview'.tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: typography.bodySub.copyWith(
                              color: hasAnswer
                                  ? colors.textAlternative
                                  : colors.textAssistive,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s12),
                    SizedBox.square(
                      dimension: _iconBoxSize,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: AppIconSize.md,
                        color: colors.textAlternative,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SkipAction extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _SkipAction({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: colors.textAlternative,
        disabledForegroundColor: colors.textAssistive,
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.xxs),
      ),
      child: Text(
        'onboarding.essayQuestions.skip'.tr(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: typography.mainSub.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _EssayQuestionsError extends StatelessWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onRetry;

  const _EssayQuestionsError({
    required this.onBackPressed,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return ConstrainedScrollableScaffold(
      appBar: DefaultAppBar(
        title: 'onboarding.essayQuestions.appBarTitle',
        forceImplyLeading: true,
        onBackPressed: onBackPressed,
      ),
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        onBackPressed();
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'onboarding.essayQuestions.loadFailed'.tr(),
              textAlign: TextAlign.center,
              style: typography.body.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: AppSpacing.s20),
            DefaultFilledButton(
              label: 'common.button.retry',
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

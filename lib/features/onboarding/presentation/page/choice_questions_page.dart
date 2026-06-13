import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/presentation/models/choice_questions_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/choice_questions_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_route_chain.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 승인 이후 필수 객관식 질문 입력 페이지.
class ChoiceQuestionsPage extends ConsumerWidget {
  /// 생성자.
  const ChoiceQuestionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(choiceQuestionsControllerProvider);

    void navigatePrevious() {
      OnboardingRouteChain.goPrevious(
        context,
        OnboardingRouteFlow.approvedQuestions,
        OnboardingRoutes.choiceQuestions,
      );
    }

    return asyncState.when(
      data: (state) => _ChoiceQuestionsContent(
        state: state,
        onBackPressed: navigatePrevious,
      ),
      loading: () => ConstrainedScrollableScaffold(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          navigatePrevious();
        },
        child: const Center(child: AnimationProgressIndicator()),
      ),
      error: (error, stackTrace) => _ChoiceQuestionsError(
        onBackPressed: navigatePrevious,
        onRetry: () => ref.invalidate(choiceQuestionsControllerProvider),
      ),
    );
  }
}

class _ChoiceQuestionsContent extends ConsumerStatefulWidget {
  static const double _titleFontSize = 32;

  final ChoiceQuestionsModel state;
  final VoidCallback onBackPressed;

  const _ChoiceQuestionsContent({
    required this.state,
    required this.onBackPressed,
  });

  @override
  ConsumerState<_ChoiceQuestionsContent> createState() =>
      _ChoiceQuestionsContentState();
}

class _ChoiceQuestionsContentState
    extends ConsumerState<_ChoiceQuestionsContent> {
  static const Duration _incompleteQuestionScrollDuration = Duration(
    milliseconds: 350,
  );
  static const double _incompleteQuestionScrollAlignment = 0.12;

  final Map<int, GlobalKey> _questionKeys = {};

  @override
  void initState() {
    super.initState();
    _syncQuestionKeys();
  }

  @override
  void didUpdateWidget(covariant _ChoiceQuestionsContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncQuestionKeys();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = widget.state;

    return ConstrainedScrollableScaffold(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        widget.onBackPressed();
      },
      textScalePolicy: TextScalePolicy.cappedLarge,
      floatingActionButton: _ChoiceQuestionsCounterButton(
        label: '${state.selectedQuestionCount}/${state.totalQuestionCount}',
        isEnabled: state.canSubmit,
        isLoading: state.isSubmitting,
        onPressed: () => _submit(context),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultPageHeader(
              title: 'onboarding.choiceQuestions.title',
              subtitle: 'onboarding.choiceQuestions.subtitle',
              titleStyle: context.typography.display.copyWith(
                color: colors.textNormal,
                fontSize: _ChoiceQuestionsContent._titleFontSize,
              ),
              subtitleStyle: context.typography.mainSub.copyWith(
                color: colors.textAlternative,
              ),
              padding: const EdgeInsets.only(
                top: AppSpacing.s64,
                bottom: AppSpacing.s64,
              ),
            ),
            for (final question in state.questions) ...[
              _ChoiceQuestionBlock(
                key: _questionKeys[question.id],
                question: question,
                selectedOptionId: state.selectedOptionIds[question.id],
                onSelected: (optionId) {
                  ref
                      .read(choiceQuestionsControllerProvider.notifier)
                      .selectOption(
                        questionId: question.id,
                        optionId: optionId,
                      );
                },
              ),
              const SizedBox(height: AppSpacing.s52),
            ],
            const SizedBox(height: AppSpacing.bottom),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final current = _currentState();
    if (current == null || current.isSubmitting) {
      return;
    }

    if (!current.isComplete) {
      await _scrollToFirstIncompleteQuestion(current);
      return;
    }

    final success = await ref
        .read(choiceQuestionsControllerProvider.notifier)
        .submit();
    if (!context.mounted) return;

    if (!success) {
      DefaultToast.show(
        context,
        _currentState()?.submitErrorMessage ??
            ApiErrorMessages.submitAnswersFailed,
      );
      return;
    }

    final next = OnboardingRouteChain.nextOf(
      OnboardingRouteFlow.approvedQuestions,
      OnboardingRoutes.choiceQuestions,
    );
    if (next == null) return;

    context.goNamed(next.name);
  }

  ChoiceQuestionsModel? _currentState() {
    return switch (ref.read(choiceQuestionsControllerProvider)) {
      AsyncData(value: final value) => value,
      _ => null,
    };
  }

  Future<void> _scrollToFirstIncompleteQuestion(
    ChoiceQuestionsModel state,
  ) async {
    ChoiceQuestionDetail? firstIncompleteQuestion;
    for (final question in state.questions) {
      if (!state.selectedOptionIds.containsKey(question.id)) {
        firstIncompleteQuestion = question;
        break;
      }
    }

    final targetContext =
        _questionKeys[firstIncompleteQuestion?.id]?.currentContext;
    if (targetContext == null) {
      return;
    }

    await Scrollable.ensureVisible(
      targetContext,
      alignment: _incompleteQuestionScrollAlignment,
      alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
      duration: _incompleteQuestionScrollDuration,
      curve: Curves.easeOutCubic,
    );
  }

  void _syncQuestionKeys() {
    final questionIds = widget.state.questions
        .map((question) => question.id)
        .toSet();
    _questionKeys.removeWhere((questionId, _) {
      return !questionIds.contains(questionId);
    });

    for (final questionId in questionIds) {
      _questionKeys.putIfAbsent(questionId, GlobalKey.new);
    }
  }
}

class _ChoiceQuestionBlock extends StatelessWidget {
  final ChoiceQuestionDetail question;
  final int? selectedOptionId;
  final ValueChanged<int> onSelected;

  const _ChoiceQuestionBlock({
    super.key,
    required this.question,
    required this.selectedOptionId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.content,
          style: typography.title.copyWith(
            color: colors.textNormal,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.s20),
        LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: AppSpacing.s12,
              runSpacing: AppSpacing.s12,
              children: [
                for (final option in question.options)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                    child: _ChoiceQuestionOptionChip(
                      label: option.content,
                      isSelected: selectedOptionId == option.id,
                      onPressed: () => onSelected(option.id),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ChoiceQuestionOptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ChoiceQuestionOptionChip({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final backgroundColor = isSelected
        ? colors.componentChipButtonPrimarySelectedBackground
        : colors.componentChipButtonPrimaryUnselectedBackground;
    final foregroundColor = isSelected
        ? colors.componentChipButtonPrimarySelectedForeground
        : colors.componentChipButtonPrimaryUnselectedForeground;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppRadius.chipButton),
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
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppRadius.chipButton),
              border: isSelected
                  ? null
                  : Border.all(
                      color: colors.componentChipButtonPrimaryUnselectedBorder,
                    ),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppChipButtonHeight.md,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.chipButtonHorizontal,
                  vertical: AppPadding.chipButtonVertical,
                ),
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: typography.chipButton.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceQuestionsCounterButton extends StatelessWidget {
  final String label;
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onPressed;

  const _ChoiceQuestionsCounterButton({
    required this.label,
    required this.isEnabled,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.scaffold),
      child: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: isEnabled
            ? colors.primaryNormal
            : colors.interactionDisable,
        splashColor: colors.overlayPressed,
        extendedPadding: EdgeInsets.zero,
        onPressed: isLoading ? null : onPressed,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.iosStyleRadius),
        label: Center(
          child: isLoading
              ? AnimationProgressIndicator(color: colors.onPrimaryNormal)
              : Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: typography.buttonLarge.copyWith(
                    color: colors.onPrimaryNormal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
        enableFeedback: true,
      ),
    );
  }
}

class _ChoiceQuestionsError extends StatelessWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onRetry;

  const _ChoiceQuestionsError({
    required this.onBackPressed,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return ConstrainedScrollableScaffold(
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
              'onboarding.choiceQuestions.loadFailed'.tr(),
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

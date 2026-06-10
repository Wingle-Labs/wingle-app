import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/constants/component_tokens.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/presentation/models/essay_questions_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/essay_questions_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_route_chain.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 주관식 질문 단일 입력 페이지.
class EssayQuestionInputPage extends ConsumerWidget {
  /// 질문 ID.
  final int questionId;

  /// 생성자.
  const EssayQuestionInputPage({super.key, required this.questionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(essayQuestionsControllerProvider);

    void navigatePrevious() {
      OnboardingRouteChain.goPrevious(
        context,
        OnboardingRouteFlow.approvedQuestions,
        OnboardingRoutes.essayQuestionInput,
      );
    }

    return asyncState.when(
      data: (state) {
        final question = state.questionById(questionId);
        if (question == null) {
          return _EssayQuestionInputNotFound(onBackPressed: navigatePrevious);
        }

        return _EssayQuestionInputContent(
          question: question,
          initialAnswer: state.answerOf(questionId),
          onBackPressed: navigatePrevious,
        );
      },
      loading: () => ConstrainedScrollableScaffold(
        appBar: DefaultAppBar(
          title: 'onboarding.essayQuestions.inputAppBarTitle',
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
      error: (error, stackTrace) =>
          _EssayQuestionInputNotFound(onBackPressed: navigatePrevious),
    );
  }
}

class _EssayQuestionInputContent extends ConsumerStatefulWidget {
  final EssayQuestionDetail question;
  final String initialAnswer;
  final VoidCallback onBackPressed;

  const _EssayQuestionInputContent({
    required this.question,
    required this.initialAnswer,
    required this.onBackPressed,
  });

  @override
  ConsumerState<_EssayQuestionInputContent> createState() =>
      _EssayQuestionInputContentState();
}

class _EssayQuestionInputContentState
    extends ConsumerState<_EssayQuestionInputContent> {
  late final TextEditingController _controller;
  late String _answer;

  @override
  void initState() {
    super.initState();
    _answer = widget.initialAnswer;
    _controller = TextEditingController(text: _answer);
  }

  @override
  void didUpdateWidget(covariant _EssayQuestionInputContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id &&
        _controller.text != widget.initialAnswer) {
      _answer = widget.initialAnswer;
      _controller.text = widget.initialAnswer;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final trimmedAnswer = _answer.trim();

    return ConstrainedScrollableScaffold(
      appBar: DefaultAppBar(
        title: 'onboarding.essayQuestions.inputAppBarTitle',
        forceImplyLeading: true,
        onBackPressed: widget.onBackPressed,
      ),
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        widget.onBackPressed();
      },
      textScalePolicy: TextScalePolicy.cappedLarge,
      floatingActionButton: DefaultFloatingButton(
        label: 'onboarding.essayQuestions.inputComplete',
        disabled: trimmedAnswer.isEmpty,
        onPressed: trimmedAnswer.isEmpty ? null : _complete,
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultPageHeader(
              title: widget.question.content,
              subtitle: 'onboarding.essayQuestions.inputSubtitle',
              isTitleTranslationKey: false,
              titleStyle: typography.display.copyWith(
                color: colors.textNormal,
                fontSize: 30,
              ),
              subtitleStyle: typography.mainSub.copyWith(
                color: colors.textAlternative,
              ),
              padding: const EdgeInsets.only(
                top: AppSpacing.s48,
                bottom: AppSpacing.s40,
              ),
            ),
            _EssayAnswerInput(
              controller: _controller,
              answerLength: _answer.length,
              onChanged: (value) => setState(() => _answer = value),
            ),
            const SizedBox(height: AppSpacing.bottom),
          ],
        ),
      ),
    );
  }

  void _complete() {
    ref
        .read(essayQuestionsControllerProvider.notifier)
        .updateAnswer(
          questionId: widget.question.id,
          content: _controller.text,
        );
    context.goNamed(OnboardingRoutes.requiredSelfIntro.name);
  }
}

class _EssayAnswerInput extends StatelessWidget {
  static const int _fieldMinLines = 4;
  static const double _counterWidth = 104;

  final TextEditingController controller;
  final int answerLength;
  final ValueChanged<String> onChanged;

  const _EssayAnswerInput({
    required this.controller,
    required this.answerLength,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'onboarding.essayQuestions.inputLabel'.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: typography.body.copyWith(color: colors.textAlternative),
              ),
            ),
            SizedBox(
              width: _counterWidth,
              child: Text(
                _counterText(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: typography.body.copyWith(color: colors.textAlternative),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        TextFormField(
          controller: controller,
          inputFormatters: [
            LengthLimitingTextInputFormatter(
              EssayQuestionsModel.answerMaxLength,
            ),
          ],
          keyboardType: TextInputType.multiline,
          minLines: _fieldMinLines,
          maxLines: null,
          textAlignVertical: TextAlignVertical.top,
          onChanged: onChanged,
          cursorColor: colors.primaryNormal,
          cursorErrorColor: colors.statusNegative,
          cursorWidth: AppLineWidth.inputFieldCursor,
          style: typography.body.copyWith(color: colors.textNormal),
          decoration: InputDecoration(
            hintText: 'onboarding.essayQuestions.inputHint'.tr(),
            hintStyle: typography.body.copyWith(color: colors.textAssistive),
            helperText: 'onboarding.essayQuestions.inputAssistive'.tr(),
            helperStyle: typography.bodySub.copyWith(
              color: colors.textAlternative,
            ),
            filled: true,
            fillColor: colors.backgroundNormal,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppComponentPadding.inputHorizontal,
              vertical: AppComponentPadding.inputVertical,
            ),
            enabledBorder: _border(colors.strokeStructuralBorder),
            focusedBorder: _border(colors.strokeStructuralBorder),
            border: _border(colors.strokeStructuralBorder),
          ),
        ),
      ],
    );
  }

  String _counterText(BuildContext context) {
    final suffix = context.locale.languageCode == 'en' ? ' chars' : '자';
    return '$answerLength/${EssayQuestionsModel.answerMaxLength}$suffix';
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppComponentRadius.input),
      borderSide: BorderSide(
        color: color,
        width: AppLineWidth.inputFieldOutline,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
    );
  }
}

class _EssayQuestionInputNotFound extends StatelessWidget {
  final VoidCallback onBackPressed;

  const _EssayQuestionInputNotFound({required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return ConstrainedScrollableScaffold(
      appBar: DefaultAppBar(
        title: 'onboarding.essayQuestions.inputAppBarTitle',
        forceImplyLeading: true,
        onBackPressed: onBackPressed,
      ),
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        onBackPressed();
      },
      child: Center(
        child: Text(
          'onboarding.essayQuestions.emptyQuestion'.tr(),
          textAlign: TextAlign.center,
          style: typography.body.copyWith(color: colors.textAlternative),
        ),
      ),
    );
  }
}

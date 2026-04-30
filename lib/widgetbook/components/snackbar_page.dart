import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// Snackbar 컴포넌트 프리뷰
class SnackbarPage extends StatelessWidget {
  /// 생성자
  const SnackbarPage({super.key});

  static const double _sampleWidth = 343;
  static const double _cardMinWidth = 520;
  static const double _cardMinHeight = 360;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Snackbar', style: typography.title),
            const SizedBox(height: AppSpacing.s12),
            Text(
              'Snackbar는 사용자 행동에 대한 결과를 빠르게 피드백하기 위한 '
              '임시 알림 컴포넌트로, 화면 흐름을 방해하지 않으며 일정 시간 후 '
              '자동으로 사라집니다. 필요에 따라 간단한 액션을 함께 제공할 수 '
              '있습니다.',
              style: typography.bodySub.copyWith(color: colors.textNormal),
            ),
            const SizedBox(height: AppSpacing.s32),
            Wrap(
              spacing: AppSpacing.s24,
              runSpacing: AppSpacing.s24,
              children: const [
                _SnackbarSpecCard(
                  title: 'Text snackbar',
                  description:
                      '별도의 액션이 요구되지 않으며, 단순 알림을 목적으로 '
                      '할 때 사용됩니다.',
                  withAction: false,
                ),
                _SnackbarSpecCard(
                  title: 'Action snackbar',
                  description:
                      '사용자에게 액션이 요구되지만, 일정 시간이 지나면 '
                      '사라집니다.',
                  withAction: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SnackbarSpecCard extends StatelessWidget {
  final String title;
  final String description;
  final bool withAction;

  const _SnackbarSpecCard({
    required this.title,
    required this.description,
    required this.withAction,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Container(
      constraints: const BoxConstraints(
        minWidth: SnackbarPage._cardMinWidth,
        minHeight: SnackbarPage._cardMinHeight,
      ),
      padding: const EdgeInsets.all(AppPadding.card),
      decoration: BoxDecoration(
        color: colors.backgroundNormal,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: typography.title),
          const SizedBox(height: AppSpacing.s16),
          Text(description, style: typography.body),
          const SizedBox(height: AppSpacing.s32),
          _SnackbarSample(withLeading: true, withAction: withAction),
          const SizedBox(height: AppSpacing.s12),
          _SnackbarTriggerButton(
            label: '아이콘 포함 표시',
            withLeading: true,
            withAction: withAction,
          ),
          const SizedBox(height: AppSpacing.s24),
          _SnackbarSample(withLeading: false, withAction: withAction),
          const SizedBox(height: AppSpacing.s12),
          _SnackbarTriggerButton(
            label: '기본 표시',
            withLeading: false,
            withAction: withAction,
          ),
        ],
      ),
    );
  }
}

class _SnackbarTriggerButton extends StatelessWidget {
  final String label;
  final bool withLeading;
  final bool withAction;

  const _SnackbarTriggerButton({
    required this.label,
    required this.withLeading,
    required this.withAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return FilledButton(
      onPressed: () {
        DefaultToast.show(
          context,
          '행운 하나 더 드려요. 100원',
          leading: withLeading ? const _SampleLeading() : null,
          actionLabel: withAction ? '행운 받기' : null,
          onAction: withAction ? () {} : null,
          isTranslationKey: false,
          isActionTranslationKey: false,
        );
      },
      style: FilledButton.styleFrom(
        backgroundColor: colors.primaryNormal,
        foregroundColor: colors.onPrimaryNormal,
        textStyle: typography.buttonMedium,
      ),
      child: Text(label),
    );
  }
}

class _SnackbarSample extends StatelessWidget {
  final bool withLeading;
  final bool withAction;

  const _SnackbarSample({required this.withLeading, required this.withAction});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SnackbarPage._sampleWidth,
      child: DefaultToastContent(
        message: '행운 하나 더 드려요. 100원',
        leading: withLeading ? const _SampleLeading() : null,
        actionLabel: withAction ? '행운 받기' : null,
        onAction: withAction ? () {} : null,
        isTranslationKey: false,
        isActionTranslationKey: false,
      ),
    );
  }
}

class _SampleLeading extends StatelessWidget {
  const _SampleLeading();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: AppIconSize.xl,
      height: AppIconSize.xl,
      decoration: BoxDecoration(
        color: colors.staticBlack,
        border: Border.all(color: colors.primaryNormal),
      ),
    );
  }
}

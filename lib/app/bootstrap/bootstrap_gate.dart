import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/bootstrap/bootstrap_controller.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 부트스트랩 결과에 따라 앱 진입 전 로딩/재시도 화면을 노출한다.
class BootstrapGate extends ConsumerWidget {
  /// 앱 본문.
  final Widget child;

  /// 생성자.
  const BootstrapGate({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(bootstrapControllerProvider);

    return bootstrap.when(
      data: (result) {
        if (result.success) {
          return child;
        }

        return const _BootstrapRetryView();
      },
      loading: () => const _BootstrapLoadingView(),
      error: (error, stackTrace) => const _BootstrapRetryView(),
    );
  }
}

class _BootstrapLoadingView extends StatelessWidget {
  const _BootstrapLoadingView();

  @override
  Widget build(BuildContext context) {
    return _BootstrapFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AnimationProgressIndicator(),
          const SizedBox(height: AppSpacing.s24),
          DefaultText(
            'common.bootstrap.loadingTitle',
            style: context.typography.title,
            color: context.colors.textNormal,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s8),
          DefaultText(
            'common.bootstrap.loadingSubtitle',
            style: context.typography.body,
            color: context.colors.textAlternative,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BootstrapRetryView extends ConsumerWidget {
  const _BootstrapRetryView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRetrying = ref.watch(
      bootstrapControllerProvider.select((state) => state.isLoading),
    );

    return _BootstrapFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultText(
            'common.bootstrap.retryTitle',
            style: context.typography.title,
            color: context.colors.textNormal,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s12),
          DefaultText(
            'common.bootstrap.retrySubtitle',
            style: context.typography.body,
            color: context.colors.textAlternative,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s32),
          DefaultFilledButton(
            label: 'common.bootstrap.retryButton',
            isLoading: isRetrying,
            onPressed: () {
              ref.read(bootstrapControllerProvider.notifier).retry();
            },
          ),
        ],
      ),
    );
  }
}

class _BootstrapFrame extends StatelessWidget {
  final Widget child;

  const _BootstrapFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.backgroundNormal,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.scaffold),
          child: Center(child: child),
        ),
      ),
    );
  }
}

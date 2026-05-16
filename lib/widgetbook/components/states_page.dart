import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/components/states/default_bottom_sheet.dart';
import 'package:wingle/app/config/theme/components/states/default_loadding_dialog.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 상태성 컴포넌트 프리뷰
class StatesPage extends StatelessWidget {
  /// 생성자
  const StatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('States', style: typography.title),
            const SizedBox(height: 8),
            Text(
              'AnimationProgressIndicator, DefaultToast, DefaultBottomSheet, '
              'DefaultLoaddingDialog',
              style: typography.bodySub.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: 24),
            _StateCard(
              title: 'AnimationProgressIndicator',
              child: const Center(child: AnimationProgressIndicator()),
            ),
            _StateCard(
              title: 'DefaultToast',
              child: DefaultFilledButton(
                label: 'designSystem.button.filled.enabled',
                onPressed: () {
                  DefaultToast.show(
                    context,
                    'designSystem.sample.primaryColor',
                  );
                },
              ),
            ),
            _StateCard(
              title: 'DefaultBottomSheet',
              child: DefaultFilledButton(
                label: 'designSystem.button.filled.enabled',
                onPressed: () {
                  DefaultBottomSheet.show<void>(
                    context,
                    body: const DefaultPageHeader(
                      title:
                          'onboarding.basicProfile.nickname.bottomSheet.title',
                      subtitle:
                          'onboarding.basicProfile.nickname.bottomSheet.'
                          'description',
                    ),
                    mainLabel:
                        'onboarding.basicProfile.nickname.bottomSheet.'
                        'mainLabel',
                    subLabel:
                        'onboarding.basicProfile.nickname.bottomSheet.subLabel',
                    onMain: () => Navigator.of(context).pop(),
                    onSub: () => Navigator.of(context).pop(),
                    isHandleContained: true,
                  );
                },
              ),
            ),
            _StateCard(
              title: 'DefaultLoaddingDialog',
              child: DefaultFilledButton(
                label: 'designSystem.button.filled.enabled',
                onPressed: () async {
                  await DefaultLoaddingDialog.showWhileExecuting<void>(
                    context,
                    () =>
                        Future<void>.delayed(const Duration(milliseconds: 900)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _StateCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.backgroundNormal,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.strokeStructuralBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: typography.main),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

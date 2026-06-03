import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 프로필 심사 승인 대기 안내 화면.
class ProfileApprovalPendingPage extends StatelessWidget {
  /// 생성자.
  const ProfileApprovalPendingPage({super.key});

  static const double _topSpacing = AppSpacing.s64 + AppSpacing.s64;
  static const double _titleSubtitleGap = AppSpacing.s20;
  static const double _placeholderSize = 240;
  static const double _bottomReservedSpacing =
      AppSpacing.bottom + AppSpacing.s64;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

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

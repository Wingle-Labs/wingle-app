import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/cards/guide_card.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/components/states/default_loadding_dialog.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/agreement_group.dart';
import 'package:wingle/features/onboarding/presentation/providers/agreement_list_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 약관 동의 페이지
class AgreementPage extends ConsumerWidget {
  /// 생성자
  const AgreementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncModel = ref.watch(agreementListProvider);
    final notifier = ref.watch(agreementListProvider.notifier);

    return ConstrainedScrollableScaffold(
      appBar: DefaultAppBar(),
      floatingActionButton: Padding(
        padding: .symmetric(horizontal: AppPadding.btnHorizontal),
        child: DefaultFilledButton(
          variant: .fullWidth,
          label: 'onboarding.agreement.button.confirm',
          isDisabled: asyncModel.maybeWhen(
            data: (model) => !model.isRequiredChecked || model.isSubmitting,
            orElse: () => true,
          ),
          onPressed: asyncModel.maybeWhen(
            data: (model) => () async {
              final result =
                  await DefaultLoaddingDialog.showWhileExecuting<bool>(
                    context,
                    () => notifier.submitAgreements(),
                  );

              if (!context.mounted) return;

              if (result) {
                context.pushNamed(OnboardingRoutes.pass.name);
              } else {
                DefaultToast.show(context, ApiErrorMessages.submitTermsFailed);
              }
            },
            orElse: () => null,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GuideCard(
            title: 'onboarding.agreement.guide.title',
            message: 'onboarding.agreement.guide.message',
          ),

          asyncModel.when(
            loading: () => const Padding(
              padding: EdgeInsets.only(
                top: AppPadding.listTop,
                bottom: AppSpacing.bottom,
              ),
              child: Center(child: AnimationProgressIndicator()),
            ),
            error: (e, _) => const Padding(
              padding: EdgeInsets.only(
                top: AppPadding.listTop,
                bottom: AppSpacing.bottom,
              ),
              child: Center(
                child: DefaultText('onboarding.agreement.state.loadFailed'),
              ),
            ),
            data: (model) {
              if (model.items.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(
                    top: AppPadding.listTop,
                    bottom: AppSpacing.bottom,
                  ),
                  child: Center(
                    child: DefaultText('onboarding.agreement.state.empty'),
                  ),
                );
              }

              return Container(
                padding: .only(
                  top: AppPadding.listTop,
                  bottom: AppPadding.listBottom,
                ),
                child: const AgreementGroup(),
              );
            },
          ),
        ],
      ),
    );
  }
}

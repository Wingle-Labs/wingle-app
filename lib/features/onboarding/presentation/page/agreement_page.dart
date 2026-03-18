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
          label: "다음",
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
        children: [
          GuideCard(
            title: "약관동의 안내",
            message: "얼마 전에 소녀 앞에서 한 번 실수를 했을 뿐,\n여태 큰길 가듯이 건너던 징검다리",
          ),

          asyncModel.when(
            loading: () => const Expanded(
              child: Center(child: AnimationProgressIndicator()),
            ),
            error: (e, _) =>
                Expanded(child: Center(child: DefaultText("약관을 불러오지 못했습니다"))),
            data: (model) {
              if (model.items.isEmpty) {
                return Expanded(child: Center(child: DefaultText("약관이 없습니다")));
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

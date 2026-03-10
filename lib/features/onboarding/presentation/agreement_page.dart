import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/cards/guide_card.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/agreement_group.dart';
import 'package:wingle/features/onboarding/presentation/providers/agreement_list_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 약관 동의 페이지
class AgreementPage extends ConsumerWidget {
  /// 생성자
  const AgreementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(agreementListProvider);

    return ConstrainedScrollableScaffold(
      appBar: DefaultAppBar(),
      floatingActionButton: Padding(
        padding: .symmetric(horizontal: AppPadding.btnHorizontal),
        child: DefaultFilledButton(
          label: "다음",
          isDisabled: !model.isRequiredChecked,
          onPressed: () => context.goNamed(OnboardingRoutes.pass.name),
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          GuideCard(
            title: "약관동의 안내",
            message: "얼마 전에 소녀 앞에서 한 번 실수를 했을 뿐,\n여태 큰길 가듯이 건너던 징검다리",
          ),

          if (model.items.isEmpty) ...[
            Spacer(),
            Center(child: CircularProgressIndicator()),
            Spacer(),
            Spacer(),
          ] else ...[
            Container(
              padding: .only(
                top: AppPadding.listTop,
                bottom: AppPadding.listBottom,
              ),
              child: AgreementGroup(),
            ),
          ],
        ],
      ),
    );
  }
}

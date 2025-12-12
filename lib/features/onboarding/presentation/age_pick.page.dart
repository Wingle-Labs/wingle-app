import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/bottons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/cards/default_card.dart';
import 'package:wingle/app/config/theme/components/pickers/date_picker.dart';
import 'package:wingle/app/config/theme/components/texts/default_intruction.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/constants/route_constants.dart';
import 'package:wingle/features/onboarding/presentation/components/agreement_group.dart';

/// 나이 선택 페이지
class AgePickPage extends ConsumerStatefulWidget {
  /// 생성자
  const AgePickPage({super.key});

  @override
  ConsumerState<AgePickPage> createState() => _AgePickPageState();
}

class _AgePickPageState extends ConsumerState<AgePickPage> {
  @override
  Widget build(BuildContext context) {
    return ScrollableScaffold(
      title: 'onboarding.age.title',
      body: <Widget>[
        DefaultInstruction('onboarding.age.instruction'),
        DefaultCard(
          child: Column(
            children: [
              DatePicker(
                selectedDate: .utc(2000, 11, 26),
                maximumDate: .now().subtract(const Duration(days: 365 * 18)),
                minimumDate: .now().subtract(const Duration(days: 365 * 100)),
                onDateTimeChanged: (date) {},
              ),
              Padding(padding: .only(bottom: AppSpacing.lg)),
              Column(
                mainAxisAlignment: .center,
                children: [
                  AgreementGroup(
                    value: true,
                    onChanged: (value) {},
                    text: 'onboarding.age.checkbox.adult',
                    isTranslated: true,
                  ),
                  Padding(padding: .only(bottom: AppSpacing.md)),
                  AgreementGroup(
                    value: false,
                    onChanged: (value) {},
                    text: 'onboarding.age.checkbox.block',
                    isTranslated: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
      floatingActionButton: DefaultFloatingButton(
        onPressed: () {
          context.push(
            AppRouteUtil.fullPath([.onboarding, .requiredSelfIntro]),
          );
        },
        label: 'onboarding.age.button.next',
        isLoading: false,
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/bottons/loadding_text_button.dart';
import 'package:wingle/app/config/theme/components/cards/default_card.dart';
import 'package:wingle/app/config/theme/components/pickers/date_picker.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/components/wrappers/smooth_rect.dart';
import 'package:wingle/app/config/theme/constants/color.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/features/onboarding/presentation/agreement_group.dart';

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
        Padding(
          padding: .only(bottom: AppSpacing.xl),
          child: Text(
            'onboarding.age.instruction'.tr(),
            style: TextStyle(fontSize: AppFontSize.xl),
          ),
        ),
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
                  ),
                  Padding(padding: .only(bottom: AppSpacing.md)),
                  AgreementGroup(
                    value: false,
                    onChanged: (value) {},
                    text: 'onboarding.age.checkbox.block',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
      floatingActionButton: SmoothRectWrapper(
        child: FloatingActionButton.extended(
          backgroundColor: AppColor.primary,
          extendedPadding: .zero,
          onPressed: () {},
          label: LoadingTextButton(
            isLoading: false,
            label: 'onboarding.age.button.next'.tr(),
          ),
        ),
      ),
    );
  }
}

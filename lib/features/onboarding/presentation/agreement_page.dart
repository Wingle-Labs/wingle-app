import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/bottons/default_checkbox.dart';
import 'package:wingle/app/config/theme/components/bottons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/bottons/default_list_button.dart';
import 'package:wingle/app/config/theme/components/cards/guide_card.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';

/// 약관 동의 페이지
class AgreementPage extends ConsumerWidget {
  /// 생성자
  const AgreementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedScrollableScaffold(
      appBar: DefaultAppBar(),
      floatingActionButton: Padding(
        padding: .symmetric(horizontal: AppPadding.btnHorizontal),
        child: DefaultFilledButton(label: "다음"),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          GuideCard(
            title: "약관동의 안내",
            message: "얼마 전에 소녀 앞에서 한 번 실수를 했을 뿐,\n여태 큰길 가듯이 건너던 징검다리",
          ),
          Container(
            padding: .only(
              top: AppPadding.listTop,
              bottom: AppPadding.listBottom,
            ),
            child: Column(
              children: [
                DefaultCheckbox(isChecked: true, onChanged: (value) {}),
                DefaultListButton(
                  isChecked: true,
                  onChanged: (value) {},
                  isDisabled: false,
                  label: "전체 동의",
                  hasArrow: false,
                ),
                DefaultListButton(
                  isChecked: true,
                  onChanged: (value) {},
                  isDisabled: false,
                  label: "윙글 이용약관 필수동의",
                ),
                DefaultListButton(
                  isChecked: false,
                  onChanged: (value) {},
                  isDisabled: false,
                  label: "개인정보 처리 동의",
                ),
                DefaultListButton(
                  isChecked: false,
                  onChanged: (value) {},
                  isDisabled: true,
                  label: "위치정보 이용 동의",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

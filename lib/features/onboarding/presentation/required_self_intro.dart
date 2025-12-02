import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/bottons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/texts/default_intruction.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';
import 'package:wingle/features/onboarding/presentation/components/introduce_card_group.dart';

/// 필수 자기소개 페이지
class RequiredSelfIntroPage extends ConsumerWidget {
  /// 생성자
  const RequiredSelfIntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScrollableScaffold(
      title: 'onboarding.requiredSelfIntro.title',
      body: <Widget>[
        DefaultInstruction('onboarding.requiredSelfIntro.instruction'),
        IntroduceCardGroup(
          countryCode: "ko",
          questions: [
            'onboarding.requiredSelfIntro.question.1',
            'onboarding.requiredSelfIntro.question.2',
            'onboarding.requiredSelfIntro.question.3',
          ],
        ),
      ],
      addBottomSpacing: true,
      floatingActionButton: DefaultFloatingButton(
        label: 'onboarding.requiredSelfIntro.button.next',
      ),
    );
  }
}

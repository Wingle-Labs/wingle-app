import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/introduce_card_group.dart';
import 'package:wingle/features/onboarding/presentation/data/required_self_intro_question_keys.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 필수 자기소개 페이지
class RequiredSelfIntroPage extends ConsumerWidget {
  /// 생성자
  const RequiredSelfIntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScrollableScaffold(
      title: 'onboarding.requiredSelfIntro.title',
      body: <Widget>[
        const DefaultPageHeader(
          title: 'onboarding.requiredSelfIntro.instruction',
        ),
        IntroduceCardGroup(questions: requiredSelfIntroQuestionKeys),
      ],
      addBottomSpacing: true,
      floatingActionButton: DefaultFloatingButton(
        label: 'onboarding.requiredSelfIntro.button.next',
        onPressed: () => context.pushNamed(OnboardingRoutes.contactBlock.name),
      ),
    );
  }
}

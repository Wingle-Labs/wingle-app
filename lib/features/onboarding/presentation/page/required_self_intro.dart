import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/texts/default_intruction.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/introduce_card_group.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 필수 자기소개 페이지
class RequiredSelfIntroPage extends ConsumerWidget {
  /// 생성자
  const RequiredSelfIntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Repository 패턴 구현
    final questionModel = {
      'ko': ['자신의 성격을 자세히 소개해주세요', '자신의 관심사나 취미를 소개해주세요', '자신의 연애관에 대해서 알려주세요'],
    };
    final currentLanguageCode = context.locale.languageCode;
    return ScrollableScaffold(
      title: 'onboarding.requiredSelfIntro.title',
      body: <Widget>[
        DefaultInstruction('onboarding.requiredSelfIntro.instruction'),
        IntroduceCardGroup(
          countryCode: currentLanguageCode,
          questions: questionModel[currentLanguageCode] ?? [],
        ),
      ],
      addBottomSpacing: true,
      floatingActionButton: DefaultFloatingButton(
        label: 'onboarding.requiredSelfIntro.button.next',
        onPressed: () =>
            context.pushNamed(OnboardingRoutes.selectiveSelfIntro.name),
      ),
    );
  }
}

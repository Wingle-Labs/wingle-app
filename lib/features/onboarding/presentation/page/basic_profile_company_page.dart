import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/cards/default_card.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/basic_profile_input_scaffold.dart';
import 'package:wingle/features/onboarding/presentation/constants/basic_profile_input_constants.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 기본 프로필 입력의 회사 입력 placeholder 페이지.
class BasicProfileCompanyPage extends StatelessWidget {
  /// 생성자
  const BasicProfileCompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicProfileInputScaffold(
      currentStep: BasicProfileInputConstants.companyStep,
      totalSteps: BasicProfileInputConstants.totalSteps,
      title: 'onboarding.basicProfile.company.title',
      subtitle: null,
      buttonLabel: 'common.button.next',
      disabled: false,
      onPressed: () {
        context.pushNamed(OnboardingRoutes.age.name);
      },
      child: const SizedBox(
        width: double.infinity,
        child: DefaultCard(
          child: DefaultText('onboarding.basicProfile.company.placeholder'),
        ),
      ),
    );
  }
}

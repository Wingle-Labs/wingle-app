import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/features/onboarding/presentation/components/input/basic_profile_height_input.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/basic_profile_input_scaffold.dart';
import 'package:wingle/features/onboarding/presentation/constants/basic_profile_input_constants.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_height_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 기본 프로필 입력의 키 입력 페이지.
class BasicProfileHeightPage extends ConsumerWidget {
  /// 생성자
  const BasicProfileHeightPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = ref.watch(basicProfileHeightProvider);
    final notifier = ref.read(basicProfileHeightProvider.notifier);

    return BasicProfileInputScaffold(
      currentStep: BasicProfileInputConstants.heightStep,
      totalSteps: BasicProfileInputConstants.totalSteps,
      title: 'onboarding.basicProfile.height.title',
      subtitle: null,
      buttonLabel: 'common.button.next',
      disabled: height.length != 3,
      onPressed: () {
        context.pushNamed(OnboardingRoutes.age.name);
      },
      child: BasicProfileHeightInput(
        initialValue: height,
        onChanged: notifier.update,
      ),
    );
  }
}

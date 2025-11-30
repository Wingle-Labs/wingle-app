import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/features/auth/presentation/social_buttons.dart';

/// Onboarding 페이지
class OnboardingPage extends ConsumerStatefulWidget {
  /// 초기 화면으로 사용자에게 앱을 소개하는 페이지
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .spaceEvenly,
          children: [
            SizedBox(),
            SizedBox(
              width: AppContainerSize.wrap,
              height: AppContainerSize.wrap,
              child: Center(
                child: Text(
                  "Wingle - 가치관으로 만나다.",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            SocialAuthButtons(context: context),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}

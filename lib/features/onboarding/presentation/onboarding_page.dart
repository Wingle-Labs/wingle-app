import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/features/onboarding/presentation/components/button/phone_login_button.dart';
import 'package:wingle/features/onboarding/presentation/components/button/signup_button.dart';

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
    final theme = Theme.of(context);

    return ConstrainedScrollableScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Container(
            width: AppContainerSize.wrap,
            height: AppContainerSize.wrap,
            margin: .only(bottom: AppSpacing.xl),
            child: Placeholder(),
          ),
          Spacer(),
          PhoneLoginButton(),
          Padding(
            padding: .only(top: AppSpacing.sm),
            child: Text(
              "or",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ),
          SignupButton(),
          const SizedBox(height: AppSpacing.md, width: double.infinity),
        ],
      ),
    );
  }
}

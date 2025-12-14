import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/features/onboarding/presentation/components/phone_login_button.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// Onboarding 페이지
class OnboardingPage extends ConsumerStatefulWidget {
  /// 초기 화면으로 사용자에게 앱을 소개하는 페이지
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  @override
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight, // 화면 높이만큼 보장
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(AppPadding.scaffold),
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
                      TextButton(
                        onPressed: () => context.pushNamed(
                          OnboardingRoutes.requiredSelfIntro.name,
                        ),
                        child: Text('onboarding.button.signUp'.tr()),
                      ),

                      const SizedBox(
                        height: AppSpacing.md,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

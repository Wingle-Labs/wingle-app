import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/constants/route_constants.dart';
import 'package:wingle/features/auth/presentation/components/social_buttons.dart';

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
                      const SizedBox(height: AppSpacing.xl),
                      Spacer(),
                      SizedBox(
                        width: AppContainerSize.wrap,
                        height: AppContainerSize.wrap,
                        child: Center(
                          child: Text(
                            "onboarding.title".tr(),
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                      ),

                      SocialAuthButtons(context: context),
                      TextButton(
                        onPressed: () => context.push(
                          AppRoutes.fullPath([
                            AppRoutes.onboarding,
                            AppRoutes.requiredSelfIntro,
                          ]),
                        ),
                        child: Text('onboarding.button.phone'.tr()),
                      ),

                      const SizedBox(
                        height: AppSpacing.xl,
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

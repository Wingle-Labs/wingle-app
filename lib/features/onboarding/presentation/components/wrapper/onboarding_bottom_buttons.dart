import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/features/onboarding/presentation/components/button/phone_login_button.dart';
import 'package:wingle/features/onboarding/presentation/components/button/signup_button.dart';
import 'package:wingle/features/onboarding/presentation/providers/carousel_index_provider.dart';

/// Onboarding 페이지의 하단 버튼
/// 마지막 페이지일 경우 다음 버튼, 그렇지 않을 경우 회원가입, 로그인 버튼
class OnboardingBottomButtons extends ConsumerWidget {
  /// CarouselSliderController
  final CarouselSliderController controller;

  /// 마지막 페이지 여부
  final bool isLastPage;

  /// const 생성자
  const OnboardingBottomButtons({
    super.key,
    required this.controller,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return !isLastPage
        ? Column(
            children: [
              SizedBox(height: AppContainerSize.buttonMinimun),
              SizedBox(height: AppSpacing.s8),
              SizedBox(
                // height: AppContainerSize.xl,
                width: double.infinity,
                child: DefaultFilledButton(
                  label: 'onboarding.button.next',
                  onPressed: () {
                    ref.read(onboardingCarouselProvider.notifier).next();
                  },
                  variant: .fullWidth,
                ),
              ),
            ],
          )
        : Column(
            children: [
              PhoneLoginButton(),
              SizedBox(height: AppSpacing.s8),
              SignupButton(),
            ],
          );
  }
}

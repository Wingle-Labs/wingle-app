import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/constants/color.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 휴대폰 번호 로그인 버튼
class PhoneLoginButton extends ConsumerWidget {
  /// const 생성자
  const PhoneLoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return FilledButton(
      onPressed: () => context.pushNamed(OnboardingRoutes.login.name),
      style: FilledButton.styleFrom(
        backgroundColor: theme.primaryColor,
        padding: .all(AppPadding.button),
        shape: RoundedRectangleBorder(borderRadius: .circular(AppRadius.md)),
      ),
      child: Row(
        mainAxisAlignment: .start,
        children: [
          IconTheme(
            data: IconThemeData(
              color: theme.colorScheme.onPrimary,
              size: AppIconSize.large,
              applyTextScaling: true,
            ),
            child: Icon(Icons.call, color: AppColor.darkButtonText),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: .symmetric(horizontal: AppPadding.button),
                child: Text(
                  "onboarding.button.phone".tr(),
                  style: TextStyle(
                    fontSize: AppFontSize.medium,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

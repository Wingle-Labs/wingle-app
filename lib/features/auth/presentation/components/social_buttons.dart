import 'package:colorful_iconify_flutter/icons/logos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:wingle/app/config/theme/components/bottons/social_login_button.dart';
import 'package:wingle/app/config/theme/constants/color.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/constants/route_constants.dart';
import 'package:wingle/features/auth/data/datasources/apple_api.dart';
import 'package:wingle/features/auth/data/datasources/google_api.dart';
import 'package:wingle/features/auth/data/datasources/kakao_api.dart';

/// 소셜 로그인 버튼 구성 모델
class SocialButtonConfig {
  /// 버튼에 표시할 아이콘
  final Widget symbol;

  /// 아이콘의 색상
  final Color symbolColor;

  /// 버튼의 배경색
  final Color? bgColor;

  /// 버튼에 표시할 텍스트
  final String text;

  /// 버튼 텍스트 색상
  final Color textColor;

  /// 버튼 텍스트 색상
  final bool outlined;

  /// 테두리 버튼의 색상
  final Color? borderColor;

  /// 버튼을 눌렀을 때 호출되는 콜백 함수
  final Future<void> Function() onPressed;

  /// 생성자
  const SocialButtonConfig({
    required this.symbol,
    required this.symbolColor,
    this.bgColor,
    required this.text,
    required this.textColor,
    required this.onPressed,
    this.outlined = false,
    this.borderColor,
  });
}

/// 소셜 로그인 버튼 그룹
class SocialAuthButtons extends ConsumerWidget {
  /// 생성자
  const SocialAuthButtons({super.key, required this.context});

  /// BuildContext
  final BuildContext context;

  List<SocialButtonConfig> _configs() {
    return [
      SocialButtonConfig(
        symbol: Iconify(
          Bx.bxs_message_rounded,
          color: AppColor.lightButtonText,
          size: AppIconSize.large,
        ),
        symbolColor: AppColor.lightButtonText,
        bgColor: AppColor.kakao,
        text: "onboarding.button.kakao".tr(),
        textColor: AppColor.lightButtonText,
        onPressed: () => KakaoApiManager.instance.getTokenWithLogin(),
      ),
      SocialButtonConfig(
        symbol: Iconify(Logos.google_icon),
        symbolColor: AppColor.lightButtonText,
        bgColor: AppColor.google,
        text: "onboarding.button.google".tr(),
        textColor: AppColor.lightButtonText,
        outlined: true,
        borderColor: AppColor.googleOutlinedButtonBorder,
        onPressed: () => GoogleApiManager.instance.signIn(),
      ),
      SocialButtonConfig(
        symbol: Iconify(Ic.baseline_apple, color: AppColor.darkButtonText),
        symbolColor: AppColor.darkButtonText,
        bgColor: AppColor.apple,
        text: "onboarding.button.apple".tr(),
        textColor: AppColor.darkButtonText,
        outlined: true,
        borderColor: AppColor.appleOutlinedButtonBorder,
        onPressed: () => AppleApiManager.signIn(),
      ),
      SocialButtonConfig(
        symbol: const Icon(Icons.call, color: AppColor.darkButtonText),
        symbolColor: AppColor.darkButtonText,
        text: "onboarding.button.phone".tr(),
        textColor: AppColor.darkButtonText,
        onPressed: () async => context.go(
          AppRoutes.fullPath([AppRoutes.onboarding, AppRoutes.phone]),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = _configs();

    return SizedBox(
      width: AppContainerSize.wrap,
      child: Column(
        spacing: AppSpacing.sm,
        children: [
          for (final c in items)
            SocialLoginButton(
              symbol: c.symbol,
              symbolColor: c.symbolColor,
              bgColor: c.bgColor,
              text: c.text,
              textColor: c.textColor,
              outlined: c.outlined,
              borderColor: c.borderColor,
              onPressed: () async => c.onPressed(),
            ),
        ],
      ),
    );
  }
}

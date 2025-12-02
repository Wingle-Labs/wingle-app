import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/bottons/loadding_text_button.dart';
import 'package:wingle/app/config/theme/components/cards/default_card.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/components/wrappers/smooth_rect.dart';
import 'package:wingle/app/config/theme/constants/color.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/constants/route_constants.dart';
import 'package:wingle/features/auth/presentation/phone_otp_textfield.dart';

/// 전화번호 인증 페이지
class PhoneOtpPage extends ConsumerStatefulWidget {
  /// 생성자
  const PhoneOtpPage({super.key});

  @override
  ConsumerState<PhoneOtpPage> createState() => _PhoneOtpPageState();
}

class _PhoneOtpPageState extends ConsumerState<PhoneOtpPage> {
  @override
  Widget build(BuildContext context) {
    return ScrollableScaffold(
      title: 'onboarding.phone.otp.title',
      body: <Widget>[
        Padding(
          padding: .symmetric(vertical: AppSpacing.xl),
          child: Text(
            'onboarding.phone.otp.instruction'.tr(),
            style: TextStyle(fontSize: AppFontSize.xl),
          ),
        ),
        DefaultCard(child: PhoneOtpTextField()),
      ],
      floatingActionButton: SmoothRectWrapper(
        child: FloatingActionButton.extended(
          backgroundColor: AppColor.primary,
          extendedPadding: .zero,
          onPressed: () {
            context.push(
              AppRoutes.fullPath([AppRoutes.onboarding, AppRoutes.age]),
            );
          },
          label: LoadingTextButton(
            label: 'onboarding.phone.otp.button.done'.tr(),
            isLoading: false,
          ),
        ),
      ),
    );
  }
}

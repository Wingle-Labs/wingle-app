import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/bottons/loadding_text_button.dart';
import 'package:wingle/app/config/theme/components/cards/default_card.dart';
import 'package:wingle/app/config/theme/components/wrappers/smooth_rect.dart';
import 'package:wingle/app/config/theme/constants/color.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text('onboarding.phone.otp.title'.tr())),
      body: Padding(
        padding: EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Spacer(),
            Column(
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.lg),
                  child: Text(
                    'onboarding.phone.otp.instruction'.tr(),
                    style: TextStyle(fontSize: AppFontSize.large),
                  ),
                ),
                DefaultCard(child: PhoneOtpTextField()),
              ],
            ),
            Spacer(),
            Spacer(),
          ],
        ),
      ),
      floatingActionButton: SmoothRectWrapper(
        child: FloatingActionButton.extended(
          backgroundColor: AppColor.primary,
          extendedPadding: EdgeInsets.zero,
          onPressed: () {},
          label: LoadingTextButton(
            label: 'onboarding.phone.otp.button.done'.tr(),
            isLoading: false,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

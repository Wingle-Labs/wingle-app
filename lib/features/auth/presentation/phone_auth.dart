import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/app/config/theme/components/bottons/loadding_text_button.dart';
import 'package:wingle/app/config/theme/components/cards/default_card.dart';
import 'package:wingle/app/config/theme/components/wrappers/smooth_rect.dart';
import 'package:wingle/app/config/theme/constants/color.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/constants/route_constants.dart';
import 'package:wingle/features/auth/presentation/phone_textfield.dart';

part 'phone_auth.g.dart';

@riverpod
/// 로딩 상태
class IsLoading extends _$IsLoading {
  @override
  bool build() {
    return false;
  }

  /// 로딩 상태를 토글합니다.
  void toggle() {
    state = !state;
  }
}

/// 전화번호 인증 페이지
class PhoneAuthPage extends ConsumerStatefulWidget {
  /// 생성자
  const PhoneAuthPage({super.key});

  @override
  ConsumerState<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends ConsumerState<PhoneAuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('onboarding.phone.title'.tr())),
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
                    'onboarding.phone.instruction'.tr(),
                    style: TextStyle(fontSize: AppFontSize.large),
                  ),
                ),
                DefaultCard(child: PhoneTextField()),
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
          onPressed: () {
            ref.read(isLoadingProvider.notifier).toggle();
            context.go(
              AppRoutes.fullPath([
                AppRoutes.onboarding,
                AppRoutes.phone,
                AppRoutes.otp,
              ]),
            );
          },
          label: LoadingTextButton(
            label: 'onboarding.phone.button'.tr(),
            isLoading: ref.watch(isLoadingProvider),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

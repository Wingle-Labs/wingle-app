import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/app/config/theme/components/bottons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/cards/default_card.dart';
import 'package:wingle/app/config/theme/components/texts/default_intruction.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';
import 'package:wingle/common/constants/route_constants.dart';
import 'package:wingle/features/auth/presentation/components/phone_textfield.dart';

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
    return ScrollableScaffold(
      title: 'onboarding.phone.title',
      body: <Widget>[
        DefaultInstruction('onboarding.phone.instruction'),
        DefaultCard(child: PhoneTextField()),
      ],
      floatingActionButton: DefaultFloatingButton(
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
        label: 'onboarding.phone.button',
        isLoading: ref.watch(isLoadingProvider),
      ),
    );
  }
}

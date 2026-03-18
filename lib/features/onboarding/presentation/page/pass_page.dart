import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/texts/default_intruction.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_scaffold.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// PASS 인증 안내 페이지
class PassPage extends ConsumerWidget {
  /// 생성자
  const PassPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = context.colors;
    final typography = context.typography;

    return DefaultScaffold(
      appBar: DefaultAppBar(),
      body: Center(
        child: Column(
          spacing: AppSpacing.textVerticalInternal,
          mainAxisAlignment: .center,
          children: [
            Spacer(),
            DefaultInstruction(
              '회원가입을 하려면\n본인 인증이 필요해요',
              textAlign: .center,
              padding: .zero,
            ),
            DefaultText(
              'PASS로 간편하게 인증하기',
              style: typography.bodySub,
              color: color.textAlternative,
              policy: .cappedLarge,
            ),
            SizedBox(height: AppSpacing.bottom),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: DefaultFloatingButton(
        label: "본인 인증 시작하기",
        onPressed: () => context.pushNamed(OnboardingRoutes.passWebView.name),
      ),
    );
  }
}

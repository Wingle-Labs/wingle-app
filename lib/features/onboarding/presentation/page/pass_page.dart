import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_scaffold.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// PASS 인증 안내 페이지
class PassPage extends ConsumerWidget {
  /// 생성자
  const PassPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef _) {
    return DefaultScaffold(
      appBar: DefaultAppBar(),
      body: Center(
        child: Column(
          spacing: AppSpacing.textVerticalInternal,
          mainAxisAlignment: .center,
          children: [
            Spacer(),
            const DefaultPageHeader(
              title: 'onboarding.pass.title',
              subtitle: 'onboarding.pass.subtitle',
              titleTextAlign: TextAlign.center,
              subtitleTextAlign: TextAlign.center,
              padding: EdgeInsets.zero,
            ),
            SizedBox(height: AppSpacing.bottom),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: DefaultFloatingButton(
        label: 'onboarding.pass.button.start',
        onPressed: () => context.pushNamed(OnboardingRoutes.passWebView.name),
      ),
    );
  }
}

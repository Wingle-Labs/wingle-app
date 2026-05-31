import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/cards/default_card.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/app/router/route_node.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/route/onboarding_route_chain.dart';

/// 아직 실제 입력 화면이 붙지 않은 온보딩 단계의 임시 목적지.
class OnboardingStatusPlaceholderPage extends StatelessWidget {
  /// 앱바 제목.
  final String title;

  /// 화면 설명.
  final String description;

  /// 표시할 BE onboardingStatus.
  final String status;

  /// 이 placeholder가 속한 온보딩 흐름.
  final OnboardingRouteFlow? routeFlow;

  /// 이 placeholder의 현재 라우트.
  final RouteNode? currentRoute;

  /// 생성자.
  const OnboardingStatusPlaceholderPage({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    this.routeFlow,
    this.currentRoute,
  }) : assert(
         (routeFlow == null) == (currentRoute == null),
         'routeFlow와 currentRoute는 함께 전달해야 합니다.',
       );

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final flow = routeFlow;
    final route = currentRoute;
    final canGoPrevious =
        flow != null &&
        route != null &&
        OnboardingRouteChain.previousOf(flow, route) != null;

    void navigatePrevious() {
      if (flow == null || route == null) return;

      OnboardingRouteChain.goPrevious(context, flow, route);
    }

    return PopScope(
      canPop: !canGoPrevious,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop || !canGoPrevious) return;
        navigatePrevious();
      },
      child: Scaffold(
        appBar: DefaultAppBar(
          title: title,
          isTitleTranslationKey: false,
          forceImplyLeading: canGoPrevious,
          onBackPressed: canGoPrevious ? navigatePrevious : null,
        ),
        backgroundColor: context.colors.backgroundNormal,
        body: SingleChildScrollView(
          padding: .all(AppPadding.scaffold),
          child: Column(
            crossAxisAlignment: .start,
            spacing: AppSpacing.s24,
            children: [
              DefaultPageHeader(
                title: title,
                subtitle: description,
                isTitleTranslationKey: false,
                isSubtitleTranslationKey: false,
              ),
              DefaultCard(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: AppSpacing.s8,
                  children: [
                    DefaultText(
                      '현재 온보딩 상태',
                      style: typography.bodySub,
                      isTranslationKey: false,
                    ),
                    DefaultText(
                      status,
                      style: typography.title,
                      isTranslationKey: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/cards/default_card.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 아직 실제 입력 화면이 붙지 않은 온보딩 단계의 임시 목적지.
class OnboardingStatusPlaceholderPage extends StatelessWidget {
  /// 앱바 제목.
  final String title;

  /// 화면 설명.
  final String description;

  /// 표시할 BE onboardingStatus.
  final String status;

  /// 생성자.
  const OnboardingStatusPlaceholderPage({
    super.key,
    required this.title,
    required this.description,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    return Scaffold(
      appBar: DefaultAppBar(title: title, isTitleTranslationKey: false),
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
    );
  }
}

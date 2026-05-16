import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_scaffold.dart';
import 'package:wingle/app/config/theme/components/wrappers/profile_input_app_bar.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// Wrapper/Scaffold 컴포넌트 프리뷰
class WrappersPage extends StatelessWidget {
  /// 생성자
  const WrappersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wrappers', style: typography.title),
            const SizedBox(height: 8),
            Text(
              'DefaultScaffold, ScrollableScaffold, '
              'ConstrainedScrollableScaffold, ProfileInputAppBar',
              style: typography.bodySub.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: 24),
            _WrapperFrame(
              title: 'DefaultScaffold',
              child: DefaultScaffold(
                appBar: const DefaultAppBar(
                  title: 'DefaultScaffold',
                  isTitleTranslationKey: false,
                ),
                body: const Center(
                  child: DefaultText(
                    '고정 화면용 기본 Scaffold',
                    isTranslationKey: false,
                  ),
                ),
                floatingActionButton: DefaultFloatingButton(
                  label: 'common.button.next',
                  onPressed: () {},
                ),
              ),
            ),
            _WrapperFrame(
              title: 'ScrollableScaffold',
              child: const ScrollableScaffold(
                title: 'designSystem.title',
                body: [
                  DefaultText('스크롤 가능한 화면을 구성합니다.', isTranslationKey: false),
                  DefaultText(
                    'body 리스트 간 spacing과 하단 여백을 관리합니다.',
                    isTranslationKey: false,
                  ),
                ],
              ),
            ),
            _WrapperFrame(
              title: 'ConstrainedScrollableScaffold',
              child: ConstrainedScrollableScaffold(
                appBar: const ProfileInputAppBar(
                  title: 'onboarding.profileInput.title',
                ),
                floatingActionButton: DefaultFloatingButton(
                  label: 'common.button.next',
                  onPressed: () {},
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultText(
                      '내용이 적어도 화면 최소 높이를 유지합니다.',
                      isTranslationKey: false,
                    ),
                    SizedBox(height: 16),
                    DefaultText(
                      '프로필 입력 흐름처럼 하단 버튼이 필요한 화면에 사용합니다.',
                      isTranslationKey: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WrapperFrame extends StatelessWidget {
  final String title;
  final Widget child;

  const _WrapperFrame({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: typography.main),
          const SizedBox(height: 12),
          Container(
            height: 420,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colors.backgroundNormal,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: colors.strokeStructuralBorder),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

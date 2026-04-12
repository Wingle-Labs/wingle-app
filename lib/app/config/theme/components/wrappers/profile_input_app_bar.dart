import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 프로필 입력 플로우에서 사용하는 고정 AppBar.
class ProfileInputAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// AppBar 제목
  final String title;

  /// 제목이 번역 키인지 여부
  final bool isTitleTranslationKey;

  /// 생성자
  const ProfileInputAppBar({
    super.key,
    this.title = 'onboarding.profileInput.title',
    this.isTitleTranslationKey = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    return DefaultAppBar(
      child: DefaultText(
        title,
        style: typography.main,
        isTranslationKey: isTitleTranslationKey,
      ),
    );
  }
}

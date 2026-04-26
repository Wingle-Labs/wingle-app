import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';

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
  Size get preferredSize => const DefaultAppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return DefaultAppBar(
      title: title,
      isTitleTranslationKey: isTitleTranslationKey,
    );
  }
}

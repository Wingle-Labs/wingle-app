import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';

/// 프로필 입력 플로우에서 사용하는 고정 AppBar.
class ProfileInputAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// AppBar 제목
  final String title;

  /// 제목이 번역 키인지 여부
  final bool isTitleTranslationKey;

  /// 뒤로가기 버튼 클릭 시 실행할 콜백
  final VoidCallback? onBackPressed;

  /// 이전 라우트가 없어도 뒤로가기 버튼을 강제로 표시할지 여부
  final bool forceBackButton;

  /// 우측 액션 위젯
  final Widget? trailing;

  /// 생성자
  const ProfileInputAppBar({
    super.key,
    this.title = 'onboarding.profileInput.title',
    this.isTitleTranslationKey = true,
    this.onBackPressed,
    this.forceBackButton = false,
    this.trailing,
  });

  @override
  Size get preferredSize => const DefaultAppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return DefaultAppBar(
      title: title,
      isTitleTranslationKey: isTitleTranslationKey,
      onBackPressed: onBackPressed,
      forceImplyLeading: forceBackButton,
      trailing: trailing,
      layout: trailing == null
          ? DefaultAppBarLayout.basic
          : DefaultAppBarLayout.side,
    );
  }
}

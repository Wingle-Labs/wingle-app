import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/states/step_indicator.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/components/wrappers/profile_input_app_bar.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 기본 프로필 입력 화면의 공통 레이아웃.
class BasicProfileInputScaffold extends StatelessWidget {
  /// 상단 진행 단계
  final int currentStep;

  /// 전체 단계 수
  final int totalSteps;

  /// 페이지 제목
  final String title;

  /// 페이지 부제목
  final String? subtitle;

  /// 본문 위젯
  final Widget child;

  /// 하단 버튼 라벨
  final String buttonLabel;

  /// 하단 버튼 클릭 콜백
  final VoidCallback? onPressed;

  /// 하단 버튼 로딩 여부
  final bool isLoading;

  /// 하단 버튼 비활성화 여부
  final bool disabled;

  /// 뒤로가기 가능 여부
  final bool canPop;

  /// 뒤로가기 버튼 클릭 시 실행할 콜백
  final VoidCallback? onBackPressed;

  /// 이전 라우트가 없어도 뒤로가기 버튼을 강제로 표시할지 여부
  final bool forceBackButton;

  /// 뒤로가기 시 콜백
  final void Function(bool didPop, Object? result)? onPopInvokedWithResult;

  /// 상단 AppBar 제목
  final String appBarTitle;

  /// 상단 AppBar 우측 액션
  final Widget? appBarTrailing;

  /// 하단 버튼 표시 여부
  final bool showFloatingButton;

  /// 생성자
  const BasicProfileInputScaffold({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.title,
    this.subtitle,
    required this.child,
    required this.buttonLabel,
    this.onPressed,
    this.isLoading = false,
    this.disabled = false,
    this.canPop = true,
    this.onBackPressed,
    this.forceBackButton = false,
    this.onPopInvokedWithResult,
    this.appBarTitle = 'onboarding.profileInput.title',
    this.appBarTrailing,
    this.showFloatingButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedScrollableScaffold(
      canPop: canPop,
      onPopInvokedWithResult: onPopInvokedWithResult,
      textScalePolicy: TextScalePolicy.cappedLarge,
      padding: EdgeInsets.zero,
      appBar: ProfileInputAppBar(
        title: appBarTitle,
        onBackPressed: onBackPressed,
        forceBackButton: forceBackButton,
        trailing: appBarTrailing,
      ),
      floatingActionButton: showFloatingButton
          ? DefaultFloatingButton(
              label: buttonLabel,
              isLoading: isLoading,
              disabled: disabled,
              onPressed: onPressed,
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepIndicator(
            currentStep: currentStep,
            totalSteps: totalSteps,
            padding: const EdgeInsets.only(
              top: AppSpacing.s32,
              left: AppPadding.scaffold,
              right: AppPadding.scaffold,
            ),
          ),
          DefaultPageHeader(
            title: title,
            subtitle: subtitle,
            titleStyle: context.typography.title,
            subtitleStyle: context.typography.bodySub,
            subtitleColor: context.colors.textAlternative,
            padding: const EdgeInsets.only(
              top: AppSpacing.s32,
              left: AppPadding.scaffold,
              right: AppPadding.scaffold,
              bottom: AppPadding.pageHeaderExternal,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.scaffold,
            ),
            child: child,
          ),
          const SizedBox(height: AppSpacing.bottom),
        ],
      ),
    );
  }
}

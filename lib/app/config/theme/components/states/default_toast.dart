import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/icons/default_icon.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/app/config/theme/elevation/app_elevation.dart';
import 'package:wingle/app/config/theme/elevation/implementations/light_elevation.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 기본 Snackbar/Toast 메시지 표시 클래스
class DefaultToast {
  /// 기본 표시 시간
  static const Duration defaultDuration = Duration(seconds: 2);

  /// Snackbar 메시지를 표시합니다.
  static void show(
    BuildContext context,
    String message, {
    Duration? duration,
    Widget? leading,
    String? actionLabel,
    VoidCallback? onAction,
    bool isTranslationKey = true,
    bool isActionTranslationKey = true,
    bool showCloseIcon = false,
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        content: DefaultToastContent(
          message: message,
          leading: leading,
          actionLabel: actionLabel,
          onAction: onAction == null
              ? null
              : () {
                  messenger.hideCurrentSnackBar();
                  onAction();
                },
          isTranslationKey: isTranslationKey,
          isActionTranslationKey: isActionTranslationKey,
          showCloseIcon: showCloseIcon,
          onClose: () => messenger.hideCurrentSnackBar(),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppPadding.horizontal),
        elevation: 0,
        padding: EdgeInsets.zero,
        duration: duration ?? defaultDuration,
      ),
    );
  }
}

/// Snackbar의 실제 표시 영역.
class DefaultToastContent extends StatelessWidget {
  /// 메시지
  final String message;

  /// 메시지 앞에 배치되는 아이콘/이미지
  final Widget? leading;

  /// 액션 버튼 라벨
  final String? actionLabel;

  /// 액션 버튼 콜백
  final VoidCallback? onAction;

  /// 메시지 번역 키 여부
  final bool isTranslationKey;

  /// 액션 라벨 번역 키 여부
  final bool isActionTranslationKey;

  /// 닫기 버튼 표시 여부
  final bool showCloseIcon;

  /// 닫기 버튼 콜백
  final VoidCallback? onClose;

  /// 생성자
  const DefaultToastContent({
    super.key,
    required this.message,
    this.leading,
    this.actionLabel,
    this.onAction,
    this.isTranslationKey = true,
    this.isActionTranslationKey = true,
    this.showCloseIcon = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.colors;
    final typography = context.typography;
    final elevation =
        Theme.of(context).extension<AppElevation>() ?? lightElevation;

    return Container(
      constraints: const BoxConstraints(
        minHeight: AppContainerSize.cardMinHeight,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.snackbarHorizontal,
        vertical: AppPadding.snackbarVertical,
      ),
      decoration: ShapeDecoration(
        color: color.backgroundElevatedNormal,
        shadows: elevation.strong,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.s12),
          ],
          Expanded(
            child: DefaultText(
              message,
              style: typography.mainSub,
              color: color.textStrong,
              isTranslationKey: isTranslationKey,
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(width: AppSpacing.textVerticalInternal),
            _DefaultToastAction(
              label: actionLabel!,
              onTap: onAction,
              isTranslationKey: isActionTranslationKey,
            ),
          ],
          if (showCloseIcon) ...[
            const SizedBox(width: AppSpacing.s8),
            IconButton(
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: AppIconSize.sm,
                height: AppIconSize.sm,
              ),
              iconSize: AppIconSize.sm,
              color: color.textNormal,
              icon: DefaultIcon(
                icon: Icons.close_rounded,
                size: AppIconSize.sm,
                color: color.textNormal,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DefaultToastAction extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isTranslationKey;

  const _DefaultToastAction({
    required this.label,
    required this.onTap,
    required this.isTranslationKey,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.colors;
    final typography = context.typography;

    return Material(
      color: color.secondaryNormal,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.snackbarActionHorizontal,
            vertical: AppPadding.snackbarActionVertical,
          ),
          child: DefaultText(
            label,
            style: typography.buttonSmall,
            color: color.onSecondaryNormal,
            isTranslationKey: isTranslationKey,
          ),
        ),
      ),
    );
  }
}

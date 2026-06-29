import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 로그인 화면 하단의 보조 액션 링크 그룹.
class LoginSecondaryActionGroup extends StatelessWidget {
  /// 생성자
  const LoginSecondaryActionGroup({super.key});

  static const double _actionHorizontalPadding = AppSpacing.s8;
  static const double _dividerHorizontalGap = AppSpacing.s12;
  static const double _wrapSpacing = AppSpacing.s12;
  static const double _wrapRunSpacing = AppSpacing.s4;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _LoginSecondaryActionSpec(
        label: 'onboarding.login.button.changePhoneNumber'.tr(),
        routeName: OnboardingRoutes.changePhoneNumber.name,
      ),
      _LoginSecondaryActionSpec(
        label: 'onboarding.login.button.reset-password'.tr(),
        routeName: OnboardingRoutes.phone.name,
      ),
      _LoginSecondaryActionSpec(
        label: 'onboarding.login.button.signUp'.tr(),
        routeName: OnboardingRoutes.agreement.name,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final fitsInOneLine =
            _measureRowWidth(context, actions) <= constraints.maxWidth;

        if (!fitsInOneLine) {
          return Wrap(
            alignment: WrapAlignment.center,
            spacing: _wrapSpacing,
            runSpacing: _wrapRunSpacing,
            children: [
              for (final action in actions)
                _LoginSecondaryAction(action: action),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < actions.length; index++) ...[
              if (index > 0) ...[
                const SizedBox(width: _dividerHorizontalGap),
                const _LoginSecondaryActionDivider(),
                const SizedBox(width: _dividerHorizontalGap),
              ],
              _LoginSecondaryAction(action: actions[index]),
            ],
          ],
        );
      },
    );
  }

  double _measureRowWidth(
    BuildContext context,
    List<_LoginSecondaryActionSpec> actions,
  ) {
    final typography = context.typography;
    final textScale = TextScalePolicy.cappedLarge.getScaleFactor(
      MediaQuery.textScalerOf(context).scale(1),
    );
    final style = typography.buttonSmall.copyWith(letterSpacing: 0);
    final textDirection = Directionality.of(context);
    final actionWidth = actions.fold<double>(0, (sum, action) {
      final painter = TextPainter(
        text: TextSpan(text: action.label, style: style),
        textDirection: textDirection,
        textScaler: TextScaler.linear(textScale),
        maxLines: 1,
      )..layout();

      return sum + painter.width + _actionHorizontalPadding * 2;
    });

    final dividerWidth =
        (actions.length - 1) *
        (_LoginSecondaryActionDivider.width + 2 * _dividerHorizontalGap);
    return actionWidth + dividerWidth;
  }
}

class _LoginSecondaryActionSpec {
  final String label;
  final String routeName;

  const _LoginSecondaryActionSpec({
    required this.label,
    required this.routeName,
  });
}

class _LoginSecondaryAction extends StatelessWidget {
  final _LoginSecondaryActionSpec action;

  const _LoginSecondaryAction({required this.action});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Semantics(
      button: true,
      label: action.label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          onTap: () => context.pushNamed(action.routeName),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return colors.overlayPressed;
            }
            if (states.contains(WidgetState.focused) ||
                states.contains(WidgetState.hovered)) {
              return colors.overlayInactive;
            }
            return null;
          }),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppIconTouchSize.md),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LoginSecondaryActionGroup._actionHorizontalPadding,
              ),
              child: Center(
                child: TextScaleWrapper(
                  policy: TextScalePolicy.cappedLarge,
                  child: Text(
                    action.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typography.buttonSmall.copyWith(
                      color: colors.textNeutral,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginSecondaryActionDivider extends StatelessWidget {
  static const double width = 1;

  const _LoginSecondaryActionDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: AppIconSize.xs,
      child: ColoredBox(color: context.colors.strokeStructuralDivider),
    );
  }
}

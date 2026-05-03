import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/buttons/default_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_outlined_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_text_button.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/widgetbook/components/buttons/button_preview_parts.dart';
import 'package:wingle/widgetbook/components/buttons/button_spec_resolver.dart';

/// 기본 버튼 컴포넌트 프리뷰
class BasicButtonPage extends StatefulWidget {
  /// 생성자
  const BasicButtonPage({super.key});

  @override
  State<BasicButtonPage> createState() => _BasicButtonPageState();
}

class _BasicButtonPageState extends State<BasicButtonPage> {
  static const double _panelWidth = 640;
  static const double _exampleWidth = 335;

  int _tapCount = 0;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final selectedVariant = context.knobs.object.dropdown<DefaultButtonVariant>(
      label: 'Variant',
      options: DefaultButtonVariant.values,
      labelBuilder: (variant) => variant.name,
      initialOption: DefaultButtonVariant.lg,
    );
    final selectedStatus = context.knobs.object.dropdown<DefaultButtonStatus>(
      label: 'Status',
      options: DefaultButtonStatus.values,
      labelBuilder: (status) => status.name,
      initialOption: DefaultButtonStatus.enabled,
    );
    final showLeading = context.knobs.object.dropdown<bool>(
      label: 'Leading',
      options: const [false, true],
      initialOption: false,
    );
    final showTrailing = context.knobs.object.dropdown<bool>(
      label: 'Trailing',
      options: const [false, true],
      initialOption: false,
    );
    final resolvedSpec = WidgetbookButtonSpecResolver.resolveBase(
      context: context,
      variant: selectedVariant,
      status: selectedStatus,
      visualSpec: DefaultButtonVisualSpec(
        backgroundColor: colors.backgroundAlternative,
        foregroundColor: colors.textNormal,
        pressedOverlayColor: colors.overlayPressed,
        borderSide: BorderSide(
          color: colors.strokeStructuralBorder,
          width: AppLineWidth.outline,
        ),
      ),
      backgroundToken: 'backgroundAlternative',
      foregroundToken: 'textNormal',
      borderToken: 'strokeStructuralBorder',
      pressedOverlayToken: 'overlayPressed',
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Button / Common', style: typography.title),
            const SizedBox(height: AppSpacing.s12),
            Text(
              'size, status, icon slot 같은 공통 프레임을 검증하는 베이스 버튼입니다.',
              style: typography.body.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: AppSpacing.s40),
            ButtonSpecPanel(
              width: _panelWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('사용 예시', style: typography.main),
                  const SizedBox(height: AppSpacing.s20),
                  ButtonSampleCard(
                    width: _exampleWidth,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: DefaultFilledButton(
                            label: '텍스트',
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        SizedBox(
                          width: double.infinity,
                          child: DefaultOutlinedButton(
                            label: '텍스트',
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  ButtonSampleCard(
                    width: _exampleWidth,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: DefaultOutlinedButton(
                            label: '텍스트',
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        SizedBox(
                          width: double.infinity,
                          child: DefaultOutlinedButton(
                            label: '텍스트',
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  ButtonSampleCard(
                    width: _exampleWidth,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: DefaultFilledButton(
                            label: '텍스트',
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        Align(
                          alignment: Alignment.center,
                          child: DefaultTextButton(
                            label: '텍스트',
                            foregroundColor: colors.textNeutral,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s40),
            ButtonSpecPanel(
              width: _panelWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('구성 / 간격 기준', style: typography.main),
                  const SizedBox(height: AppSpacing.s20),
                  ButtonSampleCard(
                    width: _exampleWidth,
                    child: SizedBox(
                      width: double.infinity,
                      child: DefaultFilledButton(
                        label: '텍스트',
                        onPressed: () {},
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  ButtonSampleCard(
                    width: _exampleWidth,
                    child: Row(
                      children: [
                        Expanded(
                          child: DefaultOutlinedButton(
                            label: '텍스트',
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        Expanded(
                          child: DefaultFilledButton(
                            label: '텍스트',
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  Text(
                    '높이 ${AppContainerSize.buttonHeight.toInt()}px, '
                    'radius ${AppRadius.iosStyle.toInt()}px, '
                    'padding ${AppPadding.buttonVertical.toInt()}px/'
                    '${AppPadding.buttonHorizontal.toInt()}px',
                    style: typography.bodySub.copyWith(
                      color: colors.textAlternative,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s40),
            ButtonSpecPanel(
              width: _panelWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('상태 표현', style: typography.main),
                  const SizedBox(height: AppSpacing.s20),
                  ButtonSampleCard(
                    width: _exampleWidth,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: DefaultFilledButton(
                            label: '텍스트',
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        ButtonPressedPreview(
                          borderRadius: AppRadius.iosStyleRadius,
                          child: DefaultFilledButton(
                            label: '텍스트',
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        SizedBox(
                          width: double.infinity,
                          child: DefaultFilledButton(
                            label: '텍스트',
                            isDisabled: true,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s40),
            ButtonSpecPanel(
              width: _panelWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('테스트', style: typography.main),
                  const SizedBox(height: AppSpacing.s20),
                  SizedBox(
                    width: _exampleWidth,
                    child: DefaultButton(
                      label: '텍스트',
                      variant: selectedVariant,
                      status: selectedStatus,
                      visualSpec: DefaultButtonVisualSpec(
                        backgroundColor: colors.backgroundAlternative,
                        foregroundColor: colors.textNormal,
                        pressedOverlayColor: colors.overlayPressed,
                        borderSide: BorderSide(
                          color: colors.strokeStructuralBorder,
                          width: AppLineWidth.outline,
                        ),
                      ),
                      leading: showLeading ? Icons.favorite : null,
                      trailing: showTrailing ? Icons.chevron_right : null,
                      onPressed: () => setState(() => _tapCount++),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Text('클릭 횟수: $_tapCount', style: typography.body),
                  const SizedBox(height: AppSpacing.s12),
                  Text(
                    'variant: ${selectedVariant.name}, '
                    'status: ${selectedStatus.name}',
                    style: typography.bodySub.copyWith(
                      color: colors.textAlternative,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  ButtonResolvedSpecCard(spec: resolvedSpec),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

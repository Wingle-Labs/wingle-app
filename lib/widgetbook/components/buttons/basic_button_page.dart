import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_outlined_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_text_button.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

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
    final disabled = context.knobs.object.dropdown<bool>(
      label: 'Disabled',
      options: const [false, true],
      initialOption: false,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Button / Basic', style: typography.title),
            const SizedBox(height: AppSpacing.s12),
            Text(
              '명확하게 권장하는 행동을 표현하는 기본 버튼입니다.',
              style: typography.body.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: AppSpacing.s40),
            _SpecPanel(
              width: _panelWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('사용 예시', style: typography.main),
                  const SizedBox(height: AppSpacing.s20),
                  _MessageCard(
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
                  _MessageCard(
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
                  _MessageCard(
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
            _SpecPanel(
              width: _panelWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('구성 / 간격 기준', style: typography.main),
                  const SizedBox(height: AppSpacing.s20),
                  _MessageCard(
                    child: SizedBox(
                      width: double.infinity,
                      child: DefaultFilledButton(
                        label: '텍스트',
                        onPressed: () {},
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  _MessageCard(
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
            _SpecPanel(
              width: _panelWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('상태 표현', style: typography.main),
                  const SizedBox(height: AppSpacing.s20),
                  _MessageCard(
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
                        _PressedPreview(
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
            _SpecPanel(
              width: _panelWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('테스트', style: typography.main),
                  const SizedBox(height: AppSpacing.s20),
                  SizedBox(
                    width: _exampleWidth,
                    child: DefaultFilledButton(
                      label: '텍스트',
                      isDisabled: disabled,
                      onPressed: () => setState(() => _tapCount++),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Text('클릭 횟수: $_tapCount', style: typography.body),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecPanel extends StatelessWidget {
  final double width;
  final Widget child;

  const _SpecPanel({required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: width,
      padding: const EdgeInsets.all(AppPadding.card),
      decoration: BoxDecoration(
        color: colors.backgroundAlternative,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: child,
    );
  }
}

class _MessageCard extends StatelessWidget {
  final Widget child;

  const _MessageCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: _BasicButtonPageState._exampleWidth,
      padding: const EdgeInsets.all(AppPadding.horizontal),
      decoration: BoxDecoration(
        color: colors.backgroundNormal,
        border: Border.all(color: colors.strokeStructuralBorder),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: child,
    );
  }
}

class _PressedPreview extends StatelessWidget {
  final Widget child;

  const _PressedPreview({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      children: [
        SizedBox(width: double.infinity, child: child),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.overlayPressed,
                borderRadius: AppRadius.iosStyleRadius,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

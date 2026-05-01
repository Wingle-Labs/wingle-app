import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/buttons/default_full_width_button.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// Full Width Button 컴포넌트 프리뷰
class FullWidthButtonPage extends StatefulWidget {
  /// 생성자
  const FullWidthButtonPage({super.key});

  @override
  State<FullWidthButtonPage> createState() => _FullWidthButtonPageState();
}

class _FullWidthButtonPageState extends State<FullWidthButtonPage> {
  static const double _panelWidth = 640;
  static const double _exampleWidth = 343;
  static const double _compactWidth = 168;

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
    final showLeading = context.knobs.object.dropdown<bool>(
      label: 'Leading Icon',
      options: const [true, false],
      initialOption: true,
    );
    final showTrailing = context.knobs.object.dropdown<bool>(
      label: 'Trailing Icon',
      options: const [true, false],
      initialOption: true,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Button / Full Width', style: typography.title),
            const SizedBox(height: AppSpacing.s12),
            Text(
              '화면의 주요 액션을 강조하고 레이아웃 단위에서 일관된 정렬을 '
              '유지할 때 사용합니다.',
              style: typography.body.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: AppSpacing.s40),
            _SpecPanel(
              width: _panelWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('사용 가능한 속성', style: typography.main),
                  const SizedBox(height: AppSpacing.s20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _SampleCard(
                        child: Column(
                          children: [
                            DefaultFullWidthButton(
                              label: '텍스트',
                              leadingWidget: const _ButtonIconPlaceholder(),
                              trailingWidget: const _ButtonIconPlaceholder(),
                              onPressed: () {},
                            ),
                            const SizedBox(height: AppSpacing.s16),
                            Center(
                              child: DefaultFullWidthButton(
                                width: _compactWidth,
                                label: '텍스트',
                                leadingWidget: const _ButtonIconPlaceholder(),
                                trailingWidget: const _ButtonIconPlaceholder(),
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s16),
                            DefaultFullWidthButton(
                              label: '텍스트',
                              leadingWidget: const _ButtonIconPlaceholder(),
                              trailingWidget: const _ButtonIconPlaceholder(),
                              isDisabled: true,
                              onPressed: () {},
                            ),
                            const SizedBox(height: AppSpacing.s16),
                            Center(
                              child: DefaultFullWidthButton(
                                width: _compactWidth,
                                label: '텍스트',
                                leadingWidget: const _ButtonIconPlaceholder(),
                                trailingWidget: const _ButtonIconPlaceholder(),
                                isDisabled: true,
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s40),
                      Expanded(
                        child: Text(
                          '가로값 고정\nVariant\n하위 Instance',
                          style: typography.body,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s40),
            const Divider(color: Colors.black),
            const SizedBox(height: AppSpacing.s32),
            Text('대표 예시', style: typography.subtitle),
            const SizedBox(height: AppSpacing.s24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _LetterCard(
                  child: DefaultFullWidthButton(label: '확인', onPressed: () {}),
                ),
                const SizedBox(width: AppSpacing.s40),
                Expanded(
                  child: Text(
                    '일반적으로 생각하는 CTA 버튼 목적으로 사용해요.',
                    style: typography.body,
                  ),
                ),
              ],
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
                    child: DefaultFullWidthButton(
                      label: '텍스트',
                      isDisabled: disabled,
                      leadingWidget: showLeading
                          ? const _ButtonIconPlaceholder()
                          : null,
                      trailingWidget: showTrailing
                          ? const _ButtonIconPlaceholder()
                          : null,
                      onPressed: () => setState(() => _tapCount++),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  Text('클릭 횟수: $_tapCount', style: typography.body),
                  const SizedBox(height: AppSpacing.s12),
                  Text(
                    '높이 ${AppContainerSize.buttonHeight.toInt()}px, '
                    'radius ${AppRadius.iosStyle.toInt()}px, '
                    'padding ${AppPadding.fullWidthButtonVertical.toInt()}px/'
                    '${AppPadding.fullWidthButtonHorizontal.toInt()}px, '
                    'gap ${AppSpacing.buttonInternal.toInt()}px',
                    style: typography.bodySub.copyWith(
                      color: colors.textAlternative,
                    ),
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

class _ButtonIconPlaceholder extends StatelessWidget {
  const _ButtonIconPlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.buttonIconSlot),
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

class _SampleCard extends StatelessWidget {
  final Widget child;

  const _SampleCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: _FullWidthButtonPageState._exampleWidth,
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

class _LetterCard extends StatelessWidget {
  final Widget child;

  const _LetterCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Container(
      width: _FullWidthButtonPageState._exampleWidth,
      padding: const EdgeInsets.all(AppPadding.horizontal),
      decoration: BoxDecoration(
        color: colors.backgroundNormal,
        border: Border.all(color: colors.strokeStructuralBorder),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '신에게로 옮겨진 이 편지는 2주 뒤에 당신 곁을 떠나야 '
            '합니다. 이 편지를 포함해서 7통을 행운이 필요한 구성원에게 '
            '보내주셔야 합니다.',
            style: typography.bodySub.copyWith(color: colors.textAlternative),
          ),
          const SizedBox(height: AppSpacing.s16),
          child,
        ],
      ),
    );
  }
}

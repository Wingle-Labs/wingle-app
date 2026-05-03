import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/buttons/default_checkbox.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_icon_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_outlined_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_text_button.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 버튼 컴포넌트 프리뷰
class ButtonsPage extends StatefulWidget {
  /// 생성자
  const ButtonsPage({super.key});

  @override
  State<ButtonsPage> createState() => _ButtonsPageState();
}

class _ButtonsPageState extends State<ButtonsPage> {
  bool _isChecked = true;
  bool _isFloatingLoading = false;

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
      options: const [false, true],
      initialOption: false,
    );
    final showTrailing = context.knobs.object.dropdown<bool>(
      label: 'Trailing Icon',
      options: const [false, true],
      initialOption: false,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Buttons', style: typography.title),
            const SizedBox(height: 8),
            Text(
              'DefaultFilledButton, DefaultOutlinedButton, DefaultTextButton, '
              'DefaultFloatingButton, DefaultIconButton, DefaultCheckbox',
              style: typography.bodySub.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: 24),
            _PreviewSection(
              title: 'DefaultFilledButton',
              child: DefaultFilledButton(
                label: 'designSystem.button.filled.enabled',
                isDisabled: disabled,
                leadingIcon: showLeading ? Icons.add_rounded : null,
                trailingIcon: showTrailing ? Icons.arrow_forward_rounded : null,
                onPressed: () {},
              ),
            ),
            _PreviewSection(
              title: 'DefaultOutlinedButton',
              child: DefaultOutlinedButton(
                label: 'designSystem.button.outlined.enabled',
                isDisabled: disabled,
                leadingIcon: showLeading ? Icons.add_rounded : null,
                trailingIcon: showTrailing ? Icons.arrow_forward_rounded : null,
                onPressed: () {},
              ),
            ),
            _PreviewSection(
              title: 'DefaultTextButton',
              child: DefaultTextButton(
                label: 'designSystem.button.text.enabled',
                isDisabled: disabled,
                leadingIcon: showLeading ? Icons.add_rounded : null,
                trailingIcon: showTrailing ? Icons.arrow_forward_rounded : null,
                onPressed: () {},
              ),
            ),
            _PreviewSection(
              title: 'DefaultFloatingButton',
              child: Stack(
                children: [
                  Container(
                    height: 124,
                    decoration: BoxDecoration(
                      color: colors.backgroundAlternative,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 16,
                    child: DefaultFloatingButton(
                      label: 'common.button.next',
                      disabled: disabled,
                      isLoading: _isFloatingLoading,
                      onPressed: () {
                        setState(() {
                          _isFloatingLoading = !_isFloatingLoading;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            _PreviewSection(
              title: 'DefaultIconButton',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  DefaultIconButton(
                    size: AppIconSize.sm,
                    isEnabled: !disabled,
                    icon: const Icon(Icons.favorite_border_rounded),
                    onPressed: () {},
                  ),
                  DefaultIconButton(
                    size: AppIconSize.md,
                    isEnabled: !disabled,
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: () {},
                  ),
                  DefaultIconButton(
                    size: AppIconSize.xl,
                    isEnabled: !disabled,
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            _PreviewSection(
              title: 'DefaultCheckbox',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultCheckbox(
                    isChecked: _isChecked,
                    isDisabled: disabled,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  Text('checked: $_isChecked', style: typography.body),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _PreviewSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: typography.main),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.backgroundNormal,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.strokeStructuralBorder),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

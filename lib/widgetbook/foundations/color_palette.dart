import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/color/color_palette.dart'
    as theme_palette;
import 'package:wingle/app/config/theme/color/registry/enum_title.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/app/config/theme/constants/weight.dart';

/// 팔레트 토큰을 확인할 수 있는 페이지
class ColorPalettePage extends StatelessWidget {
  /// 생성자
  const ColorPalettePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppPadding.scaffold),
      children: [
        const Text(
          'lib/app/config/theme/color/color_palette.dart에 정의된 실제 팔레트 토큰입니다.',
        ),
        const SizedBox(height: AppSpacing.s24),
        ...theme_palette.AppPaletteGroup.values.map(_buildPaletteSection),
      ],
    );
  }

  Widget _buildPaletteSection(theme_palette.AppPaletteGroup group) {
    if (group == theme_palette.AppPaletteGroup.opacities) {
      return _OpacitySection(
        title: group.title,
        opacities: theme_palette.AppColorPalette.opacities,
      );
    }

    final tokens = theme_palette.AppColorPalette.groupBy(group);
    if (tokens.isEmpty) {
      return const SizedBox.shrink();
    }

    return _PaletteSection(
      title: group.title,
      children: tokens
          .map(
            (token) => _ColorTokenCard(
              name: token.name,
              valueLabel: _hex(token.color),
              color: token.color,
            ),
          )
          .toList(),
    );
  }

  static String _hex(Color color) {
    final value = color.toARGB32().toRadixString(16).padLeft(8, '0');
    return '#${value.toUpperCase()}';
  }
}

class _PaletteSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _PaletteSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppPadding.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: AppFontSize.main,
              fontWeight: AppFontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Wrap(
            spacing: AppSpacing.s16,
            runSpacing: AppSpacing.s16,
            children: children,
          ),
        ],
      ),
    );
  }
}

class _ColorTokenCard extends StatelessWidget {
  final String name;
  final String valueLabel;
  final Color color;

  const _ColorTokenCard({
    required this.name,
    required this.valueLabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final foreground =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black;

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 220),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: AppRadius.iosStyleRadius,
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 72,
              padding: const EdgeInsets.all(AppPadding.card),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              alignment: Alignment.bottomLeft,
              child: Text(
                valueLabel,
                style: TextStyle(
                  color: foreground,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppPadding.card),
              child: Text(
                name,
                style: const TextStyle(fontSize: AppFontSize.caption),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpacitySection extends StatelessWidget {
  final String title;
  final List<double> opacities;

  const _OpacitySection({required this.title, required this.opacities});

  @override
  Widget build(BuildContext context) {
    return _PaletteSection(
      title: title,
      children: opacities
          .map(
            (opacity) => _ColorTokenCard(
              name: 'opacity-${(opacity * 100).round()}',
              valueLabel: opacity.toStringAsFixed(2),
              color: Colors.black.withValues(alpha: opacity),
            ),
          )
          .toList(),
    );
  }
}

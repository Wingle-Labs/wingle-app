import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/color/app_color_scheme.dart';
import 'package:wingle/app/config/theme/color/color_token_specs.dart';
import 'package:wingle/app/config/theme/color/dark_color_scheme.dart';
import 'package:wingle/app/config/theme/color/light_color_scheme.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/app/config/theme/constants/weight.dart';

/// 시맨틱 컬러 스킴을 확인할 수 있는 페이지
class ColorSemanticPage extends StatelessWidget {
  /// 생성자
  const ColorSemanticPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppPadding.scaffold),
      children: [
        const Text(
          'lib/app/config/theme/color/light_color_scheme.dart와 '
          'dark_color_scheme.dart의 실제 시맨틱 컬러를 표시합니다.',
        ),
        const SizedBox(height: AppSpacing.md),
        ...AppColorSemanticSection.values.map(
          (section) => _SemanticSection(
            title: section.title,
            items: AppColorTokenSpec.values
                .where((spec) => spec.section == section)
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _SemanticSection extends StatelessWidget {
  final String title;
  final List<AppColorTokenSpec> items;

  const _SemanticSection({required this.title, required this.items});

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
          const SizedBox(height: AppSpacing.sm),
          ...items.map(
            (item) => _SemanticColorRow(
              name: item.title,
              light: _resolve(item.resolve, const LightColorScheme()),
              dark: _resolve(item.resolve, const DarkColorScheme()),
            ),
          ),
        ],
      ),
    );
  }

  _ResolvedColor _resolve(
    AppColorTokenResolver resolve,
    AppColorScheme scheme,
  ) {
    try {
      return _ResolvedColor.color(resolve(scheme));
    } on UnimplementedError {
      return const _ResolvedColor.unimplemented();
    }
  }
}

class _SemanticColorRow extends StatelessWidget {
  final String name;
  final _ResolvedColor light;
  final _ResolvedColor dark;

  const _SemanticColorRow({
    required this.name,
    required this.light,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppPadding.card),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppRadius.iosStyleRadius,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: AppFontWeight.bold)),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _SchemePreview(label: 'Light', resolved: light),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SchemePreview(label: 'Dark', resolved: dark),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SchemePreview extends StatelessWidget {
  final String label;
  final _ResolvedColor resolved;

  const _SchemePreview({required this.label, required this.resolved});

  @override
  Widget build(BuildContext context) {
    if (!resolved.isImplemented) {
      return Container(
        height: 88,
        padding: const EdgeInsets.all(AppPadding.card),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: AppRadius.iosStyleRadius,
        ),
        alignment: Alignment.centerLeft,
        child: Text('$label\nUnimplemented'),
      );
    }

    final color = resolved.color!;
    final foreground =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black;
    final hex =
        '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';

    return Container(
      height: 88,
      padding: const EdgeInsets.all(AppPadding.card),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.iosStyleRadius,
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: foreground),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(label, style: const TextStyle(fontWeight: AppFontWeight.bold)),
            Text(hex, style: const TextStyle(fontSize: AppFontSize.caption)),
          ],
        ),
      ),
    );
  }
}

class _ResolvedColor {
  final Color? color;
  final bool isImplemented;

  const _ResolvedColor.color(this.color) : isImplemented = true;

  const _ResolvedColor.unimplemented() : color = null, isImplemented = false;
}

import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/elevation/implementations/light_elevation.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// Elevation foundation을 확인할 수 있는 페이지
class ElevationPage extends StatelessWidget {
  /// 생성자
  const ElevationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final elevation = lightElevation;
    final typography = context.typography;
    final colors = context.colors;
    final tokens = [
      _ElevationToken('normal', elevation.normal),
      _ElevationToken('strong', elevation.strong),
      _ElevationToken('heavy', elevation.heavy),
      _ElevationToken('heavyUpside', elevation.heavyUpside),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Elevation', style: typography.title),
            const SizedBox(height: 8),
            Text(
              'Light theme elevation tokens',
              style: typography.bodySub.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: tokens
                  .map((token) => _ElevationCard(token: token))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ElevationToken {
  final String name;
  final List<BoxShadow> shadows;

  const _ElevationToken(this.name, this.shadows);
}

class _ElevationCard extends StatelessWidget {
  final _ElevationToken token;

  const _ElevationCard({required this.token});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return SizedBox(
      width: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 148,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.backgroundAlternative,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 112,
              height: 84,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.backgroundNormal,
                borderRadius: BorderRadius.circular(18),
                boxShadow: token.shadows,
              ),
              child: Text(token.name, style: typography.bodySub),
            ),
          ),
          const SizedBox(height: 16),
          Text(token.name, style: typography.main),
          const SizedBox(height: 8),
          ...token.shadows.indexed.map((entry) {
            final index = entry.$1 + 1;
            final shadow = entry.$2;

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                '#$index offset(${shadow.offset.dx}, ${shadow.offset.dy}) '
                'blur ${shadow.blurRadius}',
                style: typography.caption.copyWith(
                  color: colors.textAlternative,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

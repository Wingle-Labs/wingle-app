import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// Widgetbook에서 AppRadius를 확인할 수 있는 페이지
class RadiusPage extends StatelessWidget {
  /// 생성자
  const RadiusPage({super.key});

  static const _radiusTokens = [
    _RadiusToken('6px', AppRadius.checkboxRadius),
    _RadiusToken('8px', AppRadius.sm),
    _RadiusToken('16px', AppRadius.standard),
    _RadiusToken('18px', AppRadius.iosStyle),
    _RadiusToken('24px', AppRadius.xl),
  ];

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Radius', style: typography.title),
            const SizedBox(height: 72),
            Divider(color: colors.strokeNeutral),
            const SizedBox(height: 96),
            Text(
              '라운드는 6배수, 8배수 단위로 적용하며, 상황에 맞춰 유연하게 사용합니다.\n'
              '예외적으로 R값 조정이 필요할 경우 2배수 단위로 설정합니다.',
              style: typography.body.copyWith(color: colors.textNormal),
            ),
            const SizedBox(height: 56),
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth >= 1200
                    ? (constraints.maxWidth - AppSpacing.s32 * 4) / 5
                    : 320.0;

                return Wrap(
                  spacing: AppSpacing.s32,
                  runSpacing: AppSpacing.s32,
                  children: _radiusTokens
                      .map(
                        (token) => SizedBox(
                          width: itemWidth,
                          child: _RadiusTokenCard(token: token),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RadiusToken {
  final String label;
  final double value;

  const _RadiusToken(this.label, this.value);
}

class _RadiusTokenCard extends StatelessWidget {
  final _RadiusToken token;

  const _RadiusTokenCard({required this.token});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AspectRatio(
      aspectRatio: 1,
      child: ColoredBox(
        color: colors.backgroundAlternative,
        child: Center(
          child: SizedBox(
            width: 190,
            height: 190,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: -12,
                  top: -34,
                  child: _RadiusCallout(label: token.label),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.backgroundNormal,
                    borderRadius: BorderRadius.circular(token.value),
                    boxShadow: [
                      BoxShadow(
                        color: colors.elevationShadowStrong,
                        offset: const Offset(0, 12),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: const SizedBox.expand(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadiusCallout extends StatelessWidget {
  final String label;

  const _RadiusCallout({required this.label});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final accent = colors.statusNegative;

    return SizedBox(
      width: 58,
      height: 50,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 4,
            child: Text(
              label,
              style: typography.caption.copyWith(color: accent),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: CustomPaint(
              size: const Size(42, 30),
              painter: _RadiusGuidePainter(color: accent),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadiusGuidePainter extends CustomPainter {
  final Color color;

  const _RadiusGuidePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 12)
      ..quadraticBezierTo(0, 0, 12, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RadiusGuidePainter oldDelegate) {
    return color != oldDelegate.color;
  }
}

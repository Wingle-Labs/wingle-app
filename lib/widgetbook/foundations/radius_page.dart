import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';

/// Widgetbook에서 AppRadius를 확인할 수 있는 페이지
class RadiusPage extends StatelessWidget {
  /// 생성자
  const RadiusPage({super.key});

  Widget _buildRadiusBox(String label, BorderRadius radius) {
    return Column(
      children: [
        Container(
          width: AppContainerSize.large,
          height: AppContainerSize.large,
          decoration: BoxDecoration(color: Colors.blue, borderRadius: radius),
          child: Container(
            padding: const EdgeInsets.all(AppPadding.card),
            child: Center(
              child: Text(
                '${radius.bottomLeft.x}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(label),
      ],
    );
  }

  Widget _buildIosRadiusBox(String label, SmoothBorderRadius radius) {
    return Column(
      children: [
        Container(
          width: AppContainerSize.xl,
          height: AppContainerSize.xl,
          decoration: ShapeDecoration(
            color: Colors.blue,
            shape: SmoothRectangleBorder(borderRadius: radius),
          ),
          child: Container(
            padding: const EdgeInsets.all(AppPadding.card),
            child: Center(
              child: Text(
                """radius: ${radius.bottomLeft.x}\nsmoothing: ${radius.bottomLeft.cornerSmoothing}""",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              _buildRadiusBox('xs', BorderRadius.circular(AppRadius.xs)),
              _buildRadiusBox('sm', BorderRadius.circular(AppRadius.sm)),
              _buildRadiusBox('md', BorderRadius.circular(AppRadius.md)),
              _buildRadiusBox('lg', BorderRadius.circular(AppRadius.lg)),
              _buildRadiusBox(
                'checkboxRadius',
                BorderRadius.circular(AppRadius.checkboxRadius),
              ),
              _buildIosRadiusBox('iosStyle', AppRadius.iosStyleRadius),
            ],
          ),
        ],
      ),
    );
  }
}

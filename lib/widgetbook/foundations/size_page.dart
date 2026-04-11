import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/app/config/theme/constants/weight.dart';

import '../../app/config/theme/constants/size.dart';

/// 사이즈 상수를 시각화하여 확인할 수 있는 페이지
class SizePage extends StatelessWidget {
  /// 생성자
  const SizePage({super.key});

  Widget _buildIconSizeItem(String name, double size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, size: size),
        const SizedBox(height: AppSpacing.s24),
        Text('$name\n${size.toStringAsFixed(0)}', textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildContainerSizeItem(
    String name,
    double size, {
    required String type,
  }) {
    Widget box;
    switch (type) {
      case 'vertical':
        box = Container(
          width: size / 2,
          height: size,
          color: Colors.blue.shade200,
        );
        break;
      case 'horizontal':
        box = Container(
          width: size,
          height: size / 2,
          color: Colors.blue.shade200,
        );
        break;
      case 'both':
      default:
        box = Container(width: size, height: size, color: Colors.blue.shade200);
        break;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        box,
        const SizedBox(height: AppSpacing.s24),
        Text('$name\n${size.toStringAsFixed(0)}', textAlign: TextAlign.center),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconSizes = <MapEntry<String, double>>[
      MapEntry('small', AppIconSize.xs),
      MapEntry('regular', AppIconSize.sm),
      MapEntry('large', AppIconSize.md),
    ];

    final containerSizes = <MapEntry<String, double>>[
      MapEntry('indicator', AppContainerSize.indicator),
      MapEntry('small', AppContainerSize.small),
      MapEntry('buttonMinimun', AppContainerSize.buttonMinimun),
      MapEntry('inputFieldMinimun', AppContainerSize.inputFieldMinimun),
      MapEntry('regular', AppContainerSize.regular),
      MapEntry('large', AppContainerSize.large),
      MapEntry('xl', AppContainerSize.xl),
      MapEntry('indicatorContainer', AppContainerSize.indicatorContainer),
      MapEntry('indicatorDescription', AppContainerSize.indicatorDescription),
      MapEntry('indicatorImage', AppContainerSize.indicatorImage),
      MapEntry(
        'carouselImageContainer',
        AppContainerSize.carouselImageContainer,
      ),
      MapEntry(
        'carouselImageContainerWidth',
        AppContainerSize.carouselImageContainer,
      ),
      MapEntry('wrap', AppContainerSize.wrap),
      MapEntry('verticalDividerHeight', AppContainerSize.verticalDividerHeight),
    ];

    final lineSizes = <MapEntry<String, double>>[
      MapEntry('outline', AppLineWidth.outline),
      MapEntry('inputFieldOutline', AppLineWidth.inputFieldOutline),
      MapEntry('inputFieldCursor', AppLineWidth.inputFieldCursor),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Size Constants Visualization')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AppIconSize',
              style: TextStyle(
                fontSize: AppFontSize.title,
                fontWeight: AppFontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            Wrap(
              spacing: AppSpacing.s24,
              runSpacing: AppSpacing.s24,
              children: iconSizes
                  .map((e) => _buildIconSizeItem(e.key, e.value))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.s32),
            const Text(
              'AppContainerSize',
              style: TextStyle(
                fontSize: AppFontSize.title,
                fontWeight: AppFontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            Wrap(
              spacing: AppSpacing.s24,
              runSpacing: AppSpacing.s24,
              children: containerSizes.map((e) {
                String type;
                if (e.key.toLowerCase().contains('height') ||
                    e.key.toLowerCase().contains('vertical')) {
                  type = 'vertical';
                } else if (e.key.toLowerCase().contains('width') ||
                    e.key.toLowerCase().contains('horizontal')) {
                  type = 'horizontal';
                } else {
                  type = 'both';
                }
                return _buildContainerSizeItem(e.key, e.value, type: type);
              }).toList(),
            ),

            const SizedBox(height: AppSpacing.s32),
            const Text(
              'AppLineWidth',
              style: TextStyle(
                fontSize: AppFontSize.title,
                fontWeight: AppFontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lineSizes.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.key}: ${entry.value}px',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        height: entry.value,
                        color: Colors.black,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

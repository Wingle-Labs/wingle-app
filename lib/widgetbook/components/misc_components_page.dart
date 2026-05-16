import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/dividers/default_vertical_divider.dart';
import 'package:wingle/app/config/theme/components/pickers/date_picker.dart';
import 'package:wingle/app/config/theme/components/wrappers/smooth_rect.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 기타 컴포넌트 프리뷰
class MiscComponentsPage extends StatefulWidget {
  /// 생성자
  const MiscComponentsPage({super.key});

  @override
  State<MiscComponentsPage> createState() => _MiscComponentsPageState();
}

class _MiscComponentsPageState extends State<MiscComponentsPage> {
  DateTime _selectedDate = DateTime(1999, 1, 1);

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final dividerHeight = context.knobs.double.slider(
      label: 'Divider Height',
      initialValue: 20,
      min: 8,
      max: 80,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Misc Components', style: typography.title),
            const SizedBox(height: 8),
            Text(
              'DefaultVerticalDivider, DatePicker, SmoothRectWrapper',
              style: typography.bodySub.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: 24),
            _MiscCard(
              title: 'DefaultVerticalDivider',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Left', style: typography.body),
                  const SizedBox(width: 12),
                  DefaultVerticalDivider(height: dividerHeight),
                  const SizedBox(width: 12),
                  Text('Right', style: typography.body),
                ],
              ),
            ),
            _MiscCard(
              title: 'DatePicker',
              child: DatePicker(
                selectedDate: _selectedDate,
                minimumDate: DateTime(1970),
                maximumDate: DateTime.now(),
                onDateTimeChanged: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ),
            _MiscCard(
              title: 'SmoothRectWrapper',
              child: SmoothRectWrapper(
                child: Container(
                  height: 96,
                  width: double.infinity,
                  alignment: Alignment.center,
                  color: colors.primaryNormal,
                  child: Text(
                    'Smooth clipped container',
                    style: typography.main.copyWith(
                      color: colors.onPrimaryNormal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiscCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _MiscCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.backgroundNormal,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.strokeStructuralBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: typography.main),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

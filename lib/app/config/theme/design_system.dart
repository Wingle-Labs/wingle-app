import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/color/app_color_scheme.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/weight.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// ! 디자인 시스템 라우트
final GoRoute designSystemRoute = GoRoute(
  path: '/design-system',
  name: 'design-system',
  builder: (context, state) => const DesignSystem(),
);

/// 디자인 시스템 조회 화면
class DesignSystem extends ConsumerWidget {
  /// const 생성자
  const DesignSystem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colors;
    return ScrollableScaffold(
      title: "디자인 시스템",
      body: [
        Row(
          mainAxisAlignment: .center,
          spacing: 8 * 5,
          mainAxisSize: .max,
          children: [
            _buildByColor(colorScheme),
            // _buildByColor(secondPrimaryColor),
            // _buildByColor(AppColor.primary),
          ],
        ),
      ],
    );
  }

  Widget _buildByColor(AppColorScheme colorScheme) {
    final baseLength = 48.0;
    return Column(
      spacing: 8 * 5,
      mainAxisSize: .min,
      children: [
        Container(
          height: 100,
          width: baseLength * 5,
          color: colorScheme.primary,
        ),

        Container(
          width: baseLength * 5,
          padding: .all(AppFontSize.button),
          decoration: BoxDecoration(
            borderRadius: AppRadius.iosStyleRadius,
            color: colorScheme.primary,
          ),
          child: Center(
            child: Text(
              '활성화된 채워진 버튼',
              style: TextStyle(
                fontSize: AppFontSize.button,
                color: Colors.white,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),
        ),

        Container(
          width: baseLength * 5,
          padding: .all(AppFontSize.button),
          decoration: BoxDecoration(
            borderRadius: AppRadius.iosStyleRadius,
            color: colorScheme.btnDisabled,
          ),
          child: Center(
            child: Text(
              '비활성화된 채워진 버튼',
              style: TextStyle(
                fontSize: AppFontSize.button,
                color: colorScheme.textDisabled,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),
        ),

        Container(
          width: baseLength * 5,
          padding: .all(AppFontSize.button),
          decoration: BoxDecoration(
            borderRadius: AppRadius.iosStyleRadius,
            color: Colors.transparent,
          ),
          child: Center(
            child: Text(
              '텍스트 버튼',
              style: TextStyle(
                fontSize: AppFontSize.button,
                color: colorScheme.primary,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),
        ),

        Container(
          width: baseLength * 5,
          padding: .all(AppFontSize.button),
          decoration: BoxDecoration(
            borderRadius: AppRadius.iosStyleRadius,
            color: Colors.transparent,
          ),
          child: Center(
            child: Text(
              '비활성화된 텍스트 버튼',
              style: TextStyle(
                fontSize: AppFontSize.button,
                color: colorScheme.textDisabled,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),
        ),

        Container(
          width: baseLength * 5,
          padding: .all(AppFontSize.button),
          decoration: BoxDecoration(
            borderRadius: AppRadius.iosStyleRadius,
            color: Colors.transparent,
            border: Border.all(color: colorScheme.primary, width: 1.2),
          ),
          child: Center(
            child: Text(
              '아웃라인 버튼',
              style: TextStyle(
                fontSize: AppFontSize.button,
                color: colorScheme.primary,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),
        ),

        Container(
          width: baseLength * 5,
          padding: .all(AppFontSize.button),
          decoration: BoxDecoration(
            borderRadius: AppRadius.iosStyleRadius,
            color: Colors.transparent,
            border: Border.all(color: colorScheme.btnDisabled, width: 1.2),
          ),
          child: Center(
            child: Text(
              '비활성화된 아웃라인 버튼',
              style: TextStyle(
                fontSize: AppFontSize.button,
                color: colorScheme.textDisabled,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),
        ),

        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colorScheme.primary, width: 2.4),
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary,
              ),
            ),
          ),
        ),

        Container(
          width: 20,
          height: 20,
          padding: EdgeInsets.all(AppFontSize.button),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colorScheme.border, width: 2.4),
          ),
          child: null,
        ),

        Container(
          // height: baseLength,
          width: baseLength * 5,
          padding: .all(AppFontSize.button),
          decoration: BoxDecoration(
            borderRadius: AppRadius.iosStyleRadius,
            color: colorScheme.surface,
          ),
          child: Row(
            spacing: AppFontSize.button,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.primary, width: 2.4),
                ),
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '선택된 리스트 버튼',
                  style: TextStyle(
                    fontWeight: AppFontWeight.semiBold,
                    fontSize: AppFontSize.button,
                    color: colorScheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(
          // height: baseLength,
          width: baseLength * 5,
          padding: .all(AppFontSize.button),
          constraints: BoxConstraints(
            minHeight: baseLength,
            minWidth: baseLength,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadius.iosStyleRadius,
            color: colorScheme.btnDisabled,
          ),
          child: Row(
            spacing: AppFontSize.button,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.textDisabled,
                    width: 2.4,
                  ),
                ),
                child: null,
              ),
              Expanded(
                child: Text(
                  '선택 안된 리스트 버튼',
                  style: TextStyle(
                    fontWeight: AppFontWeight.semiBold,
                    fontSize: AppFontSize.button,
                    color: colorScheme.textDisabled,
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: .symmetric(vertical: 8, horizontal: AppFontSize.button),
          decoration: BoxDecoration(
            borderRadius: AppRadius.iosStyleRadius,
            color: colorScheme.primary,
          ),
          child: Center(
            child: Text(
              '선택된 칩 버튼',
              style: TextStyle(
                fontSize: AppFontSize.caption,
                color: Colors.white,
                fontWeight: AppFontWeight.bold,
              ),
            ),
          ),
        ),

        Container(
          padding: .symmetric(vertical: 8, horizontal: AppFontSize.button),
          decoration: BoxDecoration(
            borderRadius: AppRadius.iosStyleRadius,
            color: colorScheme.btnDisabled,
          ),
          child: Center(
            child: Text(
              '선택 안된 칩 버튼',
              style: TextStyle(
                fontSize: AppFontSize.caption,
                color: colorScheme.textDisabled,
                fontWeight: AppFontWeight.bold,
              ),
            ),
          ),
        ),

        Container(
          padding: .symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: AppRadius.iosStyleRadius,
            color: colorScheme.primary,
          ),
          child: Center(child: Icon(Icons.close, color: Colors.white)),
        ),

        Flexible(
          child: Container(
            height: baseLength,
            color: Colors.grey[200],
            child: Center(
              child: Text(
                'Flexible child',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),

        SizedBox(height: baseLength),
      ],
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_outlined_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_text_button.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';
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
    final baseLength = 48.0;
    return ScrollableScaffold(
      title: 'designSystem.title',
      body: [
        Container(
          height: 100,
          color: colorScheme.primaryNormal,
          child: Center(
            child: Text(
              'designSystem.sample.primaryColor'.tr(),
              style: TextStyle(
                color: colorScheme.onPrimaryNormal,
                fontSize: AppFontSize.subtitle,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),
        ),

        DefaultFilledButton(label: 'designSystem.button.filled.enabled'),

        DefaultFilledButton(
          label: 'designSystem.button.filled.disabled',
          isDisabled: true,
        ),

        DefaultFilledButton(
          label: 'designSystem.button.filled.leadingEnabled',
          leadingIcon: Icons.add,
        ),

        DefaultFilledButton(
          label: 'designSystem.button.filled.leadingDisabled',
          leadingIcon: Icons.add,
          isDisabled: true,
        ),

        DefaultFilledButton(
          label: 'designSystem.button.filled.trailingEnabled',
          trailingIcon: Icons.add,
        ),

        DefaultFilledButton(
          label: 'designSystem.button.filled.trailingDisabled',
          trailingIcon: Icons.add,
          isDisabled: true,
        ),

        DefaultOutlinedButton(label: 'designSystem.button.outlined.enabled'),

        DefaultOutlinedButton(
          label: 'designSystem.button.outlined.disabled',
          isDisabled: true,
        ),

        DefaultTextButton(label: 'designSystem.button.text.enabled'),

        DefaultTextButton(
          label: 'designSystem.button.text.disabled',
          isDisabled: true,
        ),

        // Container(
        //   // height: baseLength,
        //   width: baseLength * 5,
        //   padding: .all(AppFontSize.button),
        //   decoration: BoxDecoration(
        //     borderRadius: AppRadius.iosStyleRadius,
        //     color: colorScheme.surface,
        //   ),
        //   child: Row(
        //     spacing: AppFontSize.button,
        //     children: [
        //       Container(
        //         width: 20,
        //         height: 20,
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           border: Border.all(color: colorScheme.primary, width: 2.4),
        //         ),
        //         child: Center(
        //           child: Container(
        //             width: 10,
        //             height: 10,
        //             decoration: BoxDecoration(
        //               shape: BoxShape.circle,
        //               color: colorScheme.primary,
        //             ),
        //           ),
        //         ),
        //       ),
        //       Expanded(
        //         child: Text(
        //           '선택된 리스트 버튼',
        //           style: TextStyle(
        //             fontWeight: AppFontWeight.semiBold,
        //             fontSize: AppFontSize.button,
        //             color: colorScheme.textPrimary,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        // Container(
        //   // height: baseLength,
        //   width: baseLength * 5,
        //   padding: .all(AppFontSize.button),
        //   constraints: BoxConstraints(
        //     minHeight: baseLength,
        //     minWidth: baseLength,
        //   ),
        //   decoration: BoxDecoration(
        //     borderRadius: AppRadius.iosStyleRadius,
        //     color: colorScheme.textBackground30,
        //   ),
        //   child: Row(
        //     spacing: AppFontSize.button,
        //     children: [
        //       Container(
        //         width: 20,
        //         height: 20,
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           border: Border.all(
        //             color: colorScheme.textDisabled,
        //             width: 2.4,
        //           ),
        //         ),
        //         child: null,
        //       ),
        //       Expanded(
        //         child: Text(
        //           '선택 안된 리스트 버튼',
        //           style: TextStyle(
        //             fontWeight: AppFontWeight.semiBold,
        //             fontSize: AppFontSize.button,
        //             color: colorScheme.textDisabled,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        // Container(
        //   padding: .symmetric(vertical: 8, horizontal: AppFontSize.button),
        //   decoration: BoxDecoration(
        //     borderRadius: AppRadius.iosStyleRadius,
        //     color: colorScheme.primary,
        //   ),
        //   child: Center(
        //     child: Text(
        //       '선택된 칩 버튼',
        //       style: TextStyle(
        //         fontSize: AppFontSize.caption,
        //         color: Colors.white,
        //         fontWeight: AppFontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ),

        // Container(
        //   padding: .symmetric(vertical: 8, horizontal: AppFontSize.button),
        //   decoration: BoxDecoration(
        //     borderRadius: AppRadius.iosStyleRadius,
        //     color: colorScheme.textBackground30,
        //   ),
        //   child: Center(
        //     child: Text(
        //       '선택 안된 칩 버튼',
        //       style: TextStyle(
        //         fontSize: AppFontSize.caption,
        //         color: colorScheme.textDisabled,
        //         fontWeight: AppFontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ),

        // Container(
        //   padding: .symmetric(vertical: 8, horizontal: 8),
        //   decoration: BoxDecoration(
        //     borderRadius: AppRadius.iosStyleRadius,
        //     color: colorScheme.primary,
        //   ),
        //   child: Center(child: Icon(Icons.close, color: Colors.white)),
        // ),
        SizedBox(height: baseLength),
      ],
    );
  }
}

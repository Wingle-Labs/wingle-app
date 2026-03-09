import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/bottons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/bottons/default_outlined_button.dart';
import 'package:wingle/app/config/theme/components/bottons/default_text_button.dart';
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
      title: "디자인 시스템",
      body: [
        Container(
          height: 100,
          color: colorScheme.primaryNormal,
          child: Center(
            child: Text(
              "Primary Color",
              style: TextStyle(
                color: colorScheme.onPrimaryNormal,
                fontSize: AppFontSize.subtitle,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),
        ),

        DefaultFilledButton(label: "활성화 상태: 채워진 버튼"),

        DefaultFilledButton(label: "비활성화 상태: 채워진 버튼", isDisabled: true),

        DefaultFilledButton(
          label: "활성화 상태: 채워진 버튼 with leading",
          leadingIcon: Icons.add,
        ),

        DefaultFilledButton(
          label: "비활성화 상태: 채워진 버튼 with leading",
          leadingIcon: Icons.add,
          isDisabled: true,
        ),

        DefaultFilledButton(
          label: "활성화 상태: 채워진 버튼 with trailing",
          trailingIcon: Icons.add,
        ),

        DefaultFilledButton(
          label: "비활성화 상태: 채워진 버튼 with trailing",
          trailingIcon: Icons.add,
          isDisabled: true,
        ),

        DefaultOutlinedButton(label: "활성화 상태: 테두리 버튼"),

        DefaultOutlinedButton(label: "비활성화 상태: 테두리 버튼", isDisabled: true),

        DefaultTextButton(label: "활성화 상태: 텍스트 버튼"),

        DefaultTextButton(label: "비활성화 상태: 텍스트 버튼", isDisabled: true),

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

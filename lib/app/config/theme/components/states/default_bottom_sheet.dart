import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_text_button.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 기본 하단 시트
class DefaultBottomSheet {
  /// 하단 시트를 표시합니다.
  static void show(
    BuildContext context, {
    required Widget body,
    required VoidCallback onMain,
    required String mainLabel,
    VoidCallback? onSub,
    String? subLabel,
    bool? isHandleContained,
  }) {
    final color = context.colors;

    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isDismissible: false,
      showDragHandle: false,
      enableDrag: isHandleContained == true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: .all(AppPadding.scaffold),
          padding: .all(AppPadding.bottomSheet),
          decoration: BoxDecoration(
            color: color.staticWhite,
            borderRadius: .all(Radius.circular(AppRadius.bottomSheetTopRadius)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: .start,
            children: [
              /// handle
              isHandleContained == true
                  ? Column(
                      children: [
                        Container(
                          width: .infinity,
                          alignment: .center,
                          child: Container(
                            width: AppContainerSize.bottomSheetHandleWidth,
                            height: AppLineWidth.bottomSheetHandleHeight,
                            decoration: BoxDecoration(
                              color: color.componentBottomSheetHandle,
                              borderRadius: .circular(AppRadius.xs),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppPadding.vertical),
                      ],
                    )
                  : SizedBox.shrink(),
              const SizedBox(height: AppPadding.vertical),

              /// Body
              body,

              const SizedBox(height: AppPadding.bottomSheet),

              /// Main button
              DefaultFilledButton(label: mainLabel, onPressed: onMain),

              /// Sub Button
              if (onSub != null && subLabel != null) ...[
                const SizedBox(height: AppPadding.bottomSheet),
                DefaultTextButton(label: subLabel, onPressed: onSub),
              ],
            ],
          ),
        );
      },
    );
  }
}

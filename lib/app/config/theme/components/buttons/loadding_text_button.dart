import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 로딩 상태를 표시하는 텍스트 버튼
class LoadingTextButton extends ConsumerWidget {
  /// 텍스트
  final String label;

  /// 로딩 상태
  final bool isLoading;

  /// 생성자
  const LoadingTextButton({
    super.key,
    required this.label,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = context.colors;
    final typography = context.typography;
    return LayoutBuilder(
      builder: (context, constraints) {
        // 텍스트의 width를 미리 계산하기 위한 TextPainter
        final textPainter = TextPainter(
          text: TextSpan(text: label.tr(), style: typography.buttonLarge),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout();

        final textWidth = textPainter.size.width + AppPadding.btnHorizontal;
        final textHeight = textPainter.size.height + AppPadding.btnVertical;

        return SizedBox(
          // 텍스트 영역 + 양쪽 패딩 16px
          width: textWidth + AppPadding.btnHorizontal,
          height: textHeight + AppPadding.btnVertical,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: textPainter.size.height * 0.8,
                    height: textPainter.size.height * 0.8,
                    child: AnimationProgressIndicator(),
                  )
                : DefaultText(
                    label,
                    style: typography.buttonLarge,
                    color: color.onPrimaryNormal,
                    policy: .cappedLarge,
                  ),
          ),
        );
      },
    );
  }
}

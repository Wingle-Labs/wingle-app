part of 'default_button.dart';

class _ButtonContent extends StatelessWidget {
  final String label;
  final IconData? leading;
  final IconData? trailing;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final Color foregroundColor;
  final TextStyle textStyle;
  final bool isLoading;
  final bool expandToMaxWidth;
  final double iconLabelGap;
  final double iconGlyphSize;
  final double iconFrameSize;

  const _ButtonContent({
    required this.label,
    required this.leading,
    required this.trailing,
    required this.leadingWidget,
    required this.trailingWidget,
    required this.foregroundColor,
    required this.textStyle,
    required this.isLoading,
    required this.expandToMaxWidth,
    required this.iconLabelGap,
    required this.iconGlyphSize,
    required this.iconFrameSize,
  });

  @override
  Widget build(BuildContext context) {
    final hasLeading = leading != null || leadingWidget != null;
    final hasTrailing = trailing != null || trailingWidget != null;
    if (isLoading) {
      return _ButtonContentAlign(
        expandToMaxWidth: expandToMaxWidth,
        child: AnimationProgressIndicator(
          color: foregroundColor,
          height: iconFrameSize,
        ),
      );
    }

    if (!expandToMaxWidth) {
      return _ButtonContentAlign(
        expandToMaxWidth: false,
        child: _ButtonContentRow(
          label: label,
          hasLeading: hasLeading,
          hasTrailing: hasTrailing,
          leading: leading,
          trailing: trailing,
          leadingWidget: leadingWidget,
          trailingWidget: trailingWidget,
          foregroundColor: foregroundColor,
          textStyle: textStyle,
          iconLabelGap: iconLabelGap,
          iconGlyphSize: iconGlyphSize,
          iconFrameSize: iconFrameSize,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final leadingWidth = hasLeading ? iconFrameSize + iconLabelGap : 0.0;
        final trailingWidth = hasTrailing ? iconFrameSize + iconLabelGap : 0.0;
        final maxTextWidth = constraints.hasBoundedWidth
            ? (constraints.maxWidth - leadingWidth - trailingWidth).clamp(
                0.0,
                constraints.maxWidth,
              )
            : double.infinity;

        return _ButtonContentAlign(
          expandToMaxWidth: true,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxTextWidth),
            child: _ButtonContentRow(
              label: label,
              hasLeading: hasLeading,
              hasTrailing: hasTrailing,
              leading: leading,
              trailing: trailing,
              leadingWidget: leadingWidget,
              trailingWidget: trailingWidget,
              foregroundColor: foregroundColor,
              textStyle: textStyle,
              iconLabelGap: iconLabelGap,
              iconGlyphSize: iconGlyphSize,
              iconFrameSize: iconFrameSize,
            ),
          ),
        );
      },
    );
  }
}

class _ButtonContentAlign extends StatelessWidget {
  final bool expandToMaxWidth;
  final Widget child;

  const _ButtonContentAlign({
    required this.expandToMaxWidth,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      widthFactor: expandToMaxWidth ? null : 1,
      child: child,
    );
  }
}

class _ButtonContentRow extends StatelessWidget {
  final String label;
  final bool hasLeading;
  final bool hasTrailing;
  final IconData? leading;
  final IconData? trailing;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final Color foregroundColor;
  final TextStyle textStyle;
  final double iconLabelGap;
  final double iconGlyphSize;
  final double iconFrameSize;

  const _ButtonContentRow({
    required this.label,
    required this.hasLeading,
    required this.hasTrailing,
    required this.leading,
    required this.trailing,
    required this.leadingWidget,
    required this.trailingWidget,
    required this.foregroundColor,
    required this.textStyle,
    required this.iconLabelGap,
    required this.iconGlyphSize,
    required this.iconFrameSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasLeading) ...[
          _ReservedButtonIconSlot(
            dimension: iconFrameSize,
            child: DefaultIconSlot(
              frameSize: iconFrameSize,
              glyphSize: iconGlyphSize,
              icon: leading,
              color: foregroundColor,
              child: leadingWidget,
            ),
          ),
          SizedBox(width: iconLabelGap),
        ],
        TextScaleWrapper(
          policy: TextScalePolicy.cappedLarge,
          child: Text(
            label,
            style: textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        if (hasTrailing) ...[
          SizedBox(width: iconLabelGap),
          _ReservedButtonIconSlot(
            dimension: iconFrameSize,
            child: DefaultIconSlot(
              frameSize: iconFrameSize,
              glyphSize: iconGlyphSize,
              icon: trailing,
              color: foregroundColor,
              child: trailingWidget,
            ),
          ),
        ],
      ],
    );
  }
}

class _ReservedButtonIconSlot extends StatelessWidget {
  final double dimension;
  final Widget? child;

  const _ReservedButtonIconSlot({required this.dimension, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(dimension: dimension, child: child);
  }
}

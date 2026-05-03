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
  final double iconSlotSize;

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
    required this.iconSlotSize,
  });

  @override
  Widget build(BuildContext context) {
    final hasLeading = leading != null || leadingWidget != null;
    final hasTrailing = trailing != null || trailingWidget != null;
    final hasIcon = hasLeading || hasTrailing;

    if (isLoading) {
      return _ButtonContentAlign(
        expandToMaxWidth: expandToMaxWidth,
        child: AnimationProgressIndicator(
          color: foregroundColor,
          height: iconSlotSize,
        ),
      );
    }

    if (!expandToMaxWidth) {
      return _ButtonContentAlign(
        expandToMaxWidth: false,
        child: _ButtonContentRow(
          label: label,
          hasIcon: hasIcon,
          hasLeading: hasLeading,
          hasTrailing: hasTrailing,
          leading: leading,
          trailing: trailing,
          leadingWidget: leadingWidget,
          trailingWidget: trailingWidget,
          foregroundColor: foregroundColor,
          textStyle: textStyle,
          iconLabelGap: iconLabelGap,
          iconSlotSize: iconSlotSize,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final sideWidth = hasIcon ? iconSlotSize + iconLabelGap : 0.0;
        final maxTextWidth = constraints.hasBoundedWidth
            ? (constraints.maxWidth - sideWidth * 2).clamp(
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
              hasIcon: hasIcon,
              hasLeading: hasLeading,
              hasTrailing: hasTrailing,
              leading: leading,
              trailing: trailing,
              leadingWidget: leadingWidget,
              trailingWidget: trailingWidget,
              foregroundColor: foregroundColor,
              textStyle: textStyle,
              iconLabelGap: iconLabelGap,
              iconSlotSize: iconSlotSize,
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
  final bool hasIcon;
  final bool hasLeading;
  final bool hasTrailing;
  final IconData? leading;
  final IconData? trailing;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final Color foregroundColor;
  final TextStyle textStyle;
  final double iconLabelGap;
  final double iconSlotSize;

  const _ButtonContentRow({
    required this.label,
    required this.hasIcon,
    required this.hasLeading,
    required this.hasTrailing,
    required this.leading,
    required this.trailing,
    required this.leadingWidget,
    required this.trailingWidget,
    required this.foregroundColor,
    required this.textStyle,
    required this.iconLabelGap,
    required this.iconSlotSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasIcon) ...[
          _ReservedButtonIconSlot(
            dimension: iconSlotSize,
            child: hasLeading
                ? _ButtonIconSlot(
                    icon: leading,
                    color: foregroundColor,
                    dimension: iconSlotSize,
                    child: leadingWidget,
                  )
                : null,
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
        if (hasIcon) ...[
          SizedBox(width: iconLabelGap),
          _ReservedButtonIconSlot(
            dimension: iconSlotSize,
            child: hasTrailing
                ? _ButtonIconSlot(
                    icon: trailing,
                    color: foregroundColor,
                    dimension: iconSlotSize,
                    child: trailingWidget,
                  )
                : null,
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

class _ButtonIconSlot extends StatelessWidget {
  final IconData? icon;
  final Color color;
  final Widget? child;
  final double dimension;

  const _ButtonIconSlot({
    required this.icon,
    required this.color,
    required this.child,
    required this.dimension,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: child == null
          ? DefaultIcon(icon: icon!, size: dimension, color: color)
          : ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.buttonIconSlot),
              child: child,
            ),
    );
  }
}

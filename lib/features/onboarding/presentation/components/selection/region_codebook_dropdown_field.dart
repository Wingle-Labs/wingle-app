part of 'region_codebook_selection_panel.dart';

class _RegionDropdownField extends StatelessWidget {
  final String label;
  final String hintText;
  final String? value;
  final List<RegionCodebookNode> items;
  final ValueChanged<String?> onChanged;

  const _RegionDropdownField({
    required this.label,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final selectedItem = _selectedItem;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s8,
      children: [
        DefaultText(
          label,
          style: typography.bodySub.copyWith(color: colors.textNeutral),
          isTranslationKey: false,
        ),
        Material(
          color: colors.backgroundNormal,
          borderRadius: BorderRadius.circular(AppRadius.iosStyle),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.iosStyle),
            onTap: () async {
              final selectedCode = await showModalBottomSheet<String>(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,
                showDragHandle: false,
                backgroundColor: Colors.transparent,
                builder: (context) => _RegionPickerSheet(
                  title: label,
                  searchHintText: '$label 검색',
                  items: items,
                  selectedCode: value,
                ),
              );

              onChanged(selectedCode);
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: colors.strokeStructuralBorder),
                borderRadius: BorderRadius.circular(AppRadius.iosStyle),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.textfield,
                  vertical: AppPadding.textfieldVertical,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultText(
                        selectedItem?.codeName ?? hintText,
                        style: typography.body.copyWith(
                          color: selectedItem == null
                              ? colors.textAlternative
                              : colors.textNormal,
                        ),
                        isTranslationKey: false,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s8),
                    DefaultIcon(
                      icon: Icons.keyboard_arrow_down_rounded,
                      size: AppIconSize.md,
                      color: colors.textAlternative,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  RegionCodebookNode? get _selectedItem {
    for (final item in items) {
      if (item.code == value) return item;
    }
    return null;
  }
}

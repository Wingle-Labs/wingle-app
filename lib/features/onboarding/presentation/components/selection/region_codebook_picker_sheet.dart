part of 'region_codebook_selection_panel.dart';

class _RegionPickerSheet extends StatefulWidget {
  static const double _heightFactor = 0.72;

  final String title;
  final String searchHintText;
  final List<RegionCodebookNode> items;
  final String? selectedCode;

  const _RegionPickerSheet({
    required this.title,
    required this.searchHintText,
    required this.items,
    required this.selectedCode,
  });

  @override
  State<_RegionPickerSheet> createState() => _RegionPickerSheetState();
}

class _RegionPickerSheetState extends State<_RegionPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final filteredItems = widget.items.where((item) {
      final query = _query.trim().toLowerCase();
      if (query.isEmpty) return true;
      return item.codeName.toLowerCase().contains(query);
    }).toList();

    return FractionallySizedBox(
      heightFactor: _RegionPickerSheet._heightFactor,
      child: Container(
        margin: const EdgeInsets.all(AppPadding.scaffold),
        padding: const EdgeInsets.all(AppPadding.bottomSheet),
        decoration: BoxDecoration(
          color: colors.backgroundElevatedNormal,
          borderRadius: BorderRadius.circular(AppRadius.bottomSheetTopRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.strokeStructuralDivider,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: const SizedBox(
                  width: AppContainerSize.bottomSheetHandleWidth,
                  height: AppLineWidth.bottomSheetHandleHeight,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            DefaultText(
              widget.title,
              style: typography.subtitle.copyWith(color: colors.textStrong),
              isTranslationKey: false,
            ),
            const SizedBox(height: AppSpacing.s16),
            ProfileInputSearchField(
              hintText: widget.searchHintText,
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              showClearButton: _searchController.text.isNotEmpty,
              onClear: () {
                _searchController.clear();
                setState(() => _query = '');
              },
            ),
            const SizedBox(height: AppSpacing.s12),
            Expanded(
              child: filteredItems.isEmpty
                  ? _RegionEmptySearchResult(query: _query)
                  : ListView.separated(
                      itemCount: filteredItems.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.s4),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final isSelected = item.code == widget.selectedCode;

                        return _RegionOptionTile(
                          item: item,
                          isSelected: isSelected,
                          onTap: () => Navigator.of(context).pop(item.code),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegionOptionTile extends StatelessWidget {
  final RegionCodebookNode item;
  final bool isSelected;
  final VoidCallback onTap;

  const _RegionOptionTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Material(
      color: isSelected
          ? colors.backgroundElevatedAlternative
          : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.textfield,
            vertical: AppPadding.vertical,
          ),
          child: Row(
            children: [
              Expanded(
                child: DefaultText(
                  item.codeName,
                  style: typography.body.copyWith(
                    color: isSelected
                        ? colors.primaryNormal
                        : colors.textNormal,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  isTranslationKey: false,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: AppSpacing.s8),
                DefaultIcon(
                  icon: Icons.check_rounded,
                  size: AppIconSize.sm,
                  color: colors.primaryNormal,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RegionEmptySearchResult extends StatelessWidget {
  final String query;

  const _RegionEmptySearchResult({required this.query});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.backgroundElevatedAlternative,
          borderRadius: BorderRadius.circular(AppRadius.iosStyle),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.card),
          child: DefaultText(
            query.trim().isEmpty ? '선택 가능한 지역이 없습니다.' : '검색 결과가 없습니다.',
            style: typography.bodySub.copyWith(color: colors.textAlternative),
            isTranslationKey: false,
          ),
        ),
      ),
    );
  }
}

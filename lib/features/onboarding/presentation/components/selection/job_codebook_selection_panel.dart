import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/icons/default_icon.dart';
import 'package:wingle/app/config/theme/components/states/keyboard_avoiding_popup.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/presentation/components/input/profile_input_search_field.dart';
import 'package:wingle/features/onboarding/presentation/providers/job_codebook_provider.dart';

/// JOB 코드북 선택 결과.
class JobCodebookSelection {
  /// 선택된 코드.
  final String code;

  /// 선택된 표시명.
  final String codeName;

  /// 최상위부터 선택 코드까지의 경로.
  final List<JobCodebookNode> path;

  /// 생성자.
  const JobCodebookSelection({
    required this.code,
    required this.codeName,
    required this.path,
  });
}

/// JOB 코드북을 직군/직종 드롭다운으로 선택하는 패널.
class JobCodebookSelectionPanel extends ConsumerStatefulWidget {
  /// JOB 코드북 트리 override.
  final JobCodebookTree? tree;

  /// 선택된 코드.
  final String? selectedCode;

  /// 선택 콜백.
  final ValueChanged<JobCodebookSelection> onSelected;

  /// 선택 초기화 콜백.
  final VoidCallback? onCleared;

  /// 생성자.
  const JobCodebookSelectionPanel({
    super.key,
    this.tree,
    required this.selectedCode,
    required this.onSelected,
    this.onCleared,
  });

  @override
  ConsumerState<JobCodebookSelectionPanel> createState() =>
      _JobCodebookSelectionPanelState();
}

class _JobCodebookSelectionPanelState
    extends ConsumerState<JobCodebookSelectionPanel> {
  String? _localRootCode;

  @override
  Widget build(BuildContext context) {
    final JobCodebookTree tree =
        widget.tree ?? ref.watch(jobCodebookTreeProvider);
    final path = widget.selectedCode == null
        ? const <JobCodebookNode>[]
        : tree.pathTo(widget.selectedCode!);
    final selectedRootCode = path.isNotEmpty ? path.first.code : _localRootCode;
    final selectedOccupationCode = path.length > 1 ? path.last.code : null;
    final occupationOptions = tree.childrenOf(selectedRootCode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s16,
      children: [
        _JobDropdownField(
          label: '직군',
          hintText: '직군 선택',
          value: selectedRootCode,
          items: tree.roots,
          onChanged: (value) {
            if (value == null) return;
            setState(() => _localRootCode = value);
            widget.onCleared?.call();
          },
        ),
        if (selectedRootCode != null)
          _JobDropdownField(
            label: '직종',
            hintText: '직종 선택',
            value: selectedOccupationCode,
            items: occupationOptions,
            onChanged: (value) {
              if (value == null) return;
              final nextPath = tree.pathTo(value);
              final selected = nextPath.isEmpty
                  ? tree.findByCode(value)
                  : nextPath.last;
              if (selected == null) return;
              widget.onSelected(
                JobCodebookSelection(
                  code: selected.code,
                  codeName: selected.codeName,
                  path: nextPath,
                ),
              );
            },
          ),
      ],
    );
  }
}

class _JobDropdownField extends StatelessWidget {
  final String label;
  final String hintText;
  final String? value;
  final List<JobCodebookNode> items;
  final ValueChanged<String?> onChanged;

  const _JobDropdownField({
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
            onTap: items.isEmpty
                ? null
                : () async {
                    final selectedCode = await showModalBottomSheet<String>(
                      context: context,
                      useSafeArea: true,
                      isScrollControlled: true,
                      showDragHandle: false,
                      backgroundColor: Colors.transparent,
                      builder: (context) => KeyboardAvoidingPopup(
                        child: _JobPickerSheet(
                          title: label,
                          searchHintText: '$label 검색',
                          items: items,
                          selectedCode: value,
                        ),
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

  JobCodebookNode? get _selectedItem {
    for (final item in items) {
      if (item.code == value) return item;
    }
    return null;
  }
}

class _JobPickerSheet extends StatefulWidget {
  static const double _heightFactor = 0.64;

  final String title;
  final String searchHintText;
  final List<JobCodebookNode> items;
  final String? selectedCode;

  const _JobPickerSheet({
    required this.title,
    required this.searchHintText,
    required this.items,
    required this.selectedCode,
  });

  @override
  State<_JobPickerSheet> createState() => _JobPickerSheetState();
}

class _JobPickerSheetState extends State<_JobPickerSheet> {
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaQuery = MediaQuery.of(context);
        final viewportHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : mediaQuery.size.height;
        final availableHeight = math.max(
          0.0,
          viewportHeight - mediaQuery.padding.top - AppPadding.scaffold * 2,
        );
        final sheetHeight = math.min(
          mediaQuery.size.height * _JobPickerSheet._heightFactor,
          availableHeight,
        );

        return Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: sheetHeight,
            child: Container(
              margin: const EdgeInsets.all(AppPadding.scaffold),
              padding: const EdgeInsets.all(AppPadding.bottomSheet),
              decoration: BoxDecoration(
                color: colors.backgroundElevatedNormal,
                borderRadius: BorderRadius.circular(
                  AppRadius.bottomSheetTopRadius,
                ),
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
                    style: typography.subtitle.copyWith(
                      color: colors.textStrong,
                    ),
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
                        ? _JobEmptySearchResult(query: _query)
                        : ListView.separated(
                            itemCount: filteredItems.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: AppSpacing.s4),
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final isSelected =
                                  item.code == widget.selectedCode;

                              return _JobOptionTile(
                                item: item,
                                isSelected: isSelected,
                                onTap: () =>
                                    Navigator.of(context).pop(item.code),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _JobOptionTile extends StatelessWidget {
  final JobCodebookNode item;
  final bool isSelected;
  final VoidCallback onTap;

  const _JobOptionTile({
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

class _JobEmptySearchResult extends StatelessWidget {
  final String query;

  const _JobEmptySearchResult({required this.query});

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
            query.trim().isEmpty ? '선택 가능한 직업이 없습니다.' : '검색 결과가 없습니다.',
            style: typography.bodySub.copyWith(color: colors.textAlternative),
            isTranslationKey: false,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/presentation/components/input/profile_input_search_field.dart';

/// REGION 코드북에서 검색 입력과 단계별 드롭다운을 함께 제공하는 선택 패널.
class RegionCodebookSelectionPanel extends StatefulWidget {
  /// REGION 코드북 트리.
  final RegionCodebookTree tree;

  /// 선택된 코드.
  final String? selectedCode;

  /// 선택 콜백.
  final ValueChanged<String> onSelected;

  /// 생성자.
  const RegionCodebookSelectionPanel({
    super.key,
    required this.tree,
    required this.selectedCode,
    required this.onSelected,
  });

  @override
  State<RegionCodebookSelectionPanel> createState() =>
      _RegionCodebookSelectionPanelState();
}

class _RegionCodebookSelectionPanelState
    extends State<RegionCodebookSelectionPanel> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  String? _localSelectedCode;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final selectedCode = widget.selectedCode ?? _localSelectedCode;
    final path = selectedCode == null
        ? const <RegionCodebookNode>[]
        : widget.tree.pathTo(selectedCode);
    final levels = _buildLevels(path);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s16,
      children: [
        ProfileInputSearchField(
          hintText: '지역명 또는 코드로 검색',
          controller: _controller,
          onChanged: (value) => setState(() => _query = value.trim()),
          showClearButton: _controller.text.isNotEmpty,
          onClear: () {
            _controller.clear();
            setState(() => _query = '');
          },
        ),
        Column(
          spacing: AppSpacing.s16,
          children: [
            for (var index = 0; index < levels.length; index++)
              _RegionDropdownField(
                label: _levelLabel(index),
                hintText: _levelHint(index),
                value: levels[index].selectedCode,
                items: levels[index].options,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _localSelectedCode = value);
                  widget.onSelected(value);
                },
              ),
          ],
        ),
        DefaultText(
          '검색으로 옵션을 좁히고, 드롭다운으로 최상위부터 하위까지 순차 선택합니다.',
          style: typography.bodySub.copyWith(color: colors.textAlternative),
          isTranslationKey: false,
        ),
      ],
    );
  }

  List<_RegionDropdownLevel> _buildLevels(List<RegionCodebookNode> path) {
    final levels = <_RegionDropdownLevel>[];
    String? parentCode;
    var depth = 0;

    while (true) {
      final options = widget.tree.childrenOf(parentCode).where((node) {
        final query = _query.toLowerCase();
        if (query.isEmpty) return true;
        return node.codeName.toLowerCase().contains(query) ||
            node.code.toLowerCase().contains(query);
      }).toList();

      if (options.isEmpty) break;

      final selectedNode = depth < path.length ? path[depth] : null;
      final selectedCode =
          options.any((node) => node.code == selectedNode?.code)
          ? selectedNode?.code
          : null;

      levels.add(
        _RegionDropdownLevel(options: options, selectedCode: selectedCode),
      );

      if (selectedNode == null || selectedCode == null) break;
      parentCode = selectedCode;
      depth += 1;
    }

    return levels;
  }

  String _levelLabel(int level) {
    if (level == 0) return '시/도';
    if (level == 1) return '시/군/구';
    if (level == 2) return '읍/면/동';
    return '하위 지역 ${level + 1}';
  }

  String _levelHint(int level) {
    if (level == 0) return '상위 지역 선택';
    if (level == 1) return '중간 지역 선택';
    return '하위 지역 선택';
  }
}

class _RegionDropdownLevel {
  final List<RegionCodebookNode> options;
  final String? selectedCode;

  const _RegionDropdownLevel({
    required this.options,
    required this.selectedCode,
  });
}

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

    return _PanelShell(
      title: label,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.iosStyle),
          ),
        ),
        items: [
          for (final item in items)
            DropdownMenuItem<String>(
              value: item.code,
              child: Text('${item.codeName} (${item.code})'),
            ),
        ],
        onChanged: onChanged,
        style: typography.bodySub.copyWith(color: colors.textNormal),
      ),
    );
  }
}

class _PanelShell extends StatelessWidget {
  final String title;
  final Widget child;

  const _PanelShell({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.strokeStructuralBorder),
        borderRadius: BorderRadius.circular(AppRadius.iosStyle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.cardHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.s12,
          children: [
            Text(title, style: context.typography.bodySub),
            child,
          ],
        ),
      ),
    );
  }
}

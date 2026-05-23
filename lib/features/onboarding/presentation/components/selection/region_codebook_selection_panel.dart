import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/icons/default_icon.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/presentation/components/input/profile_input_search_field.dart';
import 'package:wingle/features/onboarding/presentation/providers/region_codebook_provider.dart';

part 'region_codebook_dropdown_field.dart';
part 'region_codebook_picker_sheet.dart';

/// REGION 코드북 선택 결과.
class RegionCodebookSelection {
  /// 선택된 코드.
  final String code;

  /// 최상위부터 선택 코드까지의 경로.
  final List<RegionCodebookNode> path;

  /// 생성자.
  const RegionCodebookSelection({required this.code, required this.path});

  /// 검색/저장에 사용할 경로명 문자열.
  String get query => path.map((node) => node.codeName).join(' ');
}

/// REGION 코드북에서 검색 입력과 단계별 드롭다운을 함께 제공하는 선택 패널.
class RegionCodebookSelectionPanel extends ConsumerStatefulWidget {
  /// REGION 코드북 트리 override.
  ///
  /// Widgetbook preview처럼 외부 snapshot으로 렌더링할 때만 전달한다.
  final RegionCodebookTree? tree;

  /// 선택된 코드.
  final String? selectedCode;

  /// 선택 콜백.
  final ValueChanged<RegionCodebookSelection> onSelected;

  /// 생성자.
  const RegionCodebookSelectionPanel({
    super.key,
    this.tree,
    required this.selectedCode,
    required this.onSelected,
  });

  @override
  ConsumerState<RegionCodebookSelectionPanel> createState() =>
      _RegionCodebookSelectionPanelState();
}

class _RegionCodebookSelectionPanelState
    extends ConsumerState<RegionCodebookSelectionPanel> {
  String? _localSelectedCode;

  @override
  Widget build(BuildContext context) {
    final RegionCodebookTree tree =
        widget.tree ?? ref.watch(regionCodebookTreeProvider);
    final selectedCode = widget.selectedCode ?? _localSelectedCode;
    final path = selectedCode == null
        ? const <RegionCodebookNode>[]
        : tree.pathTo(selectedCode);
    final levels = _buildLevels(tree, path);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s16,
      children: [
        for (var index = 0; index < levels.length; index++)
          _RegionDropdownField(
            label: _levelLabel(index, levels[index].options),
            hintText: _levelHint(index, levels[index].options),
            value: levels[index].selectedCode,
            items: levels[index].options,
            onChanged: (value) {
              if (value == null) return;
              final nextPath = tree.pathTo(value);
              setState(() => _localSelectedCode = value);
              widget.onSelected(
                RegionCodebookSelection(code: value, path: nextPath),
              );
            },
          ),
      ],
    );
  }

  List<_RegionDropdownLevel> _buildLevels(
    RegionCodebookTree tree,
    List<RegionCodebookNode> path,
  ) {
    final levels = <_RegionDropdownLevel>[];
    String? parentCode;
    var depth = 0;

    while (true) {
      final options = tree.childrenOf(parentCode);

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

  String _levelLabel(int level, List<RegionCodebookNode> options) {
    if (level == 0) return '시/도';
    if (level == 1) return '시/군/구';
    if (_allNamesEndWith(options, '구')) return '구';
    if (_allNamesEndWithAny(options, const ['읍', '면', '동'])) return '읍/면/동';
    if (level == 2) return '읍/면/동';
    return '하위 지역 ${level + 1}';
  }

  String _levelHint(int level, List<RegionCodebookNode> options) {
    if (level == 0) return '상위 지역 선택';
    if (level == 1) return '중간 지역 선택';
    if (_allNamesEndWith(options, '구')) return '구 선택';
    return '하위 지역 선택';
  }

  bool _allNamesEndWith(List<RegionCodebookNode> options, String suffix) {
    return options.isNotEmpty &&
        options.every((option) => option.codeName.endsWith(suffix));
  }

  bool _allNamesEndWithAny(
    List<RegionCodebookNode> options,
    List<String> suffixes,
  ) {
    return options.isNotEmpty &&
        options.every(
          (option) =>
              suffixes.any((suffix) => option.codeName.endsWith(suffix)),
        );
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

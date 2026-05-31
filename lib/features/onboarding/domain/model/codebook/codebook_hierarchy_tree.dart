import 'codebook_entry.dart';
import 'codebook_snapshot.dart';

/// 코드북 항목의 부모 코드를 보정하는 함수.
typedef CodebookParentCodeResolver =
    String? Function(
      CodebookEntry entry,
      Map<String, CodebookEntry> entriesByCode,
    );

/// 코드북 항목 포함 여부를 결정하는 함수.
typedef CodebookEntryPredicate =
    bool Function(
      CodebookEntry entry,
      Map<String, CodebookEntry> entriesByCode,
    );

/// 코드북 항목 표시명을 보정하는 함수.
typedef CodebookEntryCodeNameResolver =
    String Function(
      CodebookEntry entry,
      Map<String, CodebookEntry> entriesByCode,
    );

/// parentCode 기반 계층형 코드북 노드.
class CodebookHierarchyNode {
  /// 코드.
  final String code;

  /// 코드명.
  final String codeName;

  /// 부모 코드.
  final String? parentCode;

  /// 자식 노드.
  final List<CodebookHierarchyNode> children;

  /// 생성자.
  const CodebookHierarchyNode({
    required this.code,
    required this.codeName,
    required this.parentCode,
    required this.children,
  });

  /// 루트 여부.
  bool get isRoot => parentCode == null;
}

/// parentCode 기반 계층형 코드북 트리.
class CodebookHierarchyTree {
  /// 루트 노드 목록.
  final List<CodebookHierarchyNode> roots;

  /// 코드 인덱스.
  final Map<String, CodebookHierarchyNode> _index;

  const CodebookHierarchyTree._({
    required this.roots,
    required Map<String, CodebookHierarchyNode> index,
  }) : _index = index;

  /// 스냅샷으로부터 트리를 생성한다.
  factory CodebookHierarchyTree.fromSnapshot(
    CodebookSnapshot snapshot, {
    CodebookParentCodeResolver? resolveParentCode,
    CodebookEntryPredicate? includeEntry,
    CodebookEntryCodeNameResolver? resolveCodeName,
  }) {
    final originalEntriesByCode = {
      for (final entry in snapshot.codes) entry.code: entry,
    };
    final entries = [
      for (final entry in snapshot.codes)
        if (includeEntry?.call(entry, originalEntriesByCode) ?? true)
          CodebookEntry(
            code: entry.code,
            codeName:
                resolveCodeName?.call(entry, originalEntriesByCode) ??
                entry.codeName,
            parentCode: entry.parentCode,
            displayOrder: entry.displayOrder,
          ),
    ];
    final parentByCode = <String, String?>{};
    final childrenByParent = <String, List<CodebookEntry>>{};

    for (final entry in entries) {
      final rawParentCode = resolveParentCode == null
          ? entry.parentCode
          : resolveParentCode(entry, originalEntriesByCode);
      final parentCode = _normalizeParentCode(rawParentCode);
      parentByCode[entry.code] = parentCode;
      if (parentCode == null || parentCode.isEmpty) continue;
      childrenByParent
          .putIfAbsent(parentCode, () => <CodebookEntry>[])
          .add(entry);
    }

    final index = <String, CodebookHierarchyNode>{};

    CodebookHierarchyNode buildNode(CodebookEntry entry) {
      final rawChildren =
          childrenByParent[entry.code] ?? const <CodebookEntry>[];
      final children = [...rawChildren]..sort(_compareEntries);
      final node = CodebookHierarchyNode(
        code: entry.code,
        codeName: entry.codeName,
        parentCode: parentByCode[entry.code],
        children: [for (final child in children) buildNode(child)],
      );
      index[entry.code] = node;
      return node;
    }

    final roots = [
      for (final entry in entries.where(
        (entry) => parentByCode[entry.code] == null,
      ))
        entry,
    ]..sort(_compareEntries);

    return CodebookHierarchyTree._(
      roots: [for (final entry in roots) buildNode(entry)],
      index: index,
    );
  }

  /// 코드로 노드를 조회한다.
  CodebookHierarchyNode? findByCode(String code) => _index[code];

  /// 부모 코드 기준 자식 목록을 반환한다.
  List<CodebookHierarchyNode> childrenOf(String? parentCode) {
    if (parentCode == null) {
      return roots;
    }
    return _index[parentCode]?.children ?? const <CodebookHierarchyNode>[];
  }

  /// 코드 경로를 찾는다.
  List<CodebookHierarchyNode> pathTo(String code) {
    final path = <CodebookHierarchyNode>[];
    var current = _index[code];
    while (current != null) {
      path.add(current);
      current = current.parentCode == null ? null : _index[current.parentCode!];
    }
    return path.reversed.toList(growable: false);
  }

  static int _compareEntries(CodebookEntry left, CodebookEntry right) {
    final nameCompare = left.codeName.compareTo(right.codeName);
    if (nameCompare != 0) return nameCompare;
    return left.code.compareTo(right.code);
  }

  static String? _normalizeParentCode(String? parentCode) {
    if (parentCode == null || parentCode.isEmpty) return null;
    return parentCode;
  }
}

/// RouteNode
class RouteNode {
  /// 자신의 이름
  final String name;

  /// 부모 노드
  final RouteNode? parent;

  /// const 생성자
  const RouteNode({required this.name, this.parent});

  /// 부모 유무에 따른 경로
  /// parent가 null이면 '/'를 추가
  String get path {
    if (parent == null) return '/$name';
    return name;
  }

  /// 부모 노드의 경로를 포함한 전체 경로
  String get fullPath {
    final RouteNode? before = parent;
    if (before != null) {
      return '${before.fullPath}$path';
    }
    return path;
  }
}

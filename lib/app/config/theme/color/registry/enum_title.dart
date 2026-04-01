// ignore_for_file: public_member_api_docs

extension TitleCaseString on String {
  /// camelCase 또는 snake_case 문자열을 사람이 읽는 제목으로 변환합니다.
  String get title {
    final words = replaceAll('_', ' ')
        .replaceAllMapped(
          RegExp(r'(?<=[a-z0-9])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])'),
          (_) => ' ',
        )
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map(_capitalize)
        .toList();

    return words.join(' ');
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }
}

extension EnumTitle on Enum {
  /// enum 이름을 사람이 읽는 제목으로 변환합니다.
  String get title => name.title;
}

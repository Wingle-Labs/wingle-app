import 'package:wingle/features/onboarding/domain/model/codebook/codebook_group.dart';

/// 코드북 버전 맵.
class CodebookVersionMap {
  /// 그룹별 버전
  final Map<CodebookGroup, int> versions;

  /// 생성자
  const CodebookVersionMap({required this.versions});

  /// 빈 값.
  const CodebookVersionMap.empty() : versions = const {};

  /// JSON에서 생성한다.
  factory CodebookVersionMap.fromJson(Map<String, dynamic> json) {
    final versions = <CodebookGroup, int>{};

    for (final entry in json.entries) {
      CodebookGroup? group;
      for (final candidate in CodebookGroup.values) {
        if (candidate.code == entry.key) {
          group = candidate;
          break;
        }
      }
      if (group == null) {
        continue;
      }

      versions[group] = entry.value is num
          ? entry.value.toInt()
          : int.tryParse(entry.value.toString()) ?? 0;
    }

    return CodebookVersionMap(versions: versions);
  }

  /// 서버 응답 맵에서 생성한다.
  factory CodebookVersionMap.fromRemoteMap(Map<String, dynamic> json) {
    return CodebookVersionMap.fromJson(json);
  }

  /// JSON으로 변환한다.
  Map<String, dynamic> toJson() {
    return {for (final entry in versions.entries) entry.key.code: entry.value};
  }
}

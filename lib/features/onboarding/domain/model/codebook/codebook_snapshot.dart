import 'package:wingle/features/onboarding/domain/model/codebook/codebook_entry.dart';

/// 코드북 스냅샷.
class CodebookSnapshot {
  /// 버전
  final int version;

  /// 코드 목록
  final List<CodebookEntry> codes;

  /// 생성자
  const CodebookSnapshot({required this.version, required this.codes});

  /// JSON에서 생성한다.
  factory CodebookSnapshot.fromJson(Map<String, dynamic> json) {
    final rawVersion = json['version'];
    final rawCodes = json['codes'] as List<dynamic>? ?? <dynamic>[];
    return CodebookSnapshot(
      version: rawVersion is num
          ? rawVersion.toInt()
          : int.tryParse(rawVersion?.toString() ?? '') ?? 0,
      codes: rawCodes
          .map((value) => CodebookEntry.fromJson(value as Map<String, dynamic>))
          .toList(),
    );
  }

  /// JSON으로 변환한다.
  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'codes': codes.map((value) => value.toJson()).toList(),
    };
  }
}

import 'codebook_group.dart';
export 'codebook_entry.dart';
export 'codebook_group.dart';
export 'codebook_hierarchy_tree.dart';
export 'codebook_snapshot.dart';
export 'codebook_version_map.dart';
export 'job_codebook_tree.dart';
export 'region_codebook_tree.dart';

/// 코드북 상세 항목 별칭.
typedef CodebookEntry = CommonCodeDetail;

/// 코드북 스냅샷 별칭.
typedef CodebookSnapshot = CodeSnapshot;

/// 코드북 버전 맵 별칭.
typedef CodebookVersionMap = VersionMap;

/// 현재 버전 응답.
class CurrentVersionResponse {
  /// 현재 버전
  final int version;

  /// 생성자
  const CurrentVersionResponse({required this.version});

  /// JSON에서 생성한다.
  factory CurrentVersionResponse.fromJson(Map<String, dynamic> json) {
    final rawVersion = json['version'];
    return CurrentVersionResponse(
      version: rawVersion is num
          ? rawVersion.toInt()
          : int.parse(rawVersion.toString()),
    );
  }
}

/// 약관 스냅샷 응답.
class TermSnapshot {
  /// 스냅샷 버전
  final int version;

  /// 약관 목록
  final List<TermDetail> terms;

  /// 생성자
  const TermSnapshot({required this.version, required this.terms});

  /// JSON에서 생성한다.
  factory TermSnapshot.fromJson(Map<String, dynamic> json) {
    final rawVersion = json['version'];
    final rawTerms = json['terms'] as List<dynamic>? ?? <dynamic>[];
    return TermSnapshot(
      version: rawVersion is num
          ? rawVersion.toInt()
          : int.parse(rawVersion.toString()),
      terms: rawTerms.map((e) => TermDetail.fromJson(_asJsonMap(e))).toList(),
    );
  }
}

/// 약관 상세.
class TermDetail {
  /// 약관 타입
  final String type;

  /// Markdown 본문
  final String content;

  /// 필수 여부
  final bool isRequired;

  /// 버전
  final int version;

  /// 생성자
  const TermDetail({
    required this.type,
    required this.content,
    required this.isRequired,
    required this.version,
  });

  /// JSON에서 생성한다.
  factory TermDetail.fromJson(Map<String, dynamic> json) {
    final rawVersion = json['version'];
    return TermDetail(
      type: json['type']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      isRequired: json['isRequired'] as bool? ?? false,
      version: rawVersion is num
          ? rawVersion.toInt()
          : int.parse(rawVersion.toString()),
    );
  }
}

/// 공통 코드 스냅샷.
class CodeSnapshot {
  /// 스냅샷 버전
  final int version;

  /// 코드 목록
  final List<CommonCodeDetail> codes;

  /// 생성자
  const CodeSnapshot({required this.version, required this.codes});

  /// JSON에서 생성한다.
  factory CodeSnapshot.fromJson(Map<String, dynamic> json) {
    final rawVersion = json['version'];
    final rawCodes = json['codes'] as List<dynamic>? ?? <dynamic>[];
    return CodeSnapshot(
      version: rawVersion is num
          ? rawVersion.toInt()
          : int.parse(rawVersion.toString()),
      codes: rawCodes
          .map((e) => CommonCodeDetail.fromJson(_asJsonMap(e)))
          .toList(),
    );
  }

  /// JSON으로 변환한다.
  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'codes': codes
          .map(
            (value) => {
              'code': value.code,
              'codeName': value.codeName,
              'parentCode': value.parentCode,
              'displayOrder': value.displayOrder,
            },
          )
          .toList(),
    };
  }
}

/// 공통 코드 상세.
class CommonCodeDetail {
  /// 코드
  final String code;

  /// 코드명
  final String codeName;

  /// 부모 코드
  final String? parentCode;

  /// 표시 순서
  final int displayOrder;

  /// 생성자
  const CommonCodeDetail({
    required this.code,
    required this.codeName,
    required this.displayOrder,
    this.parentCode,
  });

  /// JSON에서 생성한다.
  factory CommonCodeDetail.fromJson(Map<String, dynamic> json) {
    final rawDisplayOrder = json['displayOrder'];
    return CommonCodeDetail(
      code: json['code']?.toString() ?? '',
      codeName: json['codeName']?.toString() ?? '',
      parentCode: json['parentCode']?.toString(),
      displayOrder: rawDisplayOrder is num
          ? rawDisplayOrder.toInt()
          : int.parse(rawDisplayOrder?.toString() ?? '0'),
    );
  }
}

/// 코드북 버전 맵.
class VersionMap {
  /// 그룹별 버전.
  final Map<CodebookGroup, int> versions;

  /// 생성자.
  const VersionMap({required this.versions});

  /// 빈 버전 맵.
  const VersionMap.empty() : versions = const {};

  /// 원격 응답에서 생성한다.
  factory VersionMap.fromRemoteMap(Map<String, dynamic> json) {
    final versions = <CodebookGroup, int>{};

    for (final entry in json.entries) {
      CodebookGroup? group;
      for (final candidate in CodebookGroup.values) {
        if (candidate.code == entry.key) {
          group = candidate;
          break;
        }
      }
      if (group == null) continue;

      final rawVersion = entry.value;
      final version = rawVersion is num
          ? rawVersion.toInt()
          : int.tryParse(rawVersion.toString()) ?? 0;
      if (version > 0) {
        versions[group] = version;
      }
    }

    return VersionMap(versions: versions);
  }

  /// JSON으로 변환한다.
  Map<String, dynamic> toJson() {
    return {for (final entry in versions.entries) entry.key.code: entry.value};
  }
}

/// 객관식 질문 세트 스냅샷.
class ChoiceQuestionSetSnapshot {
  /// 스냅샷 버전
  final int version;

  /// 질문 목록
  final List<ChoiceQuestionDetail> questions;

  /// 생성자
  const ChoiceQuestionSetSnapshot({
    required this.version,
    required this.questions,
  });

  /// JSON에서 생성한다.
  factory ChoiceQuestionSetSnapshot.fromJson(Map<String, dynamic> json) {
    final rawVersion = json['version'];
    final rawQuestions = json['questions'] as List<dynamic>? ?? <dynamic>[];
    return ChoiceQuestionSetSnapshot(
      version: rawVersion is num
          ? rawVersion.toInt()
          : int.parse(rawVersion.toString()),
      questions: rawQuestions
          .map((e) => ChoiceQuestionDetail.fromJson(_asJsonMap(e)))
          .toList(),
    );
  }

  /// JSON으로 변환한다.
  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'questions': questions.map((value) => value.toJson()).toList(),
    };
  }
}

/// 객관식 질문 상세.
class ChoiceQuestionDetail {
  /// 질문 ID
  final int id;

  /// 질문 내용
  final String content;

  /// 선택지 목록
  final List<ChoiceQuestionOption> options;

  /// 생성자
  const ChoiceQuestionDetail({
    required this.id,
    required this.content,
    required this.options,
  });

  /// JSON에서 생성한다.
  factory ChoiceQuestionDetail.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final rawOptions = json['options'] as List<dynamic>? ?? <dynamic>[];
    return ChoiceQuestionDetail(
      id: rawId is num ? rawId.toInt() : int.parse(rawId.toString()),
      content: json['content']?.toString() ?? '',
      options: rawOptions
          .map((e) => ChoiceQuestionOption.fromJson(_asJsonMap(e)))
          .toList(),
    );
  }

  /// JSON으로 변환한다.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'options': options.map((value) => value.toJson()).toList(),
    };
  }
}

/// 객관식 질문 선택지.
class ChoiceQuestionOption {
  /// 선택지 ID
  final int id;

  /// 선택지 내용
  final String content;

  /// 생성자
  const ChoiceQuestionOption({required this.id, required this.content});

  /// JSON에서 생성한다.
  factory ChoiceQuestionOption.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return ChoiceQuestionOption(
      id: rawId is num ? rawId.toInt() : int.parse(rawId.toString()),
      content: json['content']?.toString() ?? '',
    );
  }

  /// JSON으로 변환한다.
  Map<String, dynamic> toJson() {
    return {'id': id, 'content': content};
  }
}

/// 주관식 질문 스냅샷.
class EssayQuestionSnapshot {
  /// 스냅샷 버전
  final int version;

  /// 질문 목록
  final List<EssayQuestionDetail> questions;

  /// 생성자
  const EssayQuestionSnapshot({required this.version, required this.questions});

  /// JSON에서 생성한다.
  factory EssayQuestionSnapshot.fromJson(Map<String, dynamic> json) {
    final rawVersion = json['version'];
    final rawQuestions = json['questions'] as List<dynamic>? ?? <dynamic>[];
    return EssayQuestionSnapshot(
      version: rawVersion is num
          ? rawVersion.toInt()
          : int.parse(rawVersion.toString()),
      questions: rawQuestions
          .map((e) => EssayQuestionDetail.fromJson(_asJsonMap(e)))
          .toList(),
    );
  }
}

/// 주관식 질문 상세.
class EssayQuestionDetail {
  /// 질문 ID
  final int id;

  /// 질문 내용
  final String content;

  /// 필수 여부
  final bool isRequired;

  /// 정렬 순서
  final int sortOrder;

  /// 생성자
  const EssayQuestionDetail({
    required this.id,
    required this.content,
    required this.isRequired,
    required this.sortOrder,
  });

  /// JSON에서 생성한다.
  factory EssayQuestionDetail.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final rawSortOrder = json['sortOrder'];
    return EssayQuestionDetail(
      id: rawId is num ? rawId.toInt() : int.parse(rawId.toString()),
      content: json['content']?.toString() ?? '',
      isRequired: json['isRequire'] as bool? ?? false,
      sortOrder: rawSortOrder is num
          ? rawSortOrder.toInt()
          : int.parse(rawSortOrder.toString()),
    );
  }
}

Map<String, dynamic> _asJsonMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  throw FormatException('Expected JSON object, got ${value.runtimeType}.');
}

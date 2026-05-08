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
      terms: rawTerms
          .map((e) => TermDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
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
          .map((e) => CommonCodeDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
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

  /// 생성자
  const CommonCodeDetail({
    required this.code,
    required this.codeName,
    this.parentCode,
  });

  /// JSON에서 생성한다.
  factory CommonCodeDetail.fromJson(Map<String, dynamic> json) {
    return CommonCodeDetail(
      code: json['code']?.toString() ?? '',
      codeName: json['codeName']?.toString() ?? '',
      parentCode: json['parentCode']?.toString(),
    );
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
          .map((e) => ChoiceQuestionDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
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
          .map((e) => ChoiceQuestionOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
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
          .map((e) => EssayQuestionDetail.fromJson(e as Map<String, dynamic>))
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

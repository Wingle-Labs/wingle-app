/// 질문 타입
enum QuestionType {
  /// 객관식
  objective,

  /// 주관식
  subjective;

  /// API 전송용 값
  String get apiValue => name.toUpperCase();

  /// JSON 문자열에서 질문 타입을 만든다.
  static QuestionType fromApiValue(String? value) {
    switch (value?.toUpperCase()) {
      case 'OBJECTIVE':
        return QuestionType.objective;
      case 'SUBJECTIVE':
        return QuestionType.subjective;
      default:
        throw FormatException('알 수 없는 질문 타입: $value');
    }
  }
}

/// 질문 선택지 DTO
class QuestionOptionDto {
  /// 선택지 ID
  final int id;

  /// 노출 순서
  final int order;

  /// 선택지 내용
  final String content;

  /// 생성자
  const QuestionOptionDto({
    required this.id,
    required this.order,
    required this.content,
  });

  /// JSON에서 생성한다.
  factory QuestionOptionDto.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final rawOrder = json['order'];

    return QuestionOptionDto(
      id: rawId is num ? rawId.toInt() : int.parse(rawId.toString()),
      order: rawOrder is num
          ? rawOrder.toInt()
          : int.parse(rawOrder.toString()),
      content: json['content']?.toString() ?? '',
    );
  }

  /// JSON으로 변환한다.
  Map<String, dynamic> toJson() {
    return {'id': id, 'order': order, 'content': content};
  }
}

/// 질문 DTO
class QuestionDto {
  /// 질문 ID
  final String id;

  /// 질문 타입
  final QuestionType type;

  /// 카테고리
  final String? category;

  /// 질문 내용
  final String content;

  /// 선택지 목록
  final List<QuestionOptionDto>? options;

  /// 생성자
  const QuestionDto({
    required this.id,
    required this.type,
    required this.category,
    required this.content,
    required this.options,
  });

  /// JSON에서 생성한다.
  factory QuestionDto.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];

    return QuestionDto(
      id: json['id']?.toString() ?? '',
      type: QuestionType.fromApiValue(json['type']?.toString()),
      category: json['category']?.toString(),
      content: json['content']?.toString() ?? '',
      options: rawOptions is List
          ? rawOptions
                .map(
                  (e) => QuestionOptionDto.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
    );
  }
}

/// 객관식 질문 답변
class ObjectiveQuestionAnswer {
  /// 질문 ID
  final int questionId;

  /// 선택된 선택지 ID
  final int selectedOptionId;

  /// 생성자
  const ObjectiveQuestionAnswer({
    required this.questionId,
    required this.selectedOptionId,
  });

  /// JSON으로 변환한다.
  Map<String, dynamic> toJson() {
    return {'questionId': questionId, 'optionId': selectedOptionId};
  }
}

/// 객관식 질문 답변 묶음
class ObjectiveQuestionAnswers {
  /// 연애 관련 답변
  final List<ObjectiveQuestionAnswer> datingAnswers;

  /// 생활 관련 답변
  final List<ObjectiveQuestionAnswer> lifeStyleAnswers;

  /// 커리어/재정 관련 답변
  final List<ObjectiveQuestionAnswer> careerFinanceAnswers;

  /// 성격 관련 답변
  final List<ObjectiveQuestionAnswer> personalityAnswers;

  /// 가족 관련 답변
  final List<ObjectiveQuestionAnswer> familyAnswers;

  /// 생성자
  const ObjectiveQuestionAnswers({
    required this.datingAnswers,
    required this.lifeStyleAnswers,
    required this.careerFinanceAnswers,
    required this.personalityAnswers,
    required this.familyAnswers,
  });

  /// JSON으로 변환한다.
  Map<String, dynamic> toJson() {
    return {
      'answers': [
        ...datingAnswers,
        ...lifeStyleAnswers,
        ...careerFinanceAnswers,
        ...personalityAnswers,
        ...familyAnswers,
      ].map((e) => e.toJson()).toList(),
    };
  }
}

/// 주관식 질문 답변
class SubjectiveQuestionAnswer {
  /// 질문 ID
  final int questionId;

  /// 답변 내용
  final String content;

  /// 생성자
  const SubjectiveQuestionAnswer({
    required this.questionId,
    required this.content,
  });

  /// JSON으로 변환한다.
  Map<String, dynamic> toJson() {
    return {'questionId': questionId, 'content': content};
  }
}

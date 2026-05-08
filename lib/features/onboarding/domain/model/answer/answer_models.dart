/// 객관식 답변 저장 항목.
class ChoiceAnswerItem {
  /// 질문 ID
  final int questionId;

  /// 선택지 ID
  final int optionId;

  /// 생성자
  const ChoiceAnswerItem({required this.questionId, required this.optionId});

  /// JSON으로 변환한다.
  Map<String, dynamic> toJson() {
    return {'questionId': questionId, 'optionId': optionId};
  }
}

/// 저장된 객관식 답변.
class ChoiceAnswerResult {
  /// 질문 ID
  final int questionId;

  /// 질문 내용
  final String questionContent;

  /// 선택지 ID
  final int optionId;

  /// 선택지 내용
  final String optionContent;

  /// 생성자
  const ChoiceAnswerResult({
    required this.questionId,
    required this.questionContent,
    required this.optionId,
    required this.optionContent,
  });

  /// JSON에서 생성한다.
  factory ChoiceAnswerResult.fromJson(Map<String, dynamic> json) {
    final rawQuestionId = json['questionId'];
    final rawOptionId = json['optionId'];
    return ChoiceAnswerResult(
      questionId: rawQuestionId is num
          ? rawQuestionId.toInt()
          : int.parse(rawQuestionId.toString()),
      questionContent: json['questionContent']?.toString() ?? '',
      optionId: rawOptionId is num
          ? rawOptionId.toInt()
          : int.parse(rawOptionId.toString()),
      optionContent: json['optionContent']?.toString() ?? '',
    );
  }
}

/// 주관식 답변 저장 항목.
class EssayAnswerItem {
  /// 질문 ID
  final int questionId;

  /// 답변 내용
  final String content;

  /// 생성자
  const EssayAnswerItem({required this.questionId, required this.content});

  /// JSON으로 변환한다.
  Map<String, dynamic> toJson() {
    return {'questionId': questionId, 'content': content};
  }
}

/// 저장된 주관식 답변.
class EssayAnswerResult {
  /// 질문 ID
  final int questionId;

  /// 질문 내용
  final String questionContent;

  /// 필수 여부
  final bool isRequired;

  /// 답변 내용
  final String content;

  /// 생성자
  const EssayAnswerResult({
    required this.questionId,
    required this.questionContent,
    required this.isRequired,
    required this.content,
  });

  /// JSON에서 생성한다.
  factory EssayAnswerResult.fromJson(Map<String, dynamic> json) {
    final rawQuestionId = json['questionId'];
    return EssayAnswerResult(
      questionId: rawQuestionId is num
          ? rawQuestionId.toInt()
          : int.parse(rawQuestionId.toString()),
      questionContent: json['questionContent']?.toString() ?? '',
      isRequired: json['isRequire'] as bool? ?? false,
      content: json['content']?.toString() ?? '',
    );
  }
}

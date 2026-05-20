/// Widgetbook에서 사용할 코드북 스토리 정의.
class CodebookStorySpec {
  /// 코드북 키.
  final String key;

  /// 화면 표시 라벨.
  final String label;

  /// 생성자.
  const CodebookStorySpec({required this.key, required this.label});
}

/// 코드북 스토리 키 목록.
const codebookStorySpecs = <CodebookStorySpec>[
  CodebookStorySpec(key: 'QUESTION_CATEGORY', label: 'Question Category'),
  CodebookStorySpec(key: 'JOB', label: 'Job'),
  CodebookStorySpec(key: 'UNIVERSITY', label: 'University'),
  CodebookStorySpec(key: 'BODY_TYPE', label: 'Body Type'),
  CodebookStorySpec(key: 'REGION', label: 'Region'),
];

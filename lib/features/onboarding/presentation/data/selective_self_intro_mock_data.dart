/// 선택형 자기소개 탭 키 목록
const selectiveSelfIntroTabKeys = [
  'onboarding.selectiveSelfIntro.tabs.dating',
  'onboarding.selectiveSelfIntro.tabs.marriage',
  'onboarding.selectiveSelfIntro.tabs.personality',
  'onboarding.selectiveSelfIntro.tabs.career',
  'onboarding.selectiveSelfIntro.tabs.lifestyle',
];

/// 선택형 자기소개 목업 질문 모델
class SelectiveSelfIntroQuestionMock {
  /// 질문 키
  final String questionKey;

  /// 답변 키 목록
  final List<String> answerKeys;

  /// 답변 선택 상태
  final List<bool> answerStates;

  /// 생성자
  const SelectiveSelfIntroQuestionMock({
    required this.questionKey,
    required this.answerKeys,
    required this.answerStates,
  });
}

/// 선택형 자기소개 목업 데이터
const selectiveSelfIntroQuestionMocks = [
  SelectiveSelfIntroQuestionMock(
    questionKey: 'onboarding.selectiveSelfIntro.questions.first.title',
    answerKeys: [
      'onboarding.selectiveSelfIntro.questions.first.answers.first',
      'onboarding.selectiveSelfIntro.questions.first.answers.second',
      'onboarding.selectiveSelfIntro.questions.first.answers.third',
    ],
    answerStates: [true, false, false],
  ),
  SelectiveSelfIntroQuestionMock(
    questionKey: 'onboarding.selectiveSelfIntro.questions.second.title',
    answerKeys: [
      'onboarding.selectiveSelfIntro.questions.second.answers.first',
      'onboarding.selectiveSelfIntro.questions.second.answers.second',
      'onboarding.selectiveSelfIntro.questions.second.answers.third',
    ],
    answerStates: [false, false, true],
  ),
  SelectiveSelfIntroQuestionMock(
    questionKey: 'onboarding.selectiveSelfIntro.questions.third.title',
    answerKeys: [
      'onboarding.selectiveSelfIntro.questions.third.answers.first',
      'onboarding.selectiveSelfIntro.questions.third.answers.second',
      'onboarding.selectiveSelfIntro.questions.third.answers.third',
    ],
    answerStates: [true, false, false],
  ),
];

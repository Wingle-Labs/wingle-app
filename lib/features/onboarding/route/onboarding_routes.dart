import 'package:wingle/app/router/route_node.dart';

/// 온보딩 라우트 정의 클래스
abstract final class OnboardingRoutes {
  /// ! 온보딩 root
  static const root = RouteNode(parent: null, name: 'onboarding');

  // ! 온보딩 하위 루트
  /// 로그인
  static const login = RouteNode(parent: root, name: 'login');

  /// 회원가입
  static const signup = RouteNode(parent: root, name: 'signup');

  // ! 로그인 하위 루트
  /// 기본 프로필 정보 등록
  static const basicProfile = RouteNode(parent: login, name: 'basic-profile');

  /// 거주지 입력
  static const basicProfileResidence = RouteNode(
    parent: login,
    name: 'basic-profile-residence',
  );

  /// 키 입력
  static const basicProfileHeight = RouteNode(
    parent: login,
    name: 'basic-profile-height',
  );

  /// 체형 입력
  static const basicProfileBodyShape = RouteNode(
    parent: login,
    name: 'basic-profile-body-shape',
  );

  /// 직종 선택
  static const basicProfileCompany = RouteNode(
    parent: login,
    name: 'basic-profile-company',
  );

  /// 회사명 입력
  static const basicProfileCompanyName = RouteNode(
    parent: login,
    name: 'basic-profile-company-name',
  );

  /// 회사 이메일 인증
  static const basicProfileCompanyEmail = RouteNode(
    parent: login,
    name: 'basic-profile-company-email',
  );

  /// 학교 입력
  static const basicProfileEducation = RouteNode(
    parent: login,
    name: 'basic-profile-education',
  );

  /// 상세 프로필 MBTI 입력
  static const profileDetails = RouteNode(
    parent: login,
    name: 'profile-details',
  );

  /// 상세 프로필 스타일 사진 입력
  static const profileStylePhotos = RouteNode(
    parent: login,
    name: 'profile-style-photos',
  );

  /// 상세 프로필 얼굴 사진 입력
  static const profileFacePhotos = RouteNode(
    parent: login,
    name: 'profile-face-photos',
  );

  /// 상세 프로필 자기소개 입력
  static const profileSelfIntroduction = RouteNode(
    parent: login,
    name: 'profile-self-introduction',
  );

  /// 프로필 심사 요청
  static const approvalRequest = RouteNode(
    parent: login,
    name: 'approval-request',
  );

  /// 프로필 심사 대기
  static const approvalPending = RouteNode(
    parent: login,
    name: 'approval-pending',
  );

  /// 프로필 거절 사유 및 재심사
  static const profileRejected = RouteNode(
    parent: login,
    name: 'profile-rejected',
  );

  /// 프로필 승인 완료 안내
  static const profileApprovedWelcome = RouteNode(
    parent: login,
    name: 'profile-approved-welcome',
  );

  /// 객관식 질문 답변
  static const choiceQuestions = RouteNode(
    parent: login,
    name: 'choice-questions',
  );

  /// 비밀번호 재설정
  static const resetPassword = RouteNode(parent: login, name: 'reset-password');

  /// 전화번호 변경
  static const changePhoneNumber = RouteNode(
    parent: login,
    name: 'change-phone-number',
  );

  // ! 회원가입 하위 루트
  /// 약관 동의
  static const agreement = RouteNode(parent: signup, name: 'agreement');

  /// 전화번호 입력
  static const phone = RouteNode(parent: signup, name: 'phone');

  /// 인증번호 입력
  static const otp = RouteNode(parent: signup, name: 'otp');

  /// 나이 입력
  static const age = RouteNode(parent: signup, name: 'age');

  /// 패스 인증
  static const pass = RouteNode(parent: signup, name: 'pass');

  /// 패스 인증 웹뷰
  static const passWebView = RouteNode(parent: signup, name: 'pass-webview');

  /// 패스 인증 결과 페이지
  static const onboardingPassword = RouteNode(
    parent: signup,
    name: 'onboarding-password',
  );

  /// 필수 자기소개 입력
  static const requiredSelfIntro = RouteNode(
    parent: signup,
    name: 'required-self-intro',
  );

  /// 주관식 질문 단일 입력
  static const essayQuestionInput = RouteNode(
    parent: signup,
    name: 'essay-question-input',
  );

  /// 선택형 자기소개 입력
  static const selectiveSelfIntro = RouteNode(
    parent: signup,
    name: 'selective-self-intro',
  );

  /// 연락처 지인 제외
  static const contactBlock = RouteNode(parent: signup, name: 'contact-block');
}

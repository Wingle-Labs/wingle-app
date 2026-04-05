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

  /// 선택형 자기소개 입력
  static const selectiveSelfIntro = RouteNode(
    parent: signup,
    name: 'selective-self-intro',
  );
}

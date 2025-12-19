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
  /// 비밀번호 재설정
  static const resetPassword = RouteNode(parent: login, name: 'reset-password');

  /// 전화번호 변경
  static const changePhoneNumber = RouteNode(
    parent: login,
    name: 'change-phone-number',
  );

  // ! 회원가입 하위 루트
  /// 전화번호 입력
  static const phone = RouteNode(parent: signup, name: 'phone');

  /// 인증번호 입력
  static const otp = RouteNode(parent: signup, name: 'otp');

  /// 나이 입력
  static const age = RouteNode(parent: signup, name: 'age');

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

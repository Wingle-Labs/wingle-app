import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/common/constants/route_constants.dart';
import 'package:wingle/features/auth/domain/models/auth_code.dart';
import 'package:wingle/features/auth/domain/repositories/phone_auth_repository.dart';

/// 휴대폰 인증번호 확인
class VerifyPhoneCode {
  /// 휴대폰 인증 레포지토리
  final PhoneAuthRepository repository;

  /// 생성자
  VerifyPhoneCode(this.repository);

  /// 휴대폰 인증번호 확인
  Future<bool> call(String code) {
    if (!validateCode(code)) return Future.value(false);
    return repository.verifyCode(code);
  }

  /// 인증번호 검증
  bool validateCode(String code) {
    return AuthCode(code).isValid;
  }

  /// 인증 완료 시 나이 입력 화면으로 이동
  static void navigateToAge(BuildContext context) {
    context.push(AppRouteUtil.fullPath([.onboarding, .age]));
  }
}

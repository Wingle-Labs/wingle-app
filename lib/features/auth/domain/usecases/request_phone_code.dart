import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/features/auth/domain/models/phone_number.dart';
import 'package:wingle/features/auth/domain/repositories/phone_auth_repository.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 휴대폰 번호 인증
class RequestPhoneCode {
  /// 휴대폰 인증 레포지토리
  final PhoneAuthRepository repository;

  /// 생성자
  RequestPhoneCode(this.repository);

  /// 휴대폰 번호 인증
  Future<bool> call(String phone) {
    if (!validatePhoneNumber(phone)) return Future.value(false);
    return repository.requestCode(phone);
  }

  /// 휴대폰 번호 검증
  static bool validatePhoneNumber(String phoneNumber) {
    return PhoneNumber(phoneNumber).isValid;
  }

  /// 코드 요청 완료 시 인증 코드 입력 화면으로 이동
  static void navigateToOtp(BuildContext context) {
    context.pushNamed(OnboardingRoutes.otp.name);
  }
}

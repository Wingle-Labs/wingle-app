import 'package:flutter/material.dart';

/// 어플리케이션의 공통 색상 정의
class AppColor {
  /// 주요 색상
  static const Color primary = Color(0xFFBF00FF);

  /// 카카오 로그인 버튼 색상
  static const Color kakao = Color(0xFFFEE500);

  /// 구글 로그인 버튼 색상
  static const Color google = Color(0xFFFFFFFF);

  /// 구글 로그인 버튼 테두리 색상
  static Color googleOutlinedButtonBorder = Colors.grey.withValues(alpha: 0.6);

  /// 애플 로그인 버튼 색상
  static const Color apple = Color(0xFF000000);

  /// 애플 로그인 버튼 테두리 색상
  static Color appleOutlinedButtonBorder = Colors.grey.withValues(alpha: 0.6);

  /// 어두운 버튼 텍스트 색상
  static const Color darkButtonText = Color(0xFFFFFFFF);

  /// 밝은 버튼 텍스트 색상
  static Color lightButtonText = Color(0xFF000000);

  /// 어두운 배경
  static const Color darkBackground = Color(0xFF000000);

  /// 밝은 배경
  static const Color lightBackground = Color(0xFFFFFFFF);
}

import 'package:flutter/material.dart';

/// 어플리케이션의 공통 색상 정의
class AppColor {
  /// 주요 색상
  static const Color primary = Color(0xFFBF00FF);

  /// 카카오 로그인 버튼 색상
  static const Color kakao = Color(0xFFFEE500);

  /// 구글 로그인 버튼 색상
  static const Color google = Colors.white;

  /// 구글 로그인 버튼 테두리 색상
  static Color googleOutlinedButtonBorder = Colors.grey.withValues(alpha: 0.6);

  /// 애플 로그인 버튼 색상
  static const Color apple = Colors.black;

  /// 애플 로그인 버튼 테두리 색상
  static Color appleOutlinedButtonBorder = Colors.grey.withValues(alpha: 0.6);

  /// 어두운 버튼 텍스트 색상
  static const Color darkButtonText = Colors.white;

  /// 밝은 버튼 텍스트 색상
  static Color lightButtonText = Colors.black;

  /// 어두운 배경
  static Color darkBackground = Colors.black;

  /// 밝은 배경
  static Color lightBackground = Colors.white;

  /// 밝은 비활성화 색상
  static Color disabledLight = Colors.grey.withValues(alpha: 0.6);

  /// 어두운 비활성화 색상
  static Color disabledDark = Colors.grey.withValues(alpha: 0.2);

  /// 밝은 캡션 색상
  static Color lightCaption = Colors.grey.withValues(alpha: 0.8);

  /// 어두운 캡션 색상
  static Color darkCaption = Colors.grey.withValues(alpha: 0.6);

  /// 밝은 카드 색상
  static Color lightCard = Colors.grey.withValues(alpha: 0.05);

  /// 밝은 카드 테두리 색상
  static Color lightCardBorder = Colors.grey.withValues(alpha: 0.1);

  /// 어두운 카드 색상
  static Color darkCard = Colors.grey.withValues(alpha: 0.06);

  /// 어두운 카드 테두리 색상
  static Color darkCardBorder = Colors.grey.withValues(alpha: 0.1);
}

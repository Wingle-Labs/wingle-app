import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/weight.dart';

/// 앱 전역에서 사용하는 텍스트 스타일 토큰
class AppTypographyToken {
  // ! Display
  /// Display
  static const TextStyle display = TextStyle(
    fontSize: AppFontSize.headline,
    fontWeight: AppFontWeight.bold,
    height: 1.2,
    letterSpacing: -0.6,
    fontFamily: "Pretendard",
  );

  // ! Title
  /// 24
  static const TextStyle title22 = TextStyle(
    fontSize: AppFontSize.title,
    fontWeight: AppFontWeight.bold,
    height: 1.4,
    letterSpacing: -0.6,
    fontFamily: "Pretendard",
  );

  // ! Subtitle
  /// 서브 제목
  static const TextStyle subTitle20 = TextStyle(
    fontSize: AppFontSize.subtitle,
    fontWeight: AppFontWeight.regular,
    height: 1.4,
    letterSpacing: -0.6,
    fontFamily: "Pretendard",
  );

  // ! btn
  /// 큰 버튼 텍스트
  static const TextStyle btn16 = TextStyle(
    fontSize: AppFontSize.button,
    fontWeight: AppFontWeight.semiBold,
    height: 1.35,
    letterSpacing: -0.6,
    fontFamily: "Pretendard",
  );

  /// 작은 버튼 텍스트
  static const TextStyle btn14 = TextStyle(
    fontSize: AppFontSize.sub,
    fontWeight: AppFontWeight.semiBold,
    height: 1.35,
    letterSpacing: -0.6,
    fontFamily: "Pretendard",
  );

  /// 작은 버튼 텍스트
  static const TextStyle btn12 = TextStyle(
    fontSize: AppFontSize.caption,
    fontWeight: AppFontWeight.semiBold,
    height: 1.35,
    letterSpacing: -0.6,
    fontFamily: "Pretendard",
  );

  // ! Caption
  /// Caption
  static const TextStyle caption12 = TextStyle(
    fontSize: AppFontSize.caption,
    fontWeight: AppFontWeight.semiBold,
    height: 1.1,
    letterSpacing: -0.6,
    fontFamily: "Pretendard",
  );

  // ! Main
  /// Main
  static const TextStyle main18 = TextStyle(
    fontSize: AppFontSize.main,
    fontWeight: AppFontWeight.semiBold,
    height: 1.35,
    letterSpacing: -0.6,
    fontFamily: "Pretendard",
  );

  /// MainSub
  static const TextStyle main16 = TextStyle(
    fontSize: AppFontSize.body,
    fontWeight: AppFontWeight.semiBold,
    height: 1.4,
    letterSpacing: -0.6,
    fontFamily: "Pretendard",
  );

  /// nBody
  static const TextStyle nBody16 = TextStyle(
    fontSize: AppFontSize.body,
    fontWeight: AppFontWeight.medium,
    height: 1.4,
    letterSpacing: -0.6,
    fontFamily: "Pretendard",
  );

  /// nBodySub
  static const TextStyle nBodySub14 = TextStyle(
    fontSize: AppFontSize.sub,
    fontWeight: AppFontWeight.medium,
    height: 1.4,
    letterSpacing: -0.6,
    fontFamily: "Pretendard",
  );

  // ! Chip
  /// Chip Button
  static const TextStyle chipBtn = TextStyle(
    fontSize: AppFontSize.button,
    fontWeight: AppFontWeight.semiBold,
    height: 1.35,
    letterSpacing: -0.6,
    fontFamily: "Pretendard",
  );

  /// Chip 텍스트
  static const TextStyle chip = TextStyle(
    fontSize: AppFontSize.body,
    fontWeight: AppFontWeight.regular,
    height: 1.4,
    letterSpacing: -0.6,
    fontFamily: "Pretendard",
  );
}

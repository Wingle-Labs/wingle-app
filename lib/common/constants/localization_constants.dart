import 'package:flutter/material.dart';

/// 어플리케이션 로컬라이제이션 설정
class AppLocalization {
  /// 지원되는 로케일들
  static const supportedLocales = [Locale('en'), Locale('ko')];

  /// 번역 파일 경로.
  static const path = 'assets/translations';

  /// 번역이 없는 경우 사용할 기본 로케일.
  static const fallbackLocale = Locale('ko');
}

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/localization_constants.dart';

part 'localization_provider.g.dart';

@Riverpod(keepAlive: true)
/// 어플리케이션 로컬라이제이션
/// 어플리케이션의 다국어 지원을 관리합니다.
class Localization extends _$Localization {
  @override
  Locale build() {
    return Locale('ko');
  }

  /// 로컬라이제이션을 변경합니다.
  void changeLocale(Locale locale) {
    if (AppLocalization.supportedLocales.contains(locale)) {
      state = locale;
    }
  }
}

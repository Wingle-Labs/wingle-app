import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:value_date/common/constants/localization_constants.dart';

/// 로컬라이제이션을 초기화하고 제공하는 래퍼 위젯
/// 어플리케이션의 다국어 지원을 관리합니다.
class AppLocalizationWrapper extends ConsumerWidget {
  /// 로컬라이제이션된 자식 위젯
  /// 로컬라이제이션된 [child]를 포함할 위젯입니다.
  final Widget child;

  /// 로컬라이제이션 래퍼를 생성합니다.
  /// [child]는 로컬라이제이션된 내용을 포함할 위젯입니다.
  const AppLocalizationWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EasyLocalization(
      supportedLocales: AppLocalization.supportedLocales,
      path: AppLocalization.path,
      fallbackLocale: AppLocalization.fallbackLocale,
      child: child,
    );
  }
}

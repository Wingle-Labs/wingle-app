import 'package:flutter/foundation.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';

/// 앱 인증 세션 변경을 라우터와 공유하는 전역 상태.
abstract final class AuthSessionState {
  static final ValueNotifier<int> _version = ValueNotifier<int>(0);
  static bool _shouldRedirectToLogin = false;

  /// 라우터가 인증 상태 변경을 감지하기 위한 listenable.
  static Listenable get listenable => _version;

  /// 인증 무효화 후 로그인 화면으로 직접 보내야 하는지 여부.
  static bool get shouldRedirectToLogin => _shouldRedirectToLogin;

  /// 인증 상태가 바뀌었음을 알린다.
  static void notifyChanged({bool redirectToLogin = false}) {
    _shouldRedirectToLogin = redirectToLogin;
    _version.value += 1;
  }

  /// 유효한 로그인 세션이 저장되었음을 알린다.
  static void markAuthenticated() {
    notifyChanged();
  }

  /// 저장된 로그인 정보를 제거하고 인증 상태 변경을 알린다.
  static Future<void> clearLoginInfo({bool redirectToLogin = true}) async {
    await HiveUtil.clearBox(HiveConstants.userLoginInfo);
    notifyChanged(redirectToLogin: redirectToLogin);
  }
}

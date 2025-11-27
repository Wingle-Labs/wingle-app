/// Env 파일 이름
class EnvFileName {
  /// 환경 변수 파일 목록
  static const List<String> all = [
    firebase,
    // 추가할 다른 env 파일들
  ];

  /// Firebase 환경 변수 파일
  static const String firebase = 'lib/app/config/env/firebase.env';
}

/// Firebase 관련 Env Key
class FirebaseEnvKey {
  /// Firebase Android API 키
  static const String androidApiKey = 'FIREBASE_ANDROID_API_KEY';

  /// Firebase Android 앱 ID
  static const String androidAppId = 'FIREBASE_ANDROID_APP_ID';

  /// Firebase iOS API 키
  static const String iosApiKey = 'FIREBASE_IOS_API_KEY';

  /// Firebase iOS 앱 ID
  static const String iosAppId = 'FIREBASE_IOS_APP_ID';

  /// Firebase 메시징 발신자 ID
  static const String messagingSenderId = 'FIREBASE_MESSAGING_SENDER_ID';

  /// Firebase 프로젝트 ID
  static const String projectId = 'FIREBASE_PROJECT_ID';

  /// Firebase 스토리지 버킷
  static const String storageBucket = 'FIREBASE_STORAGE_BUCKET';

  /// Firebase iOS Bundle ID
  static const String iosBundleId = 'FIREBASE_IOS_BUNDLE_ID';
}

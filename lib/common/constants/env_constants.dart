/// Env 파일 중앙 관리
class EnvConstants {
  /// Firebase 환경 변수 파일
  static final firebase = FirebaseEnvFile();

  /// 기타 환경 변수 파일들
  static final envs = <EnvFile>[firebase];
}

/// 환경 변수 인터페이스
class EnvKey<T> {
  /// 환경 변수 경로
  final String path;

  /// 환경 변수 이름
  final String name;

  /// 환경 변수 생성자
  const EnvKey({required this.path, required this.name});
}

/// 환경 변수 형식 - 각 서비스별 환경 변수 파일을 정의하는 클래스
abstract class EnvFile {
  /// 환경 변수 키를 생성하는 메서드
  EnvKey<String> create(String key);

  /// 환경 변수 파일 경로
  String get path;
}

/// Firebase 관련 Env 파일
class FirebaseEnvFile implements EnvFile {
  @override
  String get path => 'lib/app/config/env/firebase.env';

  @override
  EnvKey<String> create(String key) {
    return EnvKey<String>(path: path, name: key);
  }

  /// Firebase Android API 키
  static EnvKey<String> androidApiKey = _instance.create(
    'FIREBASE_ANDROID_API_KEY',
  );

  /// Firebase Android 앱 ID
  static EnvKey<String> androidAppId = _instance.create(
    'FIREBASE_ANDROID_APP_ID',
  );

  /// Firebase iOS API 키
  static EnvKey<String> iosApiKey = _instance.create('FIREBASE_IOS_API_KEY');

  /// Firebase iOS 앱 ID
  static EnvKey<String> iosAppId = _instance.create('FIREBASE_IOS_APP_ID');

  /// Firebase 메시징 발신자 ID
  static EnvKey<String> messagingSenderId = _instance.create(
    'FIREBASE_MESSAGING_SENDER_ID',
  );

  /// Firebase 프로젝트 ID
  static EnvKey<String> projectId = _instance.create('FIREBASE_PROJECT_ID');

  /// Firebase 스토리지 버킷
  static EnvKey<String> storageBucket = _instance.create(
    'FIREBASE_STORAGE_BUCKET',
  );

  /// Firebase iOS Bundle ID
  static EnvKey<String> iosBundleId = _instance.create(
    'FIREBASE_IOS_BUNDLE_ID',
  );

  /// 싱글톤
  static final FirebaseEnvFile _instance = FirebaseEnvFile();
}

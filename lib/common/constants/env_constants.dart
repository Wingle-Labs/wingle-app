/// Env 파일 중앙 관리
class EnvConstants {
  /// Firebase 환경 변수 파일
  static final firebase = FirebaseEnvFile();

  /// API 환경 변수 파일
  static final api = ApiEnvFile();

  /// Portone 환경 변수 파일
  static final portone = PortoneEnvFile();

  /// Live API 테스트 환경 변수 파일
  static final liveApi = LiveApiEnvFile();

  /// 기타 환경 변수 파일들
  static final envs = <EnvFile>[firebase, api, portone, liveApi];
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

/// API 관련 Env 파일
class ApiEnvFile implements EnvFile {
  @override
  String get path => 'lib/app/config/env/api.env';

  @override
  EnvKey<String> create(String key) {
    return EnvKey<String>(path: path, name: key);
  }

  /// API Base URL
  static EnvKey<String> baseUrl = _instance.create('API_BASE_URL');

  /// Repository source selector
  static EnvKey<String> source = _instance.create('API_SOURCE');

  /// 싱글톤
  static final ApiEnvFile _instance = ApiEnvFile();
}

/// Portone 관련 Env 파일
class PortoneEnvFile implements EnvFile {
  @override
  String get path => 'lib/app/config/env/portone.env';

  @override
  EnvKey<String> create(String key) {
    return EnvKey<String>(path: path, name: key);
  }

  static final PortoneEnvFile _instance = PortoneEnvFile();

  /// 가맹점 ID
  static EnvKey<String> userCode = _instance.create('PORTONE_USER_CODE');

  /// 결제 PG
  static EnvKey<String> pg = _instance.create('PORTONE_PG');

  /// 결제 리다이렉트 URL
  static EnvKey<String> redirectUrl = _instance.create('PORTONE_REDIRECT_URL');

  /// MOCK 여부
  static EnvKey<String> setting = _instance.create('PORTONE_SETTIN');
}

/// Live API 테스트 관련 Env 파일
class LiveApiEnvFile implements EnvFile {
  @override
  String get path => 'lib/app/config/env/live_api.env';

  @override
  EnvKey<String> create(String key) {
    return EnvKey<String>(path: path, name: key);
  }

  static final LiveApiEnvFile _instance = LiveApiEnvFile();

  /// 테스트용 API base URL
  static EnvKey<String> baseUrl = _instance.create('TEST_API_BASE_URL');

  /// 테스트용 계정 ID
  static EnvKey<String> accountId = _instance.create('TEST_API_ACCOUNT_ID');

  /// 테스트용 계정 비밀번호
  static EnvKey<String> accountPassword = _instance.create(
    'TEST_API_ACCOUNT_PASSWORD',
  );

  /// 테스트용 access token
  static EnvKey<String> accessToken = _instance.create('TEST_API_ACCESS_TOKEN');

  /// 관리자 access token
  static EnvKey<String> adminAccessToken = _instance.create(
    'TEST_API_ADMIN_ACCESS_TOKEN',
  );

  /// 관리자 사용자 ID
  static EnvKey<String> adminUserId = _instance.create(
    'TEST_API_ADMIN_USER_ID',
  );

  /// 관리자 destructive 작업 허용 여부
  static EnvKey<String> adminDestructiveOk = _instance.create(
    'TEST_API_ADMIN_DESTRUCTIVE_OK',
  );

  /// 로그인용 전화번호
  static EnvKey<String> loginPhoneNumber = _instance.create(
    'TEST_API_LOGIN_PHONE_NUMBER',
  );

  /// 로그인용 비밀번호
  static EnvKey<String> loginPassword = _instance.create(
    'TEST_API_LOGIN_PASSWORD',
  );

  /// signup UUID
  static EnvKey<String> signupUuid = _instance.create('TEST_API_SIGNUP_UUID');

  /// signup 비밀번호
  static EnvKey<String> signupPassword = _instance.create(
    'TEST_API_SIGNUP_PASSWORD',
  );

  /// 연락처 업로드 대상
  static EnvKey<String> contactPhoneNumbers = _instance.create(
    'TEST_API_CONTACT_PHONE_NUMBERS',
  );
}

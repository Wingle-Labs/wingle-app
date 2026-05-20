/// HiveConstants: 모든 Box를 중앙에서 관리
class HiveConstants {
  /// 사용자 로그인 정보 Box
  static final userLoginInfo = HiveLoginBox();

  /// 코드북 메타데이터 Box
  static final codebookMetadata = HiveCodebookMetadataBox();

  /// 코드북 스냅샷 Box
  static final codebookSnapshot = HiveCodebookSnapshotBox();

  /// 객관식 질문 메타데이터 Box
  static final choiceQuestionMetadata = HiveChoiceQuestionMetadataBox();

  /// 객관식 질문 스냅샷 Box
  static final choiceQuestionSnapshot = HiveChoiceQuestionSnapshotBox();

  /// 모든 Box 목록
  static final boxes = <HiveBox>[
    userLoginInfo,
    codebookMetadata,
    codebookSnapshot,
    choiceQuestionMetadata,
    choiceQuestionSnapshot,
  ];
}

/// Hive Key 타입 정의: Key 자체가 Box 정보를 포함한다.
class HiveKey<T> {
  /// Hive Box 정보
  final HiveBox box;

  /// 키 이름
  final String name;

  /// Hive Key 생성자
  const HiveKey(this.box, this.name);
}

/// Hive Box 추상 클래스
abstract class HiveBox {
  /// Box 이름
  String get name;

  /// 암호화 여부
  bool get isEncrypted;

  /// Hive Key 생성 메서드 - 하위 클래스에서 구현해야 함
  HiveKey<String> create(String key);
}

/// user_login_info Box 정의
class HiveLoginBox implements HiveBox {
  @override
  String get name => 'user_login_info';

  @override
  bool get isEncrypted => true;

  @override
  HiveKey<String> create(String key) {
    return HiveKey<String>(this, key);
  }

  /// 로그인 ID
  static final userId = _instance.create('user_id');

  /// 사용자 비밀번호
  static final userPassword = _instance.create('user_password');

  /// 액세스 토큰
  static final accessToken = _instance.create('access_token');

  /// 리프레시 토큰
  static final refreshToken = _instance.create('refresh_token');

  /// 로그인 시 프로필 진행 상태
  static final profileStatus = _instance.create('profile_status');

  /// 로그인 시 성별
  static final gender = _instance.create('gender');

  /// 내부 싱글턴 인스턴스 (HiveKey가 Box에 접근하기 위함)
  static final HiveLoginBox _instance = HiveLoginBox();
}

/// codebook_metadata Box 정의.
class HiveCodebookMetadataBox implements HiveBox {
  @override
  String get name => 'codebook_metadata';

  @override
  bool get isEncrypted => false;

  @override
  HiveKey<String> create(String key) {
    return HiveKey<String>(this, key);
  }
}

/// codebook_snapshot Box 정의.
class HiveCodebookSnapshotBox implements HiveBox {
  @override
  String get name => 'codebook_snapshot';

  @override
  bool get isEncrypted => false;

  @override
  HiveKey<String> create(String key) {
    return HiveKey<String>(this, key);
  }
}

/// choice_question_metadata Box 정의.
class HiveChoiceQuestionMetadataBox implements HiveBox {
  @override
  String get name => 'choice_question_metadata';

  @override
  bool get isEncrypted => false;

  @override
  HiveKey<String> create(String key) {
    return HiveKey<String>(this, key);
  }
}

/// choice_question_snapshot Box 정의.
class HiveChoiceQuestionSnapshotBox implements HiveBox {
  @override
  String get name => 'choice_question_snapshot';

  @override
  bool get isEncrypted => false;

  @override
  HiveKey<String> create(String key) {
    return HiveKey<String>(this, key);
  }
}

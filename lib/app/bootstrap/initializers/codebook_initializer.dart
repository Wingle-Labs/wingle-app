import 'package:wingle/features/onboarding/data/codebook/codebook_repository_impl.dart';

/// 코드북 로컬 캐시를 서버 버전과 동기화하는 초기화 작업.
class CodebookInitializer {
  final CodebookRepositoryImpl _repository;

  /// 생성자.
  const CodebookInitializer({required CodebookRepositoryImpl repository})
    : _repository = repository;

  /// 코드북 및 객관식 질문 코드북을 최신 버전으로 동기화한다.
  Future<CodebookInitializeResult> initialize() async {
    final syncResult = await _repository.sync();

    return CodebookInitializeResult(syncResult: syncResult);
  }
}

/// 코드북 초기화 결과.
class CodebookInitializeResult {
  /// 코드북 동기화 결과.
  final BootstrapCodebookSyncResult syncResult;

  /// 생성자.
  const CodebookInitializeResult({required this.syncResult});

  /// 초기화 성공 여부.
  bool get success => syncResult.success;

  /// 오프라인 캐시 사용 여부.
  bool get usedOfflineCache => syncResult.usedOfflineCache;

  /// 실패 시 에러 메시지.
  String? get errorMessage => syncResult.errorMessage;
}

import 'package:wingle/app/bootstrap/initializers/codebook_initializer.dart';

/// 앱 시작 시 필요한 선행 작업을 순서대로 실행한다.
class BootstrapInitializer {
  /// 코드북 초기화 작업.
  final CodebookInitializer codebookInitializer;

  /// 생성자.
  const BootstrapInitializer({required this.codebookInitializer});

  /// 전체 부트스트랩 초기화를 실행한다.
  Future<BootstrapInitializeResult> initialize() async {
    final codebookResult = await codebookInitializer.initialize();

    return BootstrapInitializeResult(codebook: codebookResult);
  }
}

/// 앱 부트스트랩 초기화 결과.
class BootstrapInitializeResult {
  /// 코드북 초기화 결과.
  final CodebookInitializeResult codebook;

  /// 생성자.
  const BootstrapInitializeResult({required this.codebook});

  /// 전체 초기화 성공 여부.
  bool get success => codebook.success;
}
